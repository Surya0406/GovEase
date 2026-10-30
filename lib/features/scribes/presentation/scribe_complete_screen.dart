import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/session/session_manager.dart';
import '../../tracker/domain/application_record_model.dart';
import '../data/scribe_data.dart';

class ScribeCompleteScreen extends StatelessWidget {
  final Scribe? scribe;

  const ScribeCompleteScreen({
    super.key,
    this.scribe,
  });

  Future<void> _addToTracker(BuildContext context) async {
    final ownerId = SessionManager.instance.currentUserOwnerId;
    final randomNum = Random().nextInt(8999) + 1000;
    final trackId = 'GE-2026-$randomNum';
    final now = DateTime.now().toIso8601String();

    final record = ApplicationRecordModel(
      trackId: trackId,
      ownerId: ownerId,
      serviceName: scribe?.title ?? 'Government Application',
      department: scribe?.subtitle ?? 'GovEase Portal',
      refNumber: 'REF-$randomNum',
      dateSubmitted: now.substring(0, 10),
      currentStatus: 'Submitted',
      notes: 'Recorded upon completing GovEase Scribe walkthrough.',
      createdAt: now,
    );

    await DatabaseHelper().createTrackingRecord(record);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Application added to Tracker with ID: $trackId'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF001F54),
              Color(0xFF0058A3),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  width: 44,
                  height: 72,
                  decoration: BoxDecoration(
                    color: const Color(0x33FFFFFF),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Scribe Complete!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'You now know the full path for this service.\nReady to try it on the real portal.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),

                // Track Application Button
                ElevatedButton.icon(
                  onPressed: () => _addToTracker(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent.shade400,
                    foregroundColor: Colors.black87,
                    minimumSize: const Size.fromHeight(52),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.track_changes, color: Colors.black87),
                  label: const Text(
                    'Track This Application',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Back to Scribes button
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Back to Scribes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
