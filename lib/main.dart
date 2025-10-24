import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'app/routes/app_pages.dart';
import 'app/services/locale_service.dart';
import 'app/core/app_lifecycle_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize LocaleService before running the app
  await Get.putAsync(() => LocaleService().init(), permanent: true);

  // Register lifecycle observer
  final lifecycleObserver = AppLifecycleObserver();
  WidgetsBinding.instance.addObserver(lifecycleObserver);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeService = Get.find<LocaleService>();

    return GetMaterialApp(
      title: 'Therapy & Massage App',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,

      // Localization configuration
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('ms'), // Malay
        Locale('zh'), // Chinese
      ],
      locale: localeService.currentLocale,
      fallbackLocale: const Locale('en'),

      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFD4AF37), // Gold
        scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Deep Black
        cardColor: const Color(0xFF2A2A2A),
        dividerColor: const Color(0xFF3A3A3A),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFD4AF37), // Gold
          secondary: Color(0xFFFFD700), // Bright Gold
          surface: Color(0xFF1E1E1E),
          background: Color(0xFF0A0A0A),
          error: Color(0xFFE53E3E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Color(0xFFD4AF37),
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1A1A),
          selectedItemColor: Color(0xFFD4AF37),
          unselectedItemColor: Color(0xFF808080),
        ),
      ),
    );
  }
}
