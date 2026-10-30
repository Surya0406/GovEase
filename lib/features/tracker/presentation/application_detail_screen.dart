import 'package:flutter/material.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/session/session_manager.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/application_record_model.dart';

class ApplicationDetailScreen extends StatefulWidget {
  final ApplicationRecordModel record;

  const ApplicationDetailScreen({
    super.key,
    required this.record,
  });

  @override
  State<ApplicationDetailScreen> createState() => _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState extends State<ApplicationDetailScreen> {
  late ApplicationRecordModel _currentRecord;
  List<StatusHistoryModel> _history = [];
  bool _isLoading = true;

  final List<String> _statusOptions = [
    'Draft',
    'Submitted',
    'Under Review',
    'Document Verification',
    'Processing',
    'Action Required',
    'Approved',
    'Rejected',
    'Completed',
    'On Hold',
  ];

  @override
  void initState() {
    super.initState();
    _currentRecord = widget.record;
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final ownerId = SessionManager.instance.currentUserOwnerId;
    final list = await DatabaseHelper().getStatusHistoryForTrackId(ownerId, _currentRecord.trackId);
    if (!mounted) return;
    setState(() {
      _history = list;
      _isLoading = false;
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
      case 'Completed':
        return Colors.green.shade700;
      case 'Under Review':
      case 'Document Verification':
      case 'Processing':
        return Colors.orange.shade800;
      case 'Action Required':
        return Colors.red.shade700;
      case 'Rejected':
        return Colors.red.shade900;
      case 'Submitted':
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Future<void> _simulateStageAdvance() async {
    final stages = [
      'Draft',
      'Submitted',
      'Under Review',
      'Document Verification',
      'Processing',
      'Approved',
      'Completed',
    ];

    int currentIndex = stages.indexOf(_currentRecord.currentStatus);
    if (currentIndex == -1 || currentIndex >= stages.length - 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Application has reached final stage or custom state.')),
      );
      return;
    }

    String nextStage = stages[currentIndex + 1];
    final ownerId = SessionManager.instance.currentUserOwnerId;

    await DatabaseHelper().updateTrackingStatus(
      ownerId: ownerId,
      trackId: _currentRecord.trackId,
      newStatus: nextStage,
      notes: 'Simulated stage advancement to $nextStage',
    );

    setState(() {
      _currentRecord = ApplicationRecordModel(
        id: _currentRecord.id,
        trackId: _currentRecord.trackId,
        ownerId: _currentRecord.ownerId,
        serviceName: _currentRecord.serviceName,
        department: _currentRecord.department,
        refNumber: _currentRecord.refNumber,
        dateSubmitted: _currentRecord.dateSubmitted,
        currentStatus: nextStage,
        notes: _currentRecord.notes,
        createdAt: _currentRecord.createdAt,
      );
    });

    _loadHistory();
  }

  Future<void> _updateStatus() async {
    String selectedStatus = _currentRecord.currentStatus;
    final noteController = TextEditingController();

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Update Application Status'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: selectedStatus,
                    decoration: const InputDecoration(
                      labelText: 'New Status',
                      border: OutlineInputBorder(),
                    ),
                    items: _statusOptions
                        .map((st) => DropdownMenuItem(value: st, child: Text(st)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedStatus = val);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: noteController,
                    decoration: const InputDecoration(
                      labelText: 'Update Note / Remark (Optional)',
                      hintText: 'e.g. Document verified, awaiting approval',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirm != true) return;

    final ownerId = SessionManager.instance.currentUserOwnerId;
    await DatabaseHelper().updateTrackingStatus(
      ownerId: ownerId,
      trackId: _currentRecord.trackId,
      newStatus: selectedStatus,
      notes: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
    );

    setState(() {
      _currentRecord = ApplicationRecordModel(
        id: _currentRecord.id,
        trackId: _currentRecord.trackId,
        ownerId: _currentRecord.ownerId,
        serviceName: _currentRecord.serviceName,
        department: _currentRecord.department,
        refNumber: _currentRecord.refNumber,
        dateSubmitted: _currentRecord.dateSubmitted,
        currentStatus: selectedStatus,
        notes: _currentRecord.notes,
        createdAt: _currentRecord.createdAt,
      );
    });

    _loadHistory();
  }

  Future<void> _editRecord() async {
    final nameController = TextEditingController(text: _currentRecord.serviceName);
    final deptController = TextEditingController(text: _currentRecord.department);
    final refController = TextEditingController(text: _currentRecord.refNumber ?? '');
    final notesController = TextEditingController(text: _currentRecord.notes ?? '');

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Application Details'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Service Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: deptController,
                  decoration: const InputDecoration(labelText: 'Department', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: refController,
                  decoration: const InputDecoration(labelText: 'Reference Number', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes', border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save Changes')),
          ],
        );
      },
    );

    if (confirm != true) return;

    final ownerId = SessionManager.instance.currentUserOwnerId;
    await DatabaseHelper().editTrackingRecord(
      ownerId: ownerId,
      trackId: _currentRecord.trackId,
      serviceName: nameController.text.trim(),
      department: deptController.text.trim(),
      refNumber: refController.text.trim().isEmpty ? null : refController.text.trim(),
      notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
    );

    setState(() {
      _currentRecord = ApplicationRecordModel(
        id: _currentRecord.id,
        trackId: _currentRecord.trackId,
        ownerId: _currentRecord.ownerId,
        serviceName: nameController.text.trim(),
        department: deptController.text.trim(),
        refNumber: refController.text.trim().isEmpty ? null : refController.text.trim(),
        dateSubmitted: _currentRecord.dateSubmitted,
        currentStatus: _currentRecord.currentStatus,
        notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
        createdAt: _currentRecord.createdAt,
      );
    });
  }

