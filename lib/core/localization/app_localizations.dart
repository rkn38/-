import 'package:flutter/material.dart';

/// نظام الترجمات ثنائي اللغة
/// يحتوي على جميع النصوص بالعربية والإنجليزية
class AppLocalizations {
  final Locale locale;
  
  AppLocalizations(this.locale);
  
  /// الحصول على instance من السياق
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('ar'));
  }
  
  /// هل اللغة عربية؟
  bool get isArabic => locale.languageCode == 'ar';
  
  /// الترجمات
  static final Map<String, Map<String, String>> _localizedValues = {
    'ar': {
      // اسم التطبيق
      'appName': 'متجر الكتب',
      
      // المصادقة
      'login': 'تسجيل الدخول',
      'register': 'إنشاء حساب',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'confirmPassword': 'تأكيد كلمة المرور',
      'forgotPassword': 'نسيت كلمة المرور؟',
      'dontHaveAccount': 'ليس لديك حساب؟',
      'alreadyHaveAccount': 'لديك حساب بالفعل؟',
      'signInWithGoogle': 'تسجيل الدخول بـ Google',
      'logout': 'تسجيل الخروج',
      'displayName': 'الاسم',
      'createAccount': 'إنشاء حساب جديد',
      'fillDataToRegister': 'املأ البيانات لإنشاء حسابك',
      
      // الصفحة الرئيسية
      'home': 'الرئيسية',
      'featuredBooks': 'الكتب المميزة',
      'categories': 'الفئات',
      'bestSellers': 'الأكثر مبيعاً',
      'newArrivals': 'وصل حديثاً',
      'searchBooks': 'ابحث عن كتاب...',
      'viewAll': 'عرض الكل',
      
      // تفاصيل الكتاب
      'bookDetails': 'تفاصيل الكتاب',
      'description': 'الوصف',
      'author': 'المؤلف',
      'publisher': 'الناشر',
      'pages': 'الصفحات',
      'language': 'اللغة',
      'category': 'الفئة',
      'rating': 'التقييم',
      'reviews': 'المراجعات',
      'addToCart': 'إضافة إلى السلة',
      'buyNow': 'اشتر الآن',
      'addToFavorites': 'إضافة للمفضلة',
      'removeFromFavorites': 'إزالة من المفضلة',
      'readNow': 'اقرأ الآن',
      
      // السلة
      'cart': 'السلة',
      'emptyCart': 'السلة فارغة',
      'total': 'الإجمالي',
      'checkout': 'إتمام الشراء',
      'removeFromCart': 'إزالة من السلة',
      'cartItems': 'عناصر السلة',
      
      // المكتبة
      'myLibrary': 'مكتبتي',
      'myBooks': 'كتبي',
      'favorites': 'المفضلة',
      'purchased': 'المشتريات',
      'emptyLibrary': 'مكتبتك فارغة',
      'startShopping': 'ابدأ بشراء الكتب من المتجر',
      'browseStore': 'تصفح المتجر',
      'loginToSeeLibrary': 'قم بتسجيل الدخول لرؤية مكتبتك',
      
      // الملف الشخصي
      'profile': 'الملف الشخصي',
      'editProfile': 'تعديل الملف الشخصي',
      'settings': 'الإعدادات',
      'darkMode': 'الوضع الليلي',
      'languageSettings': 'اللغة',
      'about': 'حول التطبيق',
      'appVersion': 'إصدار التطبيق',
      
      // المدير
      'adminPanel': 'لوحة التحكم',
      'adminDashboard': 'لوحة تحكم المدير',
      'addBook': 'إضافة كتاب',
      'editBook': 'تعديل كتاب',
      'deleteBook': 'حذف كتاب',
      'manageBooks': 'إدارة الكتب',
      'manageCategories': 'إدارة الفئات',
      'manageAdmins': 'إدارة المدراء',
      'manageUsers': 'إدارة المستخدمين',
      'statistics': 'الإحصائيات',
      'totalBooks': 'إجمالي الكتب',
      'totalUsers': 'عدد المستخدمين',
      'totalSales': 'إجمالي المبيعات',
      'topRated': 'أعلى تقييم',
      'seedData': 'تعبئة بيانات أولية',
      'dataSeeded': 'تمت تهيئة البيانات بنجاح',
      'createAdmin': 'إنشاء مدير جديد',
      'adminCreated': 'تم إنشاء المدير بنجاح',
      'admins': 'المدراء',
      'noAdmins': 'لا يوجد مدراء',
      
      // الفئات
      'novels': 'روايات',
      'scientific': 'علمية',
      'religious': 'دينية',
      'technology': 'تقنية',
      'history': 'تاريخ',
      'selfDevelopment': 'تطوير ذاتي',
      'allCategories': 'جميع الفئات',
      
      // عام
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'edit': 'تعديل',
      'confirm': 'تأكيد',
      'loading': 'جاري التحميل...',
      'error': 'حدث خطأ',
      'success': 'تم بنجاح',
      'tryAgain': 'حاول مرة أخرى',
      'noData': 'لا توجد بيانات',
      'search': 'بحث',
      'yes': 'نعم',
      'no': 'لا',
      'ok': 'موافق',
      'close': 'إغلاق',
      'refresh': 'تحديث',
      'add': 'إضافة',
      'update': 'تحديث',
      
      // التحقق
      'fieldRequired': 'هذا الحقل مطلوب',
      'invalidEmail': 'البريد الإلكتروني غير صحيح',
      'passwordTooShort': 'كلمة المرور قصيرة جداً',
      'passwordsNotMatch': 'كلمات المرور غير متطابقة',
      'weakPassword': 'كلمة المرور ضعيفة',
      
      // الرسائل
      'loginSuccess': 'تم تسجيل الدخول بنجاح',
      'loginFailed': 'فشل تسجيل الدخول',
      'registerSuccess': 'تم إنشاء الحساب بنجاح',
      'addedToCart': 'تمت الإضافة إلى السلة',
      'removedFromCart': 'تمت الإزالة من السلة',
      'purchaseSuccess': 'تمت عملية الشراء بنجاح',
      'bookNotFound': 'الكتاب غير موجود',
      'bookSaved': 'تم حفظ الكتاب بنجاح',
      'bookDeleted': 'تم حذف الكتاب',
      'confirmDelete': 'هل أنت متأكد من الحذف؟',
      'confirmDeleteBook': 'هل أنت متأكد من حذف هذا الكتاب نهائياً؟',
      'welcome': 'مرحباً',
      'welcomeBack': 'مرحباً بعودتك',
      
      // حقول الكتاب
      'bookTitle': 'عنوان الكتاب',
      'bookAuthor': 'المؤلف',
      'bookDescription': 'الوصف',
      'bookPrice': 'السعر',
      'bookPages': 'عدد الصفحات',
      'bookCoverUrl': 'رابط صورة الغلاف',
      'bookCategory': 'الفئة',
      'featuredBook': 'كتاب مميز',
      'currency': 'ريال',
      
      // اللغة
      'arabic': 'العربية',
      'english': 'English',
      'changeLanguage': 'تغيير اللغة',
      'selectLanguage': 'اختر اللغة',
    },
    
    // ========== English ==========
    'en': {
      // App name
      'appName': 'eBook Store',
      
      // Authentication
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'forgotPassword': 'Forgot Password?',
      'dontHaveAccount': "Don't have an account?",
      'alreadyHaveAccount': 'Already have an account?',
      'signInWithGoogle': 'Sign in with Google',
      'logout': 'Logout',
      'displayName': 'Name',
      'createAccount': 'Create New Account',
      'fillDataToRegister': 'Fill in your details to register',
      
      // Home
      'home': 'Home',
      'featuredBooks': 'Featured Books',
      'categories': 'Categories',
      'bestSellers': 'Best Sellers',
      'newArrivals': 'New Arrivals',
      'searchBooks': 'Search for a book...',
      'viewAll': 'View All',
      
      // Book Details
      'bookDetails': 'Book Details',
      'description': 'Description',
      'author': 'Author',
      'publisher': 'Publisher',
      'pages': 'Pages',
      'language': 'Language',
      'category': 'Category',
      'rating': 'Rating',
      'reviews': 'Reviews',
      'addToCart': 'Add to Cart',
      'buyNow': 'Buy Now',
      'addToFavorites': 'Add to Favorites',
      'removeFromFavorites': 'Remove from Favorites',
      'readNow': 'Read Now',
      
      // Cart
      'cart': 'Cart',
      'emptyCart': 'Cart is empty',
      'total': 'Total',
      'checkout': 'Checkout',
      'removeFromCart': 'Remove from Cart',
      'cartItems': 'Cart Items',
      
      // Library
      'myLibrary': 'My Library',
      'myBooks': 'My Books',
      'favorites': 'Favorites',
      'purchased': 'Purchased',
      'emptyLibrary': 'Your library is empty',
      'startShopping': 'Start buying books from the store',
      'browseStore': 'Browse Store',
      'loginToSeeLibrary': 'Login to see your library',
      
      // Profile
      'profile': 'Profile',
      'editProfile': 'Edit Profile',
      'settings': 'Settings',
      'darkMode': 'Dark Mode',
      'languageSettings': 'Language',
      'about': 'About',
      'appVersion': 'App Version',
      
      // Admin
      'adminPanel': 'Admin Panel',
      'adminDashboard': 'Admin Dashboard',
      'addBook': 'Add Book',
      'editBook': 'Edit Book',
      'deleteBook': 'Delete Book',
      'manageBooks': 'Manage Books',
      'manageCategories': 'Manage Categories',
      'manageAdmins': 'Manage Admins',
      'manageUsers': 'Manage Users',
      'statistics': 'Statistics',
      'totalBooks': 'Total Books',
      'totalUsers': 'Total Users',
      'totalSales': 'Total Sales',
      'topRated': 'Top Rated',
      'seedData': 'Seed Initial Data',
      'dataSeeded': 'Data seeded successfully',
      'createAdmin': 'Create New Admin',
      'adminCreated': 'Admin created successfully',
      'admins': 'Admins',
      'noAdmins': 'No admins found',
      
      // Categories
      'novels': 'Novels',
      'scientific': 'Scientific',
      'religious': 'Religious',
      'technology': 'Technology',
      'history': 'History',
      'selfDevelopment': 'Self Development',
      'allCategories': 'All Categories',
      
      // Common
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'confirm': 'Confirm',
      'loading': 'Loading...',
      'error': 'Error occurred',
      'success': 'Success',
      'tryAgain': 'Try Again',
      'noData': 'No data available',
      'search': 'Search',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'close': 'Close',
      'refresh': 'Refresh',
      'add': 'Add',
      'update': 'Update',
      
      // Validation
      'fieldRequired': 'This field is required',
      'invalidEmail': 'Invalid email address',
      'passwordTooShort': 'Password is too short',
      'passwordsNotMatch': 'Passwords do not match',
      'weakPassword': 'Password is weak',
      
      // Messages
      'loginSuccess': 'Login successful',
      'loginFailed': 'Login failed',
      'registerSuccess': 'Account created successfully',
      'addedToCart': 'Added to cart',
      'removedFromCart': 'Removed from cart',
      'purchaseSuccess': 'Purchase successful',
      'bookNotFound': 'Book not found',
      'bookSaved': 'Book saved successfully',
      'bookDeleted': 'Book deleted',
      'confirmDelete': 'Are you sure you want to delete?',
      'confirmDeleteBook': 'Are you sure you want to delete this book permanently?',
      'welcome': 'Welcome',
      'welcomeBack': 'Welcome back',
      
      // Book fields
      'bookTitle': 'Book Title',
      'bookAuthor': 'Author',
      'bookDescription': 'Description',
      'bookPrice': 'Price',
      'bookPages': 'Number of Pages',
      'bookCoverUrl': 'Cover Image URL',
      'bookCategory': 'Category',
      'featuredBook': 'Featured Book',
      'currency': 'SAR',
      
      // Language
      'arabic': 'العربية',
      'english': 'English',
      'changeLanguage': 'Change Language',
      'selectLanguage': 'Select Language',
    },
  };
  
  /// الحصول على نص مترجم
  String tr(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? 
           _localizedValues['ar']?[key] ?? 
           key;
  }
  
  /// اختصار للترجمة
  String get(String key) => tr(key);
  
  // ========== Getters للنصوص الشائعة ==========
  
  String get appName => tr('appName');
  String get login => tr('login');
  String get register => tr('register');
  String get email => tr('email');
  String get password => tr('password');
  String get home => tr('home');
  String get cart => tr('cart');
  String get myLibrary => tr('myLibrary');
  String get profile => tr('profile');
  String get settings => tr('settings');
  String get logout => tr('logout');
  String get save => tr('save');
  String get cancel => tr('cancel');
  String get delete => tr('delete');
  String get edit => tr('edit');
  String get loading => tr('loading');
  String get error => tr('error');
  String get success => tr('success');
}

/// Delegate للترجمات
class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();
  
  @override
  bool isSupported(Locale locale) {
    return ['ar', 'en'].contains(locale.languageCode);
  }
  
  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }
  
  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
