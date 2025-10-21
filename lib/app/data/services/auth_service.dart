import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../models/registration_response_model.dart';
import 'base_services.dart';

class AuthService extends BaseServices {
  static const String _loginEndpoint = '/api/auth/login';
  static const String _registerEndpoint = '/api/auth/register';
  static const String _verifyOTPEndpoint = '/api/auth/verify-otp';
  static const String _logoutEndpoint = '/api/auth/logout';
  static const String _refreshTokenEndpoint = '/api/auth/refresh';
  static const String _profileEndpoint = '/api/auth/profile';

  /// Login user with email and password
  Future<MyResponse<User?, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await callAPI(
      HttpRequestType.POST,
      _loginEndpoint,
      postBody: {'email': email, 'password': password},
      requiresAuth: false,
    );

    if (response.isSuccess && response.data != null) {
      try {
        // Handle the API response structure: { "message": "...", "data": { "token": "...", "user": {...} } }
        final responseData = response.data['data'] ?? response.data;
        final userData = responseData['user'];
        final token = responseData['token'];

        if (userData == null) {
          return MyResponse.error('User data not found in response');
        }

        final user = User.fromJson(userData);

        // Check if user role is customer
        if (user.role != 'customer') {
          return MyResponse.error(
            'Only customers are allowed to login through this app',
          );
        }

        // Store token if provided
        if (token != null) {
          await _storeToken(token);
        }

        return MyResponse.complete(user);
      } catch (e) {
        return MyResponse.error('Failed to parse user data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Register new user - returns registration response with OTP info
  Future<MyResponse<RegistrationResponse?, dynamic>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    String? referralCode,
  }) async {
    final response = await callAPI(
      HttpRequestType.POST,
      _registerEndpoint,
      postBody: {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        if (referralCode != null && referralCode.isNotEmpty)
          'referralCode': referralCode,
      },
      requiresAuth: false,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final registrationResponse = RegistrationResponse.fromJson(
          response.data,
        );
        return MyResponse.complete(registrationResponse);
      } catch (e) {
        return MyResponse.error('Failed to parse registration data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Verify OTP for phone verification
  Future<MyResponse<OTPVerificationResponse?, dynamic>> verifyOTP({
    required String phone,
    required String code,
    String type = 'phone_verification',
  }) async {
    final response = await callAPI(
      HttpRequestType.POST,
      _verifyOTPEndpoint,
      postBody: {'phone': phone, 'code': code, 'type': type},
      requiresAuth: false,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final otpResponse = OTPVerificationResponse.fromJson(response.data);

        // Store token if provided
        if (otpResponse.data?.token != null) {
          await _storeToken(otpResponse.data!.token!);
        }

        return MyResponse.complete(otpResponse);
      } catch (e) {
        return MyResponse.error('Failed to parse verification data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get current user profile
  Future<MyResponse<User?, dynamic>> getUserProfile() async {
    final response = await callAPI(HttpRequestType.GET, _profileEndpoint);

    if (response.isSuccess && response.data != null) {
      try {
        final userData = response.data['data'] ?? response.data;
        print('📥 GET /api/auth/profile response data keys: ${userData.keys}');
        print('📥 Gender from API: ${userData['gender']}');
        print('📥 DateOfBirth from API: ${userData['dateOfBirth']}');
        final user = User.fromJson(userData);
        print(
          '✅ Parsed user - gender: ${user.gender}, dateOfBirth: ${user.dateOfBirth}',
        );
        return MyResponse.complete(user);
      } catch (e) {
        print('❌ Failed to parse GET response: $e');
        return MyResponse.error('Failed to parse user data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Update user profile
  Future<MyResponse<User?, dynamic>> updateProfile({
    String? name,
    String? email,
    String? phone,
    DateTime? dateOfBirth,
    String? gender,
    Map<String, dynamic>? address,
    Map<String, dynamic>? emergencyContact,
  }) async {
    final response = await callAPI(
      HttpRequestType.PUT,
      _profileEndpoint,
      postBody: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (dateOfBirth != null)
          'dateOfBirth': dateOfBirth.toIso8601String().split('T')[0],
        if (gender != null) 'gender': gender,
        if (address != null) 'address': address,
        if (emergencyContact != null) 'emergencyContact': emergencyContact,
      },
    );

    if (response.isSuccess && response.data != null) {
      try {
        print('📥 PUT /api/auth/profile response data: ${response.data}');
        final user = User.fromJson(response.data);
        print(
          '✅ Parsed user - gender: ${user.gender}, dateOfBirth: ${user.dateOfBirth}',
        );
        return MyResponse.complete(user);
      } catch (e) {
        print('❌ Failed to parse PUT response: $e');
        return MyResponse.error('Failed to parse user data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Logout user
  Future<MyResponse<bool, dynamic>> logout() async {
    final response = await callAPI(HttpRequestType.POST, _logoutEndpoint);

    // Clear local token regardless of server response
    await _clearToken();

    if (response.isSuccess) {
      return MyResponse.complete(true);
    }

    return MyResponse.error(response.error);
  }

  /// Refresh authentication token
  Future<MyResponse<String?, dynamic>> refreshToken() async {
    final response = await callAPI(HttpRequestType.POST, _refreshTokenEndpoint);

    if (response.isSuccess && response.data != null) {
      final token = response.data['token'];
      if (token != null) {
        await _storeToken(token);
        return MyResponse.complete(token);
      }
    }

    return MyResponse.error(response.error ?? 'Failed to refresh token');
  }

  /// Store authentication token locally
  Future<void> _storeToken(String token) async {
    try {
      // Use SharedPreferences to store token
      // This will be available through the BaseServices authToken getter
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      print('✅ Token stored successfully');
      print(
        '🔑 Token (first 20 chars): ${token.substring(0, token.length > 20 ? 20 : token.length)}...',
      );

      // Verify it was stored
      final storedToken = prefs.getString('auth_token');
      print(
        '✅ Token verified in storage: ${storedToken != null && storedToken.isNotEmpty}',
      );
    } catch (e) {
      print('❌ Error storing token: $e');
    }
  }

  /// Clear authentication token locally
  Future<void> _clearToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
    } catch (e) {
      print('Error clearing token: $e');
    }
  }
}
