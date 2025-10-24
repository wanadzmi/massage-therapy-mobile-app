import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../utils/validators.dart';
import '../../main_navigation/main_navigation_view.dart';
import '../../main_navigation/main_navigation_binding.dart';

class LoginController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables
  final _isLoading = false.obs;
  final _isPasswordVisible = false.obs;
  final _rememberMe = false.obs;

  // Form validation
  final _emailError = RxnString();
  final _passwordError = RxnString();

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isPasswordVisible => _isPasswordVisible.value;
  bool get rememberMe => _rememberMe.value;
  String? get emailError => _emailError.value;
  String? get passwordError => _passwordError.value;

  // Check if form is valid (reactive)
  final _isFormValid = false.obs;
  bool get isFormValid => _isFormValid.value;

  @override
  void onInit() {
    super.onInit();
    // Prefill for testing
    // emailController.text = 'customer4@email.com';
    // passwordController.text = 'password123';
    _setupValidation();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void _setupValidation() {
    // Real-time email validation
    emailController.addListener(() {
      final email = emailController.text.trim();
      if (email.isEmpty) {
        _emailError.value = null;
      } else {
        _emailError.value = Validators.validateEmail(email);
      }
      _updateFormValidity();
    });

    // Real-time password validation
    passwordController.addListener(() {
      final password = passwordController.text;
      if (password.isEmpty) {
        _passwordError.value = null;
      } else {
        _passwordError.value = Validators.validatePassword(password);
      }
      _updateFormValidity();
    });
  }

  void _updateFormValidity() {
    _isFormValid.value =
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        _emailError.value == null &&
        _passwordError.value == null;
  }

  void togglePasswordVisibility() {
    _isPasswordVisible.value = !_isPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    _rememberMe.value = value ?? false;
  }

  Future<void> login() async {
    if (!_validateForm()) return;

    try {
      _isLoading.value = true;

      final response = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response.isSuccess && response.data != null) {
        final user = response.data!;

        // Show success message with user details
        Get.snackbar(
          'Welcome!',
          'Hello ${user.name}, you are now logged in',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green.shade800,
          duration: const Duration(seconds: 3),
        );

        // Store user data if remember me is checked
        if (_rememberMe.value) {
          await _storeUserCredentials();
        }

        // Navigate based on user role
        if (user.role == 'therapist') {
          // Navigate to therapist home
          Get.offAllNamed('/therapist-home');
        } else {
          // Navigate to customer home with bottom navigation
          Get.off(
            () => const MainNavigationView(),
            binding: MainNavigationBinding(),
          );
        }
      } else {
        _handleLoginError(response.error);
      }
    } catch (e) {
      _handleLoginError(e.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  bool _validateForm() {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Validate email
    final emailValidation = Validators.validateEmail(email);
    if (emailValidation != null) {
      _emailError.value = emailValidation;
      Get.snackbar('Validation Error', emailValidation);
      return false;
    }

    // Validate password
    final passwordValidation = Validators.validatePassword(password);
    if (passwordValidation != null) {
      _passwordError.value = passwordValidation;
      Get.snackbar('Validation Error', passwordValidation);
      return false;
    }

    return true;
  }

  void _handleLoginError(dynamic error) {
    String errorMessage = 'Login failed. Please try again.';

    if (error is String) {
      errorMessage = error;
    } else if (error is Map<String, dynamic>) {
      errorMessage = error['message'] ?? error.toString();
    }

    // Show error message
    Get.snackbar(
      'Login Failed',
      errorMessage,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.shade100,
      colorText: Colors.red.shade800,
      duration: const Duration(seconds: 4),
    );

    // Clear password field for security
    passwordController.clear();
  }

  Future<void> _storeUserCredentials() async {
    // Store credentials securely if remember me is enabled
    // This is a simplified implementation - in production, use secure storage
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('remembered_email', emailController.text.trim());
      await prefs.setBool('remember_me', true);
    } catch (e) {}
  }

  Future<void> loadRememberedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberedEmail = prefs.getString('remembered_email');
      final shouldRemember = prefs.getBool('remember_me') ?? false;

      if (shouldRemember && rememberedEmail != null) {
        emailController.text = rememberedEmail;
        _rememberMe.value = true;
      }
    } catch (e) {}
  }

  void navigateToRegister() {
    Get.toNamed('/register');
  }

  void navigateToForgotPassword() {
    Get.toNamed('/forgot-password');
  }

  void loginAsGuest() {
    Get.dialog(
      AlertDialog(
        title: const Text('Guest Access'),
        content: const Text(
          'Are you sure you want to continue as a guest? Some features may be limited.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/home');
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }
}
