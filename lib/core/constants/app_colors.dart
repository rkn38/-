import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const primaryColor = Color(0xFF6366F1); // Indigo
  static const secondaryColor = Color(0xFFF59E0B); // Amber

  // Background
  static const backgroundColor = Color(0xFFF9FAFB);
  static const cardColor = Color(0xFFFFFFFF);

  // Text
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);

  // Status
  static const successColor = Color(0xFF10B981);
  static const errorColor = Color(0xFFEF4444);
  static const warningColor = Color(0xFFF59E0B);

  // Dark Mode
  static const darkBackground = Color(0xFF111827);
  static const darkCard = Color(0xFF1F2937);
  static const darkTextPrimary = Color(0xFFF9FAFB);
  static const darkTextSecondary = Color(0xFF9CA3AF);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const secondaryGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
