import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleService extends GetxService {
  static const String _localeKey = 'app_locale';

  SharedPreferences? _prefs;
  final _currentLocale = const Locale('en').obs;

  Locale get currentLocale => _currentLocale.value;

  Future<LocaleService> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadSavedLocale();
    return this;
  }

  /// Load saved locale from SharedPreferences
  Future<void> _loadSavedLocale() async {
    try {
      final savedLocaleCode = _prefs?.getString(_localeKey);

      if (savedLocaleCode != null && savedLocaleCode.isNotEmpty) {
        final locale = Locale(savedLocaleCode);
        _currentLocale.value = locale;
        Get.updateLocale(locale);
      } else {
        // Default to English
        _currentLocale.value = const Locale('en');
        Get.updateLocale(const Locale('en'));
      }
    } catch (e) {
      _currentLocale.value = const Locale('en');
    }
  }

  /// Save locale to SharedPreferences
  Future<void> saveLocale(String languageCode) async {
    try {
      await _prefs?.setString(_localeKey, languageCode);
      final locale = Locale(languageCode);
      _currentLocale.value = locale;
      Get.updateLocale(locale);
    } catch (e) {}
  }

  /// Get saved locale code
  String? getSavedLocaleCode() {
    return _prefs?.getString(_localeKey);
  }

  /// Clear saved locale
  Future<void> clearLocale() async {
    await _prefs?.remove(_localeKey);
  }
}
