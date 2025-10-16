class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.therapymassage.com';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';

  // App Configuration
  static const String appVersion = '1.0.0';
  static const String privacyPolicyUrl = 'https://therapymassage.com/privacy';
  static const String termsOfServiceUrl = 'https://therapymassage.com/terms';
  static const String supportEmail = 'support@therapymassage.com';

  // Business Hours
  static const List<String> availableTimes = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
  ];

  // Service Categories
  static const List<String> massageServices = [
    'Swedish Massage',
    'Deep Tissue Massage',
    'Hot Stone Therapy',
    'Aromatherapy',
    'Sports Massage',
    'Reflexology',
  ];
}
