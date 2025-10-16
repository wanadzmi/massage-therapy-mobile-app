import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'l10n/app_localizations.dart';
import 'app/modules/splash/views/splash_view.dart';
import 'app/modules/splash/bindings/splash_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Therapy & Massage App',
      home: const SplashView(),
      initialBinding: SplashBinding(),
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
      ],
      locale: const Locale('en'),
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
