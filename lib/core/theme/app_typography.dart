import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// نظام الخطوط المركزي
/// تغيير الخط هنا يؤثر على كل التطبيق
class AppTypography {
  // ========== الخطوط الأساسية ==========

  /// الخط العربي الأساسي - غيّره هنا ليتغير في كل التطبيق
  static String get arabicFontFamily => 'Cairo';

  /// الخط الإنجليزي الأساسي
  static String get englishFontFamily => 'Roboto';

  // ========== أحجام الخطوط ==========

  static const double displayLargeSize = 32.0;
  static const double displayMediumSize = 24.0;
  static const double displaySmallSize = 20.0;
  static const double headlineMediumSize = 18.0;
  static const double bodyLargeSize = 16.0;
  static const double bodyMediumSize = 14.0;
  static const double bodySmallSize = 12.0;
  static const double labelLargeSize = 14.0;

  // ========== دوال الحصول على الخط ==========

  /// الحصول على TextStyle مع الخط المناسب حسب اللغة
  static TextStyle _getTextStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    bool isArabic = true,
    double? height,
    String? fontFamily,
  }) {
    // استخدام الخط الممرر أو الافتراضي
    final selectedFont =
        fontFamily ?? (isArabic ? arabicFontFamily : englishFontFamily);

    return GoogleFonts.getFont(
      selectedFont,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  // ========== أنماط جاهزة للاستخدام ==========

  /// عنوان كبير (للشاشات الرئيسية)
  static TextStyle displayLarge({
    bool isArabic = true,
    Color? color,
    String? fontFamily,
  }) {
    return _getTextStyle(
      fontSize: displayLargeSize,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.textPrimary,
      isArabic: isArabic,
      fontFamily: fontFamily,
    );
  }

  /// عنوان متوسط
  static TextStyle displayMedium({
    bool isArabic = true,
    Color? color,
    String? fontFamily,
  }) {
    return _getTextStyle(
      fontSize: displayMediumSize,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.textPrimary,
      isArabic: isArabic,
      fontFamily: fontFamily,
    );
  }

  /// عنوان صغير
  static TextStyle displaySmall({
    bool isArabic = true,
    Color? color,
    String? fontFamily,
  }) {
    return _getTextStyle(
      fontSize: displaySmallSize,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.textPrimary,
      isArabic: isArabic,
      fontFamily: fontFamily,
    );
  }

  /// عنوان قسم
  static TextStyle headlineMedium({
    bool isArabic = true,
    Color? color,
    String? fontFamily,
  }) {
    return _getTextStyle(
      fontSize: headlineMediumSize,
      fontWeight: FontWeight.w600,
      color: color ?? AppColors.textPrimary,
      isArabic: isArabic,
      fontFamily: fontFamily,
    );
  }

  /// نص أساسي كبير
  static TextStyle bodyLarge({
    bool isArabic = true,
    Color? color,
    String? fontFamily,
  }) {
    return _getTextStyle(
      fontSize: bodyLargeSize,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textPrimary,
      isArabic: isArabic,
      fontFamily: fontFamily,
    );
  }

  /// نص أساسي متوسط
  static TextStyle bodyMedium({
    bool isArabic = true,
    Color? color,
    String? fontFamily,
  }) {
    return _getTextStyle(
      fontSize: bodyMediumSize,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textSecondary,
      isArabic: isArabic,
      fontFamily: fontFamily,
    );
  }

  /// نص صغير
  static TextStyle bodySmall({
    bool isArabic = true,
    Color? color,
    String? fontFamily,
  }) {
    return _getTextStyle(
      fontSize: bodySmallSize,
      fontWeight: FontWeight.normal,
      color: color ?? AppColors.textSecondary,
      isArabic: isArabic,
      fontFamily: fontFamily,
    );
  }

  /// نص الأزرار
  static TextStyle labelLarge({
    bool isArabic = true,
    Color? color,
    String? fontFamily,
  }) {
    return _getTextStyle(
      fontSize: labelLargeSize,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white,
      isArabic: isArabic,
      fontFamily: fontFamily,
    );
  }

  // ========== TextTheme كامل ==========

  /// الحصول على TextTheme كامل حسب اللغة
  static TextTheme getTextTheme({bool isArabic = true, String? fontFamily}) {
    final selectedFont =
        fontFamily ?? (isArabic ? arabicFontFamily : englishFontFamily);

    return GoogleFonts.getTextTheme(
      selectedFont,
      TextTheme(
        displayLarge: TextStyle(
          fontSize: displayLargeSize,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: displayMediumSize,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: displaySmallSize,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: headlineMediumSize,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: bodyLargeSize,
          fontWeight: FontWeight.normal,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: bodyMediumSize,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontSize: bodySmallSize,
          fontWeight: FontWeight.normal,
          color: AppColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: labelLargeSize,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
