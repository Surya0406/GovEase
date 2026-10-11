import 'package:flutter/material.dart';
import '../../../core/session/session_manager.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../auth/presentation/login_screen.dart';
import '../../vault/presentation/vault_screen.dart';
import '../../vault/services/vault_service.dart';
import 'about_govease_screen.dart';
import 'account_info_screen.dart';
import 'edit_profile_screen.dart';
import 'help_faq_screen.dart';
import 'notifications_screen.dart';
import 'privacy_policy_screen.dart';
import 'security_privacy_screen.dart';
import 'terms_conditions_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    SessionManager.instance.addListener(_onSessionUpdate);
  }

  @override
  void dispose() {
    SessionManager.instance.removeListener(_onSessionUpdate);
    super.dispose();
  }

  void _onSessionUpdate() {
    if (mounted) setState(() {});
  }

  void _showThemeSelector() {
    final currentMode = ThemeProvider.instance.themeMode;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Appearance & Theme',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('System Default'),
                trailing: currentMode == ThemeMode.system ? Icon(Icons.check_circle, color: Colors.blue.shade700) : null,
                onTap: () {
                  ThemeProvider.instance.setThemeMode(ThemeMode.system);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Light Mode'),
                trailing: currentMode == ThemeMode.light ? Icon(Icons.check_circle, color: Colors.blue.shade700) : null,
                onTap: () {
                  ThemeProvider.instance.setThemeMode(ThemeMode.light);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Dark Mode'),
                trailing: currentMode == ThemeMode.dark ? Icon(Icons.check_circle, color: Colors.blue.shade700) : null,
                onTap: () {
                  ThemeProvider.instance.setThemeMode(ThemeMode.dark);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleSignOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out? Your encrypted vault will remain safely stored on this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    // Clear temp decrypted files and session
    await VaultService.instance.clearTempDecryptedFiles();
    await SessionManager.instance.clearSession();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionManager.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String initials = session.fullName.isNotEmpty
        ? session.fullName.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase()
        : 'GE';

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      appBar: AppBar(
        title: const Text('Profile & Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          // User Avatar & Name Header Card
          Card(
            color: isDark ? AppColors.darkCard : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.blue.shade700,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.fullName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          session.mobile.isNotEmpty ? session.mobile : (session.email.isNotEmpty ? session.email : 'GovEase Account'),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue.shade700),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text('ACCOUNT & VAULT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),

          _menuItem(
            context,
            icon: Icons.shield_outlined,
            iconColor: Colors.blue.shade700,
            title: 'My Documents / Secure Vault',
            subtitle: 'AES-256 local encrypted storage',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VaultScreen()),
              );
            },
          ),
          _menuItem(
            context,
            icon: Icons.account_circle_outlined,
            iconColor: Colors.teal,
            title: 'Account Information',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountInfoScreen()),
              );
            },
          ),
          _menuItem(
            context,
            icon: Icons.dark_mode_outlined,
            iconColor: Colors.purple,
            title: 'Appearance & Theme',
            subtitle: _themeModeLabel(ThemeProvider.instance.themeMode),
            onTap: _showThemeSelector,
          ),

          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text('SECURITY & PREFERENCES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),

          _menuItem(
            context,
            icon: Icons.security_outlined,
            iconColor: Colors.amber.shade800,
            title: 'Security & Privacy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecurityPrivacyScreen()),
              );
            },
          ),
          _menuItem(
            context,
            icon: Icons.notifications_none_outlined,
            iconColor: Colors.indigo,
            title: 'Notifications',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationsScreen()),
              );
            },
          ),

          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text('SUPPORT & LEGAL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),

          _menuItem(
            context,
            icon: Icons.help_outline,
            iconColor: Colors.green,
            title: 'Help & FAQ',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpFaqScreen()),
              );
            },
          ),
          _menuItem(
            context,
            icon: Icons.privacy_tip_outlined,
            iconColor: Colors.deepOrange,
            title: 'Privacy Policy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
              );
            },
          ),
          _menuItem(
            context,
            icon: Icons.description_outlined,
            iconColor: Colors.blueGrey,
            title: 'Terms & Conditions',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TermsConditionsScreen()),
              );
            },
          ),
          _menuItem(
            context,
            icon: Icons.info_outline,
            iconColor: Colors.cyan.shade800,
            title: 'About GovEase',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutGovEaseScreen()),
              );
            },
          ),

          const SizedBox(height: 24),

          // Sign Out Button
          ElevatedButton.icon(
            onPressed: _handleSignOut,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade50,
              foregroundColor: Colors.red,
              minimumSize: const Size.fromHeight(52),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      color: isDark ? AppColors.darkCard : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: iconColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }

  String _themeModeLabel(ThemeMode mode) {
    if (mode == ThemeMode.light) return 'Light Mode';
    if (mode == ThemeMode.dark) return 'Dark Mode';
    return 'System Default';
  }
}
