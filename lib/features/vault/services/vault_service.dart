import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../core/database/database_helper.dart';
import '../domain/vault_document_model.dart';

class VaultService {
  static final VaultService instance = VaultService._internal();
  factory VaultService() => instance;
  VaultService._internal();

  final _secureStorage = const FlutterSecureStorage();

  // Retrieve or generate a 256-bit AES master key tied securely to the user's keystore
  Future<encrypt.Key> _getOrCreateMasterKey(String ownerId) async {
    final storageKey = 'vault_key_$ownerId';
    String? existingKeyBase64 = await _secureStorage.read(key: storageKey);

    if (existingKeyBase64 == null) {
      final random = Random.secure();
      final keyBytes = List<int>.generate(32, (_) => random.nextInt(256));
      existingKeyBase64 = base64Url.encode(keyBytes);
      await _secureStorage.write(key: storageKey, value: existingKeyBase64);
    }

    final keyBytes = base64Url.decode(existingKeyBase64);
    return encrypt.Key(keyBytes);
  }

  // Import and Encrypt Document
  Future<VaultDocumentModel> importAndEncryptDocument({
    required File sourceFile,
    required String displayName,
    required String category,
    required String ownerId,
  }) async {
    if (!await sourceFile.exists()) {
      throw Exception('Selected source file does not exist.');
    }

    final fileSize = await sourceFile.length();
    if (fileSize > 30 * 1024 * 1024) { // 30 MB limit
      throw Exception('File size exceeds the 30MB limit for secure vault storage.');
    }

    final rawBytes = await sourceFile.readAsBytes();

    // 1. Calculate SHA-256 integrity hash of original bytes
    final sha256Digest = sha256.convert(rawBytes).toString();

    // 2. Generate unique secure IV for this document
    final iv = encrypt.IV.fromSecureRandom(16);

    // 3. Encrypt raw bytes with AES-256 CBC
    final key = await _getOrCreateMasterKey(ownerId);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encryptedData = encrypter.encryptBytes(rawBytes, iv: iv);

    // 4. Save encrypted bytes into App Private Internal Storage
    final appDocDir = await getApplicationDocumentsDirectory();
    final vaultDir = Directory(p.join(appDocDir.path, 'vault_encrypted'));
    if (!await vaultDir.exists()) {
      await vaultDir.create(recursive: true);
    }

    final docId = 'DOC_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(9999)}';
    final ext = p.extension(sourceFile.path).replaceAll('.', '').toLowerCase();
    final encFilePath = p.join(vaultDir.path, '$docId.enc');

    final encFile = File(encFilePath);
    await encFile.writeAsBytes(encryptedData.bytes, flush: true);

    // Determine MIME type based on extension
    String mimeType = 'application/octet-stream';
    if (ext == 'pdf') {
      mimeType = 'application/pdf';
    } else if (ext == 'jpg' || ext == 'jpeg') {
      mimeType = 'image/jpeg';
    } else if (ext == 'png') {
      mimeType = 'image/png';
    }

    final model = VaultDocumentModel(
      docId: docId,
      ownerId: ownerId,
      displayName: displayName.trim().isEmpty ? p.basename(sourceFile.path) : displayName.trim(),
      category: category,
      mimeType: mimeType,
      fileExtension: ext.isEmpty ? 'bin' : ext,
      encryptedFilePath: encFilePath,
      fileSize: fileSize,
      sha256Hash: sha256Digest,
      ivBase64: iv.base64,
      createdAt: DateTime.now().toIso8601String(),
    );

    // 5. Insert metadata into SQLite DB
    final db = await DatabaseHelper().database;
    await db.insert('vault_documents', model.toMap());

    return model;
  }

  // Fetch Documents with User Isolation
  Future<List<VaultDocumentModel>> getDocumentsForOwner(
    String ownerId, {
    String? searchQuery,
    String? categoryFilter,
    String sortBy = 'date_desc', // date_desc, date_asc, name_asc, size_desc
  }) async {
    final db = await DatabaseHelper().database;

    String whereClause = 'owner_id = ?';
    List<dynamic> whereArgs = [ownerId];

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      whereClause += ' AND display_name LIKE ?';
      whereArgs.add('%${searchQuery.trim()}%');
    }

    if (categoryFilter != null && categoryFilter != 'All') {
      whereClause += ' AND file_category = ?';
      whereArgs.add(categoryFilter);
    }

    String orderBy = 'created_at DESC';
    if (sortBy == 'date_asc') {
      orderBy = 'created_at ASC';
    } else if (sortBy == 'name_asc') {
      orderBy = 'display_name ASC';
    } else if (sortBy == 'size_desc') {
      orderBy = 'file_size DESC';
    }

    final maps = await db.query(
      'vault_documents',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: orderBy,
    );

    return maps.map((m) => VaultDocumentModel.fromMap(m)).toList();
  }

  // Decrypt Document to Temp File for Viewing
  Future<File> decryptDocumentToTempFile(String ownerId, VaultDocumentModel doc) async {
    // ENFORCE STRICT USER ISOLATION
    if (doc.ownerId != ownerId) {
      throw Exception('Access Denied: You are not authorized to view this document.');
    }

    final encFile = File(doc.encryptedFilePath);
    if (!await encFile.exists()) {
      throw Exception('Encrypted document file is missing from internal storage.');
    }

    final encryptedBytes = await encFile.readAsBytes();

    // 1. Decrypt using AES-256
    final key = await _getOrCreateMasterKey(ownerId);
    final iv = encrypt.IV.fromBase64(doc.ivBase64);
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final decryptedBytes = encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);

    // 2. Verify Integrity using SHA-256
    final sha256Digest = sha256.convert(decryptedBytes).toString();
    if (sha256Digest != doc.sha256Hash) {
      throw Exception('Security Failure: Document integrity check failed! The file may be tampered with or corrupted.');
    }

    // 3. Write to temporary application directory
    final tempDir = await getTemporaryDirectory();
    final decryptedDir = Directory(p.join(tempDir.path, 'vault_temp_view'));
    if (!await decryptedDir.exists()) {
      await decryptedDir.create(recursive: true);
    }

    final tempFile = File(p.join(decryptedDir.path, '${doc.docId}.${doc.fileExtension}'));
    await tempFile.writeAsBytes(decryptedBytes, flush: true);

    return tempFile;
  }

  // Delete Document securely
  Future<void> deleteDocument(String ownerId, VaultDocumentModel doc) async {
    if (doc.ownerId != ownerId) {
      throw Exception('Access Denied: Unauthorized deletion attempt.');
    }

    // Delete encrypted file from disk
    final encFile = File(doc.encryptedFilePath);
    if (await encFile.exists()) {
      await encFile.delete();
    }

    // Delete database record
    final db = await DatabaseHelper().database;
    await db.delete(
      'vault_documents',
      where: 'doc_id = ? AND owner_id = ?',
      whereArgs: [doc.docId, ownerId],
    );
  }

  // Rename Document
  Future<void> renameDocument(String ownerId, String docId, String newName) async {
    final db = await DatabaseHelper().database;
    await db.update(
      'vault_documents',
      {'display_name': newName.trim()},
      where: 'doc_id = ? AND owner_id = ?',
      whereArgs: [docId, ownerId],
    );
  }

  // Clear all temporary plaintext files on sign out or viewer exit
  Future<void> clearTempDecryptedFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final decryptedDir = Directory(p.join(tempDir.path, 'vault_temp_view'));
      if (await decryptedDir.exists()) {
        await decryptedDir.delete(recursive: true);
      }
    } catch (_) {
      // Ignore cleanup exceptions
    }
  }
}
