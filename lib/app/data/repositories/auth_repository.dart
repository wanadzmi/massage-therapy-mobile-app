import '../models/user_model.dart';
import '../models/registration_response_model.dart';
import '../services/auth_service.dart';
import '../services/base_services.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  /// Login user
  Future<MyResponse<User?, dynamic>> login({
    required String email,
    required String password,
  }) async {
    return await _authService.login(email: email, password: password);
  }

  /// Register new user - returns registration response with OTP info
  Future<MyResponse<RegistrationResponse?, dynamic>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    String? referralCode,
  }) async {
    return await _authService.register(
      name: name,
      phone: phone,
      email: email,
      password: password,
      referralCode: referralCode,
    );
  }

  /// Verify OTP for phone verification
  Future<MyResponse<OTPVerificationResponse?, dynamic>> verifyOTP({
    required String phone,
    required String code,
    String type = 'phone_verification',
  }) async {
    return await _authService.verifyOTP(phone: phone, code: code, type: type);
  }

  /// Get current user profile
  Future<MyResponse<User?, dynamic>> getUserProfile() async {
    return await _authService.getUserProfile();
  }

  /// Update user profile
  Future<MyResponse<User?, dynamic>> updateProfile({
    String? name,
    String? email,
    String? phone,
  }) async {
    return await _authService.updateProfile(
      name: name,
      email: email,
      phone: phone,
    );
  }

  /// Logout user
  Future<MyResponse<bool, dynamic>> logout() async {
    return await _authService.logout();
  }

  /// Refresh authentication token
  Future<MyResponse<String?, dynamic>> refreshToken() async {
    return await _authService.refreshToken();
  }

  /// Check if user is currently authenticated
  Future<bool> isAuthenticated() async {
    try {
      final token = await _authService.authToken;
      return token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get stored auth token
  Future<String> getAuthToken() async {
    return await _authService.authToken;
  }
}
