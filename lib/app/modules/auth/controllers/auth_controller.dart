import 'package:get/get.dart';

class AuthController extends GetxController {
  // Observable variables
  final _isLoading = false.obs;
  final _isLoggedIn = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get isLoggedIn => _isLoggedIn.value;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  void checkAuthStatus() {
    // Check if user is already logged in
    // This could check stored tokens, shared preferences, etc.
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading.value = true;

      // Perform login API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      _isLoggedIn.value = true;
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', 'Login failed: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      _isLoading.value = true;

      // Perform registration API call
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call

      _isLoggedIn.value = true;
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar('Error', 'Registration failed: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }

  void logout() {
    _isLoggedIn.value = false;
    Get.offAllNamed('/auth');
  }
}
