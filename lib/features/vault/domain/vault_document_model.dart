class VaultDocumentModel {
  final int? id;
  final String docId;
  final String ownerId;
  final String displayName;
  final String category;
  final String mimeType;
  final String fileExtension;
  final String encryptedFilePath;
  final int fileSize;
  final String sha256Hash;
  final String ivBase64;
  final String createdAt;

  VaultDocumentModel({
    this.id,
    required this.docId,
    required this.ownerId,
    required this.displayName,
    required this.category,
    required this.mimeType,
    required this.fileExtension,
    required this.encryptedFilePath,
    required this.fileSize,
    required this.sha256Hash,
    required this.ivBase64,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'doc_id': docId,
      'owner_id': ownerId,
      'display_name': displayName,
      'file_category': category,
      'mime_type': mimeType,
      'file_extension': fileExtension,
      'encrypted_file_path': encryptedFilePath,
      'file_size': fileSize,
      'sha256_hash': sha256Hash,
      'iv_base64': ivBase64,
      'created_at': createdAt,
    };
  }

  factory VaultDocumentModel.fromMap(Map<String, dynamic> map) {
    return VaultDocumentModel(
      id: map['id'] as int?,
      docId: map['doc_id'] as String,
      ownerId: map['owner_id'] as String,
      displayName: map['display_name'] as String,
      category: map['file_category'] as String,
      mimeType: map['mime_type'] as String,
      fileExtension: map['file_extension'] as String,
      encryptedFilePath: map['encrypted_file_path'] as String,
      fileSize: map['file_size'] as int,
      sha256Hash: map['sha256_hash'] as String,
      ivBase64: map['iv_base64'] as String,
      createdAt: map['created_at'] as String,
    );
  }
}
