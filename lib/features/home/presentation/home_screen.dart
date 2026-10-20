import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/session/session_manager.dart';
import '../../../core/theme/app_colors.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../scribes/data/scribe_data.dart';
import '../../scribes/presentation/scribe_detail_screen.dart';
import '../../tracker/domain/application_record_model.dart';
import '../../tracker/presentation/application_detail_screen.dart';
import '../../vault/presentation/vault_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Tracker state
  List<ApplicationRecordModel> _trackingRecords = [];
  bool _isLoadingTracker = false;

  final List<String> _statusOptions = [
    'Submitted',
    'Draft',
    'Under Review',
    'Action Required',
    'Approved',
    'Rejected',
    'Completed',
  ];

  @override
  void initState() {
    super.initState();
    _loadTrackingRecords();
  }

  Future<void> _loadTrackingRecords() async {
    setState(() => _isLoadingTracker = true);
    final ownerId = SessionManager.instance.currentUserOwnerId;
    final records = await DatabaseHelper().getTrackingRecordsForOwner(ownerId);
    if (!mounted) return;
    setState(() {
      _trackingRecords = records;
      _isLoadingTracker = false;
    });
  }

  Future<void> _showAddApplicationDialog() async {
    final serviceNameController = TextEditingController();
    final deptController = TextEditingController();
    final refController = TextEditingController();
    final notesController = TextEditingController();

    String selectedStatus = 'Submitted';
    String selectedDate = DateTime.now().toIso8601String().substring(0, 10);

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Add Application Record'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: serviceNameController,
                      decoration: const InputDecoration(
                        labelText: 'Service / Scheme Name *',
                        hintText: 'e.g. Aadhaar Card Update',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: deptController,
                      decoration: const InputDecoration(
                        labelText: 'Department / Authority *',
                        hintText: 'e.g. UIDAI',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: refController,
                      decoration: const InputDecoration(
                        labelText: 'Reference Number (Optional)',
                        hintText: 'e.g. URN 1234/5678/90',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedStatus,
                      decoration: const InputDecoration(
                        labelText: 'Current Status',
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
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes / Remarks (Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (serviceNameController.text.trim().isEmpty ||
                        deptController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill required fields.')),
                      );
                      return;
                    }
                    Navigator.pop(context, true);
                  },
                  child: const Text('Save Record'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirm != true) return;

    final ownerId = SessionManager.instance.currentUserOwnerId;
    final trackId = 'TRK_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999)}';
    final now = DateTime.now().toIso8601String();

    final record = ApplicationRecordModel(
      trackId: trackId,
      ownerId: ownerId,
      serviceName: serviceNameController.text.trim(),
      department: deptController.text.trim(),
      refNumber: refController.text.trim().isEmpty ? null : refController.text.trim(),
      dateSubmitted: selectedDate,
      currentStatus: selectedStatus,
      notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
      createdAt: now,
    );

    await DatabaseHelper().createTrackingRecord(record);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Application record saved to local tracker!'), backgroundColor: Colors.green),
    );

    _loadTrackingRecords();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Approved':
      case 'Completed':
        return Colors.green.shade700;
      case 'Under Review':
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildScribesTab(context, isDark),
          _buildProgressTab(context, isDark),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            _loadTrackingRecords();
          }
        },
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
        backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
        elevation: 16,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Scribes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildScribesTab(BuildContext context, bool isDark) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        elevation: 0,
        titleSpacing: 24,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'स',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'GovEase',
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose a scribe',
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.primary,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Guided walkthroughs of real government portals — practice before you file for real.',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              
              _buildScribeCard(context, scribe: sampleScribes[0], isDark: isDark),
              _buildScribeCard(context, scribe: sampleScribes[1], isDark: isDark),
              _buildScribeCard(context, scribe: sampleScribes[2], isDark: isDark),
              _buildScribeCard(context, scribe: sampleScribes[3], isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressTab(BuildContext context, bool isDark) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Progress & Tracker', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // 1. Practice Progress Card
          Card(
            color: isDark ? AppColors.darkCard : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Overall Scribe Practice', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('2 / 4 Completed', style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: 0.5,
                      minHeight: 10,
                      backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 2. Secure Local Vault Card Shortcut
          Card(
            color: isDark ? AppColors.darkCard : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade50,
                child: Icon(Icons.shield_outlined, color: Colors.blue.shade700),
              ),
              title: const Text('Secure Local Document Vault', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Store and view your encrypted government records offline.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VaultScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 28),

          // 3. Government Application Tracker Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Application Tracker',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: _showAddApplicationDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Record'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Demo Notice Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.amber.shade900, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Demo Tracking: Records and status updates are managed locally for user tracking and practice.',
                    style: TextStyle(fontSize: 12, color: Colors.amber.shade900, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Records List / Empty State
          _isLoadingTracker
              ? const Center(child: CircularProgressIndicator())
              : _trackingRecords.isEmpty
                  ? Card(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          children: [
                            Icon(Icons.track_changes, size: 56, color: Colors.blue.shade300),
                            const SizedBox(height: 12),
                            const Text(
                              'No Applications Tracked Yet',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Record your submitted government portal applications to track status updates locally.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _trackingRecords.length,
                      itemBuilder: (context, index) {
                        final item = _trackingRecords[index];
                        final statusColor = _getStatusColor(item.currentStatus);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          color: isDark ? AppColors.darkCard : Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            title: Text(
                              item.serviceName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(
                                '${item.department}${item.refNumber != null ? ' • Ref: ${item.refNumber}' : ''}',
                                style: const TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: statusColor),
                                  ),
                                  child: Text(
                                    item.currentStatus,
                                    style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.dateSubmitted,
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                            onTap: () async {
                              final updated = await Navigator.push<bool>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ApplicationDetailScreen(record: item),
                                ),
                              );
                              if (updated == true) {
                                _loadTrackingRecords();
                              }
                            },
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }

  Widget _buildScribeCard(
    BuildContext context, {
    required Scribe scribe,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScribeDetailScreen(scribe: scribe),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                scribe.iconLetter,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          scribe.title,
                          style: TextStyle(
                            color: isDark ? Colors.white : AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.blue.shade700,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    scribe.subtitle,
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black45,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildTag(scribe.stepsCount, isDark),
                      const SizedBox(width: 8),
                      _buildTag(scribe.duration, isDark),
                      const SizedBox(width: 8),
                      _buildTag(scribe.level, isDark),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : Colors.lightBlue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue.shade700,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
