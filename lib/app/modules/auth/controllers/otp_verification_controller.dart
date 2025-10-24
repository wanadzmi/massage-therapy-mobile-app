import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/user_model.dart';
import '../../main_navigation/main_navigation_view.dart';
import '../../main_navigation/main_navigation_binding.dart';

class OTPVerificationController extends GetxController {
  final AuthService _authService = AuthService();

  // OTP Input controllers (6 digits)
  final otp1Controller = TextEditingController();
  final otp2Controller = TextEditingController();
  final otp3Controller = TextEditingController();
  final otp4Controller = TextEditingController();
  final otp5Controller = TextEditingController();
  final otp6Controller = TextEditingController();

  // Focus nodes for OTP fields
  final otp1Focus = FocusNode();
  final otp2Focus = FocusNode();
  final otp3Focus = FocusNode();
  final otp4Focus = FocusNode();
  final otp5Focus = FocusNode();
  final otp6Focus = FocusNode();

  // Observable state
  final _isLoading = false.obs;
  final _countdown = 60.obs;
  final _canResend = false.obs;

  // Arguments from registration
  String? phone;
  String? userId;
  String? devOTP;
  String verificationType = 'phone_verification';

  Timer? _countdownTimer;

  // Getters
  bool get isLoading => _isLoading.value;
  int get countdown => _countdown.value;
  bool get canResend => _canResend.value;

  String get otpCode {
    return otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text +
        otp5Controller.text +
        otp6Controller.text;
  }

  bool get isOTPComplete {
    return otpCode.length == 6;
  }

  @override
  void onInit() {
    super.onInit();

    // Get arguments
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      phone = args['phone'] as String?;
      userId = args['userId'] as String?;
      devOTP = args['devOTP'] as String?;
      verificationType =
          args['verificationType'] as String? ?? 'phone_verification';
    }

    print('📱 OTP Verification initialized');
    print('   Phone: $phone');
    print('   Dev OTP: $devOTP');

    // Start countdown timer
    _startCountdown();
  }

  @override
  void onClose() {
    _countdownTimer?.cancel();
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    otp5Controller.dispose();
    otp6Controller.dispose();
    otp1Focus.dispose();
    otp2Focus.dispose();
    otp3Focus.dispose();
    otp4Focus.dispose();
    otp5Focus.dispose();
    otp6Focus.dispose();
    super.onClose();
  }

  void _startCountdown() {
    _countdown.value = 60;
    _canResend.value = false;

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown.value > 0) {
        _countdown.value--;
      } else {
        _canResend.value = true;
        timer.cancel();
      }
    });
  }

  void onOTPChanged(String value, int position) {
    if (value.isEmpty) {
      // Handle backspace - move to previous field
      _moveToPreviousField(position);
    } else if (value.length == 1) {
      // Move to next field when digit is entered
      _moveToNextField(position);
    }

    // Auto-verify when all 6 digits are entered
    if (isOTPComplete && !_isLoading.value) {
      verifyOTP();
    }
  }

  void _moveToNextField(int currentPosition) {
    switch (currentPosition) {
      case 1:
        otp2Focus.requestFocus();
        break;
      case 2:
        otp3Focus.requestFocus();
        break;
      case 3:
        otp4Focus.requestFocus();
        break;
      case 4:
        otp5Focus.requestFocus();
        break;
      case 5:
        otp6Focus.requestFocus();
        break;
      case 6:
        otp6Focus.unfocus();
        break;
    }
  }

  void _moveToPreviousField(int currentPosition) {
    switch (currentPosition) {
      case 2:
        otp1Focus.requestFocus();
        break;
      case 3:
        otp2Focus.requestFocus();
        break;
      case 4:
        otp3Focus.requestFocus();
        break;
      case 5:
        otp4Focus.requestFocus();
        break;
      case 6:
        otp5Focus.requestFocus();
        break;
    }
  }

  Future<void> verifyOTP() async {
    if (!isOTPComplete) {
      Get.snackbar(
        'Incomplete OTP',
        'Please enter all 6 digits',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (phone == null) {
      Get.snackbar(
        'Error',
        'Phone number not found',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    _isLoading.value = true;

    final response = await _authService.verifyOTP(
      phone: phone!,
      code: otpCode,
      type: verificationType,
    );

    _isLoading.value = false;

    if (response.isSuccess && response.data != null) {
      final otpData = response.data!;

      print('✅ OTP verified successfully');
      print('   Token received: ${otpData.data?.token != null}');

      // Parse and save user data
      if (otpData.data?.user != null) {
        try {
          final user = User.fromJson(otpData.data!.user!);

          // Save user data to preferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_id', user.id ?? '');
          await prefs.setString('user_name', user.name ?? '');
          await prefs.setString('user_email', user.email ?? '');
          await prefs.setString('user_phone', user.phone ?? '');

          print('   User: ${user.name}');
          print('   Email: ${user.email}');
          print('   Phone Verified: ${user.isPhoneVerified}');
        } catch (e) {
          print('⚠️ Error parsing user data: $e');
        }
      }

      Get.snackbar(
        'Success',
        'Phone verified successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD4AF37),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );

      // Navigate to home with bottom nav
      await Future.delayed(const Duration(seconds: 2));
      Get.offAll(
        () => const MainNavigationView(),
        binding: MainNavigationBinding(),
      );
    } else {
      print('❌ OTP verification failed: ${response.error}');

      // Parse error message
      String errorMessage = 'Invalid or expired OTP. Please try again.';
      if (response.error is Map<String, dynamic>) {
        errorMessage = response.error['message'] ?? errorMessage;
      } else if (response.error is String) {
        errorMessage = response.error;
      }

      Get.snackbar(
        'Verification Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      // Clear OTP fields
      clearOTP();
    }
  }

  void clearOTP() {
    otp1Controller.clear();
    otp2Controller.clear();
    otp3Controller.clear();
    otp4Controller.clear();
    otp5Controller.clear();
    otp6Controller.clear();
    otp1Focus.requestFocus();
  }

  Future<void> resendOTP() async {
    if (!_canResend.value) return;

    // TODO: Implement resend OTP API call
    Get.snackbar(
      'OTP Sent',
      'A new OTP has been sent to your phone',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFD4AF37),
      colorText: Colors.black,
    );

    // Restart countdown
    _startCountdown();
    clearOTP();
  }

  void navigateBack() {
    Get.back();
  }
}
