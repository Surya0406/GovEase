import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum TtsState { stopped, playing, paused }

class VoiceGuidanceService extends ChangeNotifier {
  static final VoiceGuidanceService instance = VoiceGuidanceService._internal();
  factory VoiceGuidanceService() => instance;
  VoiceGuidanceService._internal() {
    _loadSavedLanguage();
  }

  static const MethodChannel _channel = MethodChannel('com.example.govease/tts');

  TtsState _ttsState = TtsState.stopped;
  String _selectedLanguage = 'en'; // 'en', 'hi', 'ta'

  TtsState get ttsState => _ttsState;
  String get selectedLanguage => _selectedLanguage;

  static const String _prefKey = 'selected_voice_lang';

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedLanguage = prefs.getString(_prefKey) ?? 'en';
    notifyListeners();
  }

  Future<void> setLanguage(String langCode) async {
    _selectedLanguage = langCode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, langCode);
    stop();
  }

  String getTtsLocale(String langCode) {
    switch (langCode) {
      case 'hi':
        return 'hi-IN';
      case 'ta':
        return 'ta-IN';
      case 'en':
      default:
        return 'en-IN';
    }
  }

  Future<bool> speak(String text) async {
    await stop();
    final locale = getTtsLocale(_selectedLanguage);

    try {
      final bool? success = await _channel.invokeMethod<bool>('speak', {
        'text': text,
        'lang': locale,
      });

      if (success == true) {
        _ttsState = TtsState.playing;
        notifyListeners();
        return true;
      }
      return false;
    } catch (_) {
      _ttsState = TtsState.stopped;
      notifyListeners();
      return false;
    }
  }

  Future<void> pause() async {
    await stop();
  }

  Future<void> stop() async {
    try {
      await _channel.invokeMethod('stop');
    } catch (_) {}
    _ttsState = TtsState.stopped;
    notifyListeners();
  }
}
