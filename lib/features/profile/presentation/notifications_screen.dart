import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _vaultAlerts = true;
  bool _scribeUpdates = true;
  bool _securityAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Vault Security Alerts'),
            subtitle: const Text('Get notified when new documents are encrypted or modified.'),
            value: _vaultAlerts,
            onChanged: (val) => setState(() => _vaultAlerts = val),
          ),
          SwitchListTile(
            title: const Text('Scribe Guide Updates'),
            subtitle: const Text('Receive alerts when government portal procedures change.'),
            value: _scribeUpdates,
            onChanged: (val) => setState(() => _scribeUpdates = val),
          ),
          SwitchListTile(
            title: const Text('Security & Account Alerts'),
            subtitle: const Text('Important security notices regarding your local vault.'),
            value: _securityAlerts,
            onChanged: (val) => setState(() => _securityAlerts = val),
          ),
        ],
      ),
    );
  }
}
