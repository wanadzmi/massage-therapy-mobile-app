import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';

class SplashController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  @override
  void onReady() {
    super.onReady();
    _checkInitialRoute();
  }

  Future<void> _checkInitialRoute() async {
    // Add a small delay for splash screen effect
    await Future.delayed(const Duration(milliseconds: 1500));

    try {
      // Check if user is already authenticated
      final isAuthenticated = await _authRepository.isAuthenticated();

      if (isAuthenticated) {
        // Try to get user profile to validate token
        final profileResponse = await _authRepository.getUserProfile();

        if (profileResponse.isSuccess && profileResponse.data != null) {
          final user = profileResponse.data!;

          // Check if user is a customer
          if (user.role == 'customer') {
            // Navigate to home if authenticated customer
            Get.offAllNamed('/home');
            return;
          }
        }
      }

      // Navigate to login if not authenticated or not a customer
      Get.offAllNamed('/login');
    } catch (e) {
      // On error, navigate to login
      Get.offAllNamed('/login');
    }
  }
}
