import 'package:flutter/material.dart';
import '../../../core/session/session_manager.dart';

class AccountInfoScreen extends StatelessWidget {
  const AccountInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final session = SessionManager.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Information'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _infoTile('Full Name', session.fullName, Icons.person),
          _infoTile('Mobile Number', session.mobile.isEmpty ? 'Not Provided' : session.mobile, Icons.phone),
          _infoTile('Email Address', session.email.isEmpty ? 'Not Provided' : session.email, Icons.email),
          _infoTile('Account Status', 'Active & Verified', Icons.verified_user),
          _infoTile('Storage Type', 'Local Encrypted Vault', Icons.security),
        ],
      ),
    );
  }

  Widget _infoTile(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue.shade700),
        title: Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