  Future<void> _deleteRecord() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record?'),
        content: Text('Are you sure you want to delete "${_currentRecord.serviceName}" from your tracker?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final ownerId = SessionManager.instance.currentUserOwnerId;
    await DatabaseHelper().deleteTrackingRecord(ownerId: ownerId, trackId: _currentRecord.trackId);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Record deleted.')));
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(_currentRecord.currentStatus);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Application Details', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: _editRecord),
          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: _deleteRecord),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Demo Banner Warning
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.amber.shade900),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Demo Tracking Mode: Statuses are user-updated locally for record-keeping and practice.',
                      style: TextStyle(fontSize: 12, color: Colors.amber.shade900, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Header Card
            Card(
              color: isDark ? AppColors.darkCard : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _currentRecord.serviceName,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: statusColor),
                          ),
                          child: Text(
                            _currentRecord.currentStatus,
                            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentRecord.department,
                      style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 15),
                    ),
                    const Divider(height: 24),
                    _infoRow('GovEase Tracking ID', _currentRecord.trackId),
                    _infoRow('Ref / Application No', _currentRecord.refNumber ?? 'N/A'),
                    _infoRow('Date Submitted', _currentRecord.dateSubmitted),
                    if (_currentRecord.notes != null && _currentRecord.notes!.isNotEmpty)
                      _infoRow('Notes', _currentRecord.notes!),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _simulateStageAdvance,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.fast_forward, size: 18),
                            label: const Text('Advance Stage', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _updateStatus,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.blue.shade700,
                              side: BorderSide(color: Colors.blue.shade300),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Update Status', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),
            const Text('Application Timeline', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final item = _history[index];
                      final color = _getStatusColor(item.status);
                      final formattedDate = item.changedAt.length >= 10 ? item.changedAt.substring(0, 10) : item.changedAt;

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 8,
                                backgroundColor: color,
                              ),
                              if (index < _history.length - 1)
                                Container(
                                  width: 2,
                                  height: 50,
                                  color: Colors.grey.shade400,
                                ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.status,
                                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        formattedDate,
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  if (item.notes != null && item.notes!.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      item.notes!,
                                      style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black87),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))),
          const SizedBox(width: 16),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
