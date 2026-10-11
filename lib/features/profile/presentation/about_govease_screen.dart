import 'package:flutter/material.dart';

class AboutGovEaseScreen extends StatelessWidget {
  const AboutGovEaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About GovEase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/app_logo.png'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'GovEase',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              'GovEase makes government portal navigation effortless through interactive, step-by-step scribes. Store your essential government documents in a hardware-encrypted local vault, practice applications safely, and file with confidence.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const Spacer(),
            const Text(
              '© 2026 GovEase • Local Encrypted Vault Architecture',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
