import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';

class RegisterController extends GetxController {
  final AuthService _authService = AuthService();

  // Form controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final referralCodeController = TextEditingController();

  // Observable state
  final _isLoading = false.obs;
  final _isPasswordVisible = false.obs;
  final _isConfirmPasswordVisible = false.obs;
  final _agreeToTerms = false.obs;
  final _countryCode = '+60'.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible.value;
  bool get agreeToTerms => _agreeToTerms.value;
  String get countryCode => _countryCode.value;

  @override
  void onInit() {
    super.onInit();
    // Prefill all fields for testing
    nameController.text = 'Test User';
    phoneController.text = '1121907970';
    emailController.text = 'test@email.com';
    passwordController.text = 'Test@1234';
    confirmPasswordController.text = 'Test@1234';
    _agreeToTerms.value = true;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    referralCodeController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible.value = !_isConfirmPasswordVisible.value;
  }

  void toggleAgreeToTerms(bool? value) {
    _agreeToTerms.value = value ?? false;
  }

  void setCountryCode(String code) {
    _countryCode.value = code;
  }

  Future<void> register() async {
    // Simple checks
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all required fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (!_agreeToTerms.value) {
      Get.snackbar(
        'Error',
        'Please agree to Terms & Conditions',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Build full phone number with country code
    final fullPhone = _countryCode.value + phoneController.text.trim();

    // Validate email
    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Validate password length
    if (passwordController.text.length < 8) {
      Get.snackbar(
        'Invalid Password',
        'Password must be at least 8 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Validate password match
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Password Mismatch',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    _isLoading.value = true;

    final response = await _authService.register(
      name: nameController.text.trim(),
      phone: fullPhone,
      email: emailController.text.trim(),
      password: passwordController.text,
      referralCode: referralCodeController.text.trim(),
    );

    _isLoading.value = false;

    if (response.isSuccess && response.data != null) {
      final registrationData = response.data!;

      print('✅ Registration successful');
      print('   Phone: ${registrationData.data?.phone}');
      print('   Next Step: ${registrationData.data?.nextStep}');
      print('   Dev OTP: ${registrationData.data?.devOTP}');

      // Show success message
      Get.snackbar(
        'Success',
        registrationData.message ?? 'Registration successful!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD4AF37),
        colorText: Colors.black,
        duration: const Duration(seconds: 2),
      );

      // Navigate to OTP verification
      await Future.delayed(const Duration(seconds: 2));
      Get.toNamed(
        '/otp-verification',
        arguments: {
          'phone': registrationData.data?.phone,
          'userId': registrationData.data?.userId,
          'devOTP': registrationData.data?.devOTP,
          'verificationType': 'phone_verification',
        },
      );
    } else {
      print('❌ Registration failed: ${response.error}');

      // Parse error message
      String errorMessage = 'Registration failed. Please try again.';
      if (response.error is Map<String, dynamic>) {
        errorMessage = response.error['message'] ?? errorMessage;
      } else if (response.error is String) {
        errorMessage = response.error;
      }

      Get.snackbar(
        'Registration Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void navigateToLogin() {
    Get.back();
  }

  void navigateToTerms() {
    // TODO: Navigate to terms and conditions page
    Get.snackbar(
      'Terms & Conditions',
      'Terms page not yet implemented',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
