import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontProvider extends ChangeNotifier {
  static const String _fontKey = 'selected_font';

  // الخطوط المتاحة
  static const String fontCairo = 'Cairo';
  static const String fontTajawal = 'Tajawal'; // الخط البديل "الخط في الصورة"
  static const String fontAlmarai = 'Almarai';

  String _currentFont = fontCairo;

  String get currentFont => _currentFont;

  FontProvider() {
    _loadFont();
  }

  Future<void> _loadFont() async {
    final prefs = await SharedPreferences.getInstance();
    _currentFont = prefs.getString(_fontKey) ?? fontCairo; // الافتراضي Cairo
    notifyListeners();
  }

  Future<void> changeFont(String fontName) async {
    if (_currentFont == fontName) return;

    _currentFont = fontName;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fontKey, fontName);
  }
}
