import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// مزود اللغة والاتجاه
/// يدير تبديل اللغة بين العربية والإنجليزية
/// ويتحكم في اتجاه التطبيق RTL/LTR
class LocaleProvider with ChangeNotifier {
  // المفتاح لحفظ اللغة
  static const String _localeKey = 'app_locale';
  
  // اللغة الافتراضية: العربية
  Locale _locale = const Locale('ar');
  
  // هل تم تحميل اللغة من التخزين؟
  bool _isLoaded = false;
  
  LocaleProvider() {
    _loadLocale();
  }
  
  // ========== Getters ==========
  
  /// اللغة الحالية
  Locale get locale => _locale;
  
  /// هل اللغة الحالية عربية؟
  bool get isArabic => _locale.languageCode == 'ar';
  
  /// هل اللغة الحالية إنجليزية؟
  bool get isEnglish => _locale.languageCode == 'en';
  
  /// اتجاه النص الحالي
  TextDirection get textDirection => 
      isArabic ? TextDirection.rtl : TextDirection.ltr;
  
  /// هل تم التحميل؟
  bool get isLoaded => _isLoaded;
  
  /// كود اللغة الحالية
  String get languageCode => _locale.languageCode;
  
  /// اسم اللغة الحالية (للعرض)
  String get languageName => isArabic ? 'العربية' : 'English';
  
  // ========== Methods ==========
  
  /// تحميل اللغة المحفوظة
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLocale = prefs.getString(_localeKey);
      
      if (savedLocale != null) {
        _locale = Locale(savedLocale);
      }
    } catch (e) {
      // في حالة الخطأ، نستخدم اللغة الافتراضية
      debugPrint('Error loading locale: $e');
    }
    
    _isLoaded = true;
    notifyListeners();
  }
  
  /// تغيير اللغة
  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;
    
    _locale = newLocale;
    notifyListeners();
    
    // حفظ اللغة
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, newLocale.languageCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
    }
  }
  
  /// تبديل اللغة بين العربية والإنجليزية
  Future<void> toggleLocale() async {
    final newLocale = isArabic ? const Locale('en') : const Locale('ar');
    await setLocale(newLocale);
  }
  
  /// تعيين اللغة العربية
  Future<void> setArabic() async {
    await setLocale(const Locale('ar'));
  }
  
  /// تعيين اللغة الإنجليزية
  Future<void> setEnglish() async {
    await setLocale(const Locale('en'));
  }
  
  // ========== اللغات المدعومة ==========
  
  /// قائمة اللغات المدعومة
  static const List<Locale> supportedLocales = [
    Locale('ar'), // العربية
    Locale('en'), // الإنجليزية
  ];
  
  /// قائمة اللغات المدعومة مع أسمائها
  static const Map<String, String> localeNames = {
    'ar': 'العربية',
    'en': 'English',
  };
}
