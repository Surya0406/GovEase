import 'package:flutter/material.dart';

class HelpFaqScreen extends StatelessWidget {
  const HelpFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & FAQ'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          ExpansionTile(
            title: Text('Does GovEase submit forms on my behalf?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No. GovEase is an educational walkthrough guide (scribe). It teaches you how to fill out government forms on official portals.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Are my documents uploaded to a cloud server?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No. All documents added to your Secure Vault are stored locally on your device with AES-256 encryption.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('What happens if I sign out?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Signing out locks your vault and clears temporary decrypted files. Your encrypted files remain safely stored until you log back in.'),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Which document formats are supported?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('GovEase supports PDF, JPEG, PNG, and DOC formats up to 30 MB.'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
