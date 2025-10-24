import 'package:dio/dio.dart';

/// Service for currency conversion
/// Using exchangerate-api.com (free tier: 1,500 requests/month)
class CurrencyService {
  final Dio _dio = Dio();

  // Free API - no API key required for basic usage
  static const String _baseUrl = 'https://api.exchangerate-api.com/v4/latest';

  // Cache exchange rate to reduce API calls
  double? _cachedUsdToMyr;
  DateTime? _cacheTime;

  /// Get USD to MYR exchange rate
  /// Returns cached rate if less than 1 hour old
  Future<double> getUsdToMyrRate() async {
    // Return cached rate if available and fresh (less than 1 hour)
    if (_cachedUsdToMyr != null && _cacheTime != null) {
      final age = DateTime.now().difference(_cacheTime!);
      if (age.inHours < 1) {
        return _cachedUsdToMyr!;
      }
    }

    try {
      final response = await _dio.get('$_baseUrl/USD');

      if (response.statusCode == 200) {
        final data = response.data;
        final rates = data['rates'] as Map<String, dynamic>;
        final usdToMyr = (rates['MYR'] as num).toDouble();

        // Cache the rate
        _cachedUsdToMyr = usdToMyr;
        _cacheTime = DateTime.now();

        return usdToMyr;
      } else {
        return _getFallbackRate();
      }
    } catch (e) {
      return _getFallbackRate();
    }
  }

  /// Convert USD to MYR
  Future<double> convertUsdToMyr(double usdAmount) async {
    final rate = await getUsdToMyrRate();
    return usdAmount * rate;
  }

  /// Convert MYR to USD
  Future<double> convertMyrToUsd(double myrAmount) async {
    final rate = await getUsdToMyrRate();
    return myrAmount / rate;
  }

  /// Fallback rate if API fails (approximate rate as of 2024)
  double _getFallbackRate() {
    _cachedUsdToMyr = 4.50;
    _cacheTime = DateTime.now();
    return 4.50;
  }

  /// Clear cache (useful for manual refresh)
  void clearCache() {
    _cachedUsdToMyr = null;
    _cacheTime = null;
  }
}
