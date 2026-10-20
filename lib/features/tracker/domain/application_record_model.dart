class ApplicationRecordModel {
  final int? id;
  final String trackId;
  final String ownerId;
  final String serviceName;
  final String department;
  final String? refNumber;
  final String dateSubmitted;
  final String currentStatus;
  final String? notes;
  final String createdAt;

  ApplicationRecordModel({
    this.id,
    required this.trackId,
    required this.ownerId,
    required this.serviceName,
    required this.department,
    this.refNumber,
    required this.dateSubmitted,
    required this.currentStatus,
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'track_id': trackId,
      'owner_id': ownerId,
      'service_name': serviceName,
      'department': department,
      'ref_number': refNumber,
      'date_submitted': dateSubmitted,
      'current_status': currentStatus,
      'notes': notes,
      'created_at': createdAt,
    };
  }

  factory ApplicationRecordModel.fromMap(Map<String, dynamic> map) {
    return ApplicationRecordModel(
      id: map['id'] as int?,
      trackId: map['track_id'] as String,
      ownerId: map['owner_id'] as String,
      serviceName: map['service_name'] as String,
      department: map['department'] as String,
      refNumber: map['ref_number'] as String?,
      dateSubmitted: map['date_submitted'] as String,
      currentStatus: map['current_status'] as String,
      notes: map['notes'] as String?,
      createdAt: map['created_at'] as String,
    );
  }
}

class StatusHistoryModel {
  final int? id;
  final String trackId;
  final String ownerId;
  final String status;
  final String? notes;
  final String changedAt;

  StatusHistoryModel({
    this.id,
    required this.trackId,
    required this.ownerId,
    required this.status,
    this.notes,
    required this.changedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'track_id': trackId,
      'owner_id': ownerId,
      'status': status,
      'notes': notes,
      'changed_at': changedAt,
    };
  }

  factory StatusHistoryModel.fromMap(Map<String, dynamic> map) {
    return StatusHistoryModel(
      id: map['id'] as int?,
      trackId: map['track_id'] as String,
      ownerId: map['owner_id'] as String,
      status: map['status'] as String,
      notes: map['notes'] as String?,
      changedAt: map['changed_at'] as String,
    );
  }
}
