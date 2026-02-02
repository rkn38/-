import '../constants/app_strings.dart';

class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppStrings.invalidEmail;
    }
    
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }
    
    return null;
  }

  // Confirm password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    if (value != password) {
      return AppStrings.passwordsNotMatch;
    }
    
    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? '$fieldName ${AppStrings.fieldRequired}' : AppStrings.fieldRequired;
    }
    
    return null;
  }

  // Number validation
  static String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    
    if (double.tryParse(value) == null) {
      return 'يجب أن يكون رقماً';
    }
    
    return null;
  }

  // Price validation
  static String? validatePrice(String? value) {
    final numberError = validateNumber(value);
    if (numberError != null) return numberError;
    
    final price = double.parse(value!);
    if (price < 0) {
      return 'السعر يجب أن يكون موجباً';
    }
    
    return null;
  }
}
