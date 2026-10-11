import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManager extends ChangeNotifier {
  static final SessionManager instance = SessionManager._internal();
  factory SessionManager() => instance;
  SessionManager._internal();

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyFullName = 'user_full_name';
  static const String _keyMobile = 'user_mobile';
  static const String _keyEmail = 'user_email';

  bool _isLoggedIn = false;
  String _fullName = 'User';
  String _mobile = '';
  String _email = '';

  bool get isLoggedIn => _isLoggedIn;
  String get fullName => _fullName;
  String get mobile => _mobile;
  String get email => _email;
  
  // Stable unique owner ID for vault isolation
  String get currentUserOwnerId => _mobile.isNotEmpty ? _mobile : 'guest_user';

  Future<void> initSession() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    _fullName = prefs.getString(_keyFullName) ?? 'GovEase User';
    _mobile = prefs.getString(_keyMobile) ?? '';
    _email = prefs.getString(_keyEmail) ?? '';
    notifyListeners();
  }

  Future<void> saveUserSession({
    required String fullName,
    required String mobile,
    String? email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = true;
    _fullName = fullName.isNotEmpty ? fullName : 'GovEase User';
    _mobile = mobile;
    _email = email ?? '';

    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyFullName, _fullName);
    await prefs.setString(_keyMobile, _mobile);
    await prefs.setString(_keyEmail, _email);

    notifyListeners();
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    _fullName = 'User';
    _mobile = '';
    _email = '';
    notifyListeners();
  }
}
