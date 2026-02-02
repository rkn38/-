import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/localization/locale_provider.dart';
import 'core/localization/app_localizations.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/book_provider.dart';
import 'presentation/providers/cart_provider.dart';
import 'presentation/providers/favorite_provider.dart';
import 'presentation/providers/favorite_provider.dart';
import 'presentation/providers/purchase_provider.dart';
import 'presentation/providers/font_provider.dart';
import 'presentation/screens/auth/login_screen.dart';
import 'presentation/screens/home/home_screen.dart';
import 'presentation/screens/admin/admin_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // مزود اللغة - يجب أن يكون أولاً
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        // مزود المصادقة
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // مزود الكتب
        ChangeNotifierProvider(create: (_) => BookProvider()),
        // مزود السلة
        ChangeNotifierProvider(create: (_) => CartProvider()),
        // مزود المفضلة
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        // مزود المشتريات
        // مزود المشتريات
        ChangeNotifierProvider(create: (_) => PurchaseProvider()),
        // مزود الخطوط
        ChangeNotifierProvider(create: (_) => FontProvider()),
      ],
      child: Consumer2<LocaleProvider, FontProvider>(
        builder: (context, localeProvider, fontProvider, _) {
          return MaterialApp(
            // اسم التطبيق
            title: localeProvider.isArabic ? 'متجر الكتب' : 'eBook Store',

            // إخفاء شريط Debug
            debugShowCheckedModeBanner: false,

            // ========== إعدادات اللغة والاتجاه ==========

            // اللغة الحالية
            locale: localeProvider.locale,

            // اللغات المدعومة
            supportedLocales: LocaleProvider.supportedLocales,

            // مندوب الترجمة المخصص
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // ========== الثيم ==========

            // الثيم الفاتح
            theme: AppTheme.lightTheme(
              isArabic: localeProvider.isArabic,
              fontFamily: fontProvider.currentFont,
            ),

            // الثيم الداكن (للمستقبل)
            darkTheme: AppTheme.darkTheme(
              isArabic: localeProvider.isArabic,
              fontFamily: fontProvider.currentFont,
            ),

            // وضع الثيم
            themeMode: ThemeMode.light,

            // ========== Builder للاتجاه ==========
            builder: (context, child) {
              return Directionality(
                // اتجاه النص حسب اللغة
                textDirection: localeProvider.textDirection,
                child: child!,
              );
            },

            // ========== الشاشة الرئيسية ==========
            home: Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                // إذا كان المستخدم مسجّل دخول
                if (authProvider.isAuthenticated) {
                  // إذا كان مدير -> لوحة التحكم
                  if (authProvider.isAdmin) {
                    return const AdminDashboard();
                  }
                  // مستخدم عادي -> الصفحة الرئيسية
                  return const HomeScreen();
                }
                // غير مسجّل -> شاشة تسجيل الدخول
                return const LoginScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
