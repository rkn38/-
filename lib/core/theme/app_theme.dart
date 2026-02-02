import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import 'app_typography.dart';

/// ثيم التطبيق الموحد
/// يدعم الوضع الفاتح والداكن مع اتجاه RTL/LTR
class AppTheme {
  // ========== الثيم الفاتح ==========

  static ThemeData lightTheme({bool isArabic = true, String? fontFamily}) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // الألوان
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        brightness: Brightness.light,
      ),

      // الخطوط
      textTheme: AppTypography.getTextTheme(
        isArabic: isArabic,
        fontFamily: fontFamily,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: AppTypography.displaySmall(
          isArabic: isArabic,
          fontFamily: fontFamily,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // الأزرار
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          textStyle: AppTypography.labelLarge(
            isArabic: isArabic,
            fontFamily: fontFamily,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: AppColors.primaryColor),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primaryColor),
      ),

      // حقول الإدخال
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.errorColor),
        ),
        labelStyle: AppTypography.bodyMedium(
          isArabic: isArabic,
          fontFamily: fontFamily,
        ),
        hintStyle: AppTypography.bodyMedium(
          isArabic: isArabic,
          fontFamily: fontFamily,
        ).copyWith(color: Colors.grey),
      ),

      // البطاقات
      cardTheme: CardThemeData(
        color: AppColors.cardColor,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // الـ BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: AppTypography.bodySmall(
          isArabic: isArabic,
          fontFamily: fontFamily,
        ),
        unselectedLabelStyle: AppTypography.bodySmall(
          isArabic: isArabic,
          fontFamily: fontFamily,
        ),
      ),

      // الـ FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // الـ Divider
      dividerTheme: DividerThemeData(color: Colors.grey.shade200, thickness: 1),

      // الـ Chip
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade100,
        selectedColor: AppColors.primaryColor.withOpacity(0.2),
        labelStyle: AppTypography.bodySmall(
          isArabic: isArabic,
          fontFamily: fontFamily,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  // ========== الثيم الداكن ==========

  static ThemeData darkTheme({bool isArabic = true, String? fontFamily}) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // الألوان
      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        brightness: Brightness.dark,
      ),

      // الخطوط
      textTheme:
          AppTypography.getTextTheme(
            isArabic: isArabic,
            fontFamily: fontFamily,
          ).apply(
            bodyColor: AppColors.darkTextPrimary,
            displayColor: AppColors.darkTextPrimary,
          ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkCard,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
        titleTextStyle: AppTypography.displaySmall(
          isArabic: isArabic,
          fontFamily: fontFamily,
        ).copyWith(color: AppColors.darkTextPrimary),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // الأزرار
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),

      // حقول الإدخال
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
      ),

      // البطاقات
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // الـ BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkCard,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.darkTextSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
