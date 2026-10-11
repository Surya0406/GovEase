import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Terms of Use', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Last updated: November 2026', style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            Text(
              '1. Acceptance of Terms\nBy accessing and using GovEase, you agree to comply with these Terms and Conditions.\n\n'
              '2. Non-Government Disclaimer\nGovEase is an independent educational platform. It does not submit application forms or official documents to government portals on your behalf. Users must submit official applications directly on authorized government websites.\n\n'
              '3. Local Vault Security\nUsers are responsible for maintaining the physical security and passcode protection of their mobile devices. GovEase provides AES-256 local encryption for vault files.\n\n'
              '4. Limitation of Liability\nGovEase provides educational scribes "as is" and shall not be held liable for changes in government portal procedures, external delays, or official portal downtime.',
              style: TextStyle(height: 1.5, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
