import 'package:flutter/material.dart';

class SecurityPrivacyScreen extends StatelessWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security & Privacy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _securityCard(
            title: 'AES-256 Document Encryption',
            description: 'All documents imported into your vault are encrypted on-device before being saved into internal storage.',
            icon: Icons.enhanced_encryption,
          ),
          _securityCard(
            title: 'Android Keystore / iOS Keychain',
            description: 'Cryptographic master keys are stored securely using hardware-backed platform keystore facilities.',
            icon: Icons.vpn_key,
          ),
          _securityCard(
            title: 'Per-User Vault Isolation',
            description: 'Each account has a completely isolated vault. Switching accounts prevents unauthorized file access.',
            icon: Icons.shield,
          ),
          _securityCard(
            title: 'Zero Third-Party Cloud Uploads',
            description: 'GovEase stores your documents 100% locally on your device. We do not upload your sensitive files to cloud servers.',
            icon: Icons.cloud_off,
          ),
        ],
      ),
    );
  }

  Widget _securityCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: Colors.blue.shade700),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 6),
                  Text(description, style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
