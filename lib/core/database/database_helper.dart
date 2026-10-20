import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/tracker/domain/application_record_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Normalize phone number to strip all spaces/dashes/parentheses
  static String normalizePhone(String input) {
    return input.replaceAll(RegExp(r'[^\d+]'), '');
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'govease.db');
    return await openDatabase(
      path,
      version: 4, // Version 4 adds application_tracker & status_history tables
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('DROP TABLE IF EXISTS users');
        }
        await _onCreate(db, newVersion);
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullName TEXT NOT NULL,
        mobile TEXT UNIQUE NOT NULL,
        email TEXT,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS vault_documents(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        doc_id TEXT UNIQUE NOT NULL,
        owner_id TEXT NOT NULL,
        display_name TEXT NOT NULL,
        file_category TEXT NOT NULL,
        mime_type TEXT NOT NULL,
        file_extension TEXT NOT NULL,
        encrypted_file_path TEXT NOT NULL,
        file_size INTEGER NOT NULL,
        sha256_hash TEXT NOT NULL,
        iv_base64 TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS application_tracker(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        track_id TEXT UNIQUE NOT NULL,
        owner_id TEXT NOT NULL,
        service_name TEXT NOT NULL,
        department TEXT NOT NULL,
        ref_number TEXT,
        date_submitted TEXT NOT NULL,
        current_status TEXT NOT NULL,
        notes TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS status_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        track_id TEXT NOT NULL,
        owner_id TEXT NOT NULL,
        status TEXT NOT NULL,
        notes TEXT,
        changed_at TEXT NOT NULL
      )
    ''');
  }

  Future<int> registerUser(Map<String, dynamic> user) async {
    Database db = await database;
    
    String rawMobile = user['mobile'] ?? '';
    String cleanMobile = normalizePhone(rawMobile);
    
    if (cleanMobile.isEmpty) {
      throw Exception('Please enter a valid mobile number');
    }

    Map<String, dynamic> userMap = {
      'fullName': user['fullName'] ?? '',
      'mobile': cleanMobile,
      'email': (user['email'] ?? '').toString().trim(),
      'password': user['password'] ?? '',
    };

    // Check if mobile number is already registered
    List<Map<String, dynamic>> existing = await db.query(
      'users',
      where: 'mobile = ?',
      whereArgs: [cleanMobile],
    );

    if (existing.isNotEmpty) {
      throw Exception('Mobile number is already registered. Please log in.');
    }

    return await db.insert('users', userMap);
  }

  Future<Map<String, dynamic>?> loginUser(String identifier, String password) async {
    Database db = await database;
    String cleanIdentifier = normalizePhone(identifier);

    // Match normalized mobile, raw mobile, or email
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: '(mobile = ? OR mobile = ? OR email = ?) AND password = ?',
      whereArgs: [cleanIdentifier, identifier, identifier, password],
    );

    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  // Application Tracker CRUD
  Future<void> createTrackingRecord(ApplicationRecordModel record) async {
    Database db = await database;
    await db.insert('application_tracker', record.toMap());

    // Insert initial status history entry
    final history = StatusHistoryModel(
      trackId: record.trackId,
      ownerId: record.ownerId,
      status: record.currentStatus,
      notes: record.notes ?? 'Application record created.',
      changedAt: record.createdAt,
    );
    await db.insert('status_history', history.toMap());
  }

  Future<List<ApplicationRecordModel>> getTrackingRecordsForOwner(String ownerId) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'application_tracker',
      where: 'owner_id = ?',
      whereArgs: [ownerId],
      orderBy: 'created_at DESC',
    );
    return results.map((m) => ApplicationRecordModel.fromMap(m)).toList();
  }

  Future<List<StatusHistoryModel>> getStatusHistoryForTrackId(String ownerId, String trackId) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'status_history',
      where: 'owner_id = ? AND track_id = ?',
      whereArgs: [ownerId, trackId],
      orderBy: 'changed_at DESC',
    );
    return results.map((m) => StatusHistoryModel.fromMap(m)).toList();
  }

  Future<void> updateTrackingStatus({
    required String ownerId,
    required String trackId,
    required String newStatus,
    String? notes,
  }) async {
    Database db = await database;
    final now = DateTime.now().toIso8601String();

    await db.update(
      'application_tracker',
      {'current_status': newStatus},
      where: 'owner_id = ? AND track_id = ?',
      whereArgs: [ownerId, trackId],
    );

    final history = StatusHistoryModel(
      trackId: trackId,
      ownerId: ownerId,
      status: newStatus,
      notes: notes,
      changedAt: now,
    );
    await db.insert('status_history', history.toMap());
  }

  Future<void> editTrackingRecord({
    required String ownerId,
    required String trackId,
    required String serviceName,
    required String department,
    String? refNumber,
    String? notes,
  }) async {
    Database db = await database;
    await db.update(
      'application_tracker',
      {
        'service_name': serviceName.trim(),
        'department': department.trim(),
        'ref_number': refNumber?.trim(),
        'notes': notes?.trim(),
      },
      where: 'owner_id = ? AND track_id = ?',
      whereArgs: [ownerId, trackId],
    );
  }

  Future<void> deleteTrackingRecord({
    required String ownerId,
    required String trackId,
  }) async {
    Database db = await database;
    await db.delete(
      'application_tracker',
      where: 'owner_id = ? AND track_id = ?',
      whereArgs: [ownerId, trackId],
    );
    await db.delete(
      'status_history',
      where: 'owner_id = ? AND track_id = ?',
      whereArgs: [ownerId, trackId],
    );
  }
}
