import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('GovEase Privacy Policy', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Last updated: November 2026', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            Text(
              '1. Local Data Storage\nGovEase operates on a local-first architecture. User credentials and document metadata are saved in a local SQLite database on your device. Document contents are encrypted using hardware-backed AES-256 keys and saved exclusively inside your app private internal storage.\n\n'
              '2. No Remote Document Uploads\nGovEase does NOT upload, synchronize, or transmit your saved government documents, identity cards, or marksheets to external cloud services or third-party servers.\n\n'
              '3. User Data Isolation\nEvery account on GovEase receives isolated vault protection. Switching accounts clears decrypted in-memory caches and locks access to documents created by other users.\n\n'
              '4. Educational Purpose\nGovEase is an independent educational tool designed to guide users through government portal procedures. It is not affiliated with any government agency.',
              style: TextStyle(height: 1.5, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
