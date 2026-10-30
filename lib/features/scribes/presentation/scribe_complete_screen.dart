import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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

  Future<void> _redirectToOfficialPortal(BuildContext context) async {
    final portalUrl = scribe?.officialPortalUrl;

    if (portalUrl == null || portalUrl.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Official portal link is currently unavailable for this service.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Validate URL scheme safety (HTTPS / HTTP only)
    final uri = Uri.tryParse(portalUrl.trim());
    if (uri == null || (!uri.isScheme('HTTPS') && !uri.isScheme('HTTP'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Official portal link is currently unavailable for this service.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Show confirmation dialog before redirecting
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Continue to Official Government Portal?'),
          content: const Text(
            'You have completed the GovEase guidance. You will now be redirected to the official government website to continue your application.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch official portal URL. Please check your browser settings.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not launch official portal URL. Please check your browser settings.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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

                // Official Government Portal Redirection Button
                ElevatedButton.icon(
                  onPressed: () => _redirectToOfficialPortal(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(52),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.open_in_new, color: Colors.white, size: 20),
                  label: const Text(
                    'Continue to Official Government Portal',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

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
                      fontSize: 15,
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
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Back to Scribes',
                    style: TextStyle(
                      fontSize: 15,
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
