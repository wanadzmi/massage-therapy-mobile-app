import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../auth/views/login_view.dart';
import '../../auth/bindings/login_binding.dart';
import '../../main_navigation/main_navigation_view.dart';
import '../../main_navigation/main_navigation_binding.dart';

class SplashController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  @override
  void onReady() {
    super.onReady();
    _checkInitialRoute();
  }

  Future<void> _checkInitialRoute() async {
    try {
      // Add a small delay for splash screen effect
      await Future.delayed(const Duration(milliseconds: 1500));

      // Check if user is already authenticated (just check token existence)
      final isAuthenticated = await _authRepository.isAuthenticated();
      print('🔐 Is authenticated: $isAuthenticated');

      if (isAuthenticated) {
        // If token exists, try to validate it with profile API (with timeout)
        try {
          print('🌐 Fetching user profile...');
          final profileResponse = await _authRepository
              .getUserProfile()
              .timeout(const Duration(seconds: 5));

          print('📊 Profile response success: ${profileResponse.isSuccess}');

          if (profileResponse.isSuccess && profileResponse.data != null) {
            final user = profileResponse.data!;
            print('👤 User role: ${user.role}');

            // Check if user is a customer
            if (user.role == 'customer') {
              // Navigate to home if authenticated customer
              print('✅ Navigating to home');
              Get.off(
                () => const MainNavigationView(),
                binding: MainNavigationBinding(),
              );
              return;
            } else {
              print('❌ User is not a customer, role: ${user.role}');
            }
          } else {
            print('❌ Profile response failed: ${profileResponse.error}');
          }
        } catch (e) {
          // If profile fetch fails, clear token and go to login
          print('❌ Profile fetch failed: $e');
          await _authRepository.logout();
        }
      } else {
        print('❌ No token found');
      }

      // Navigate to login if not authenticated or not a customer
      print('🔄 Navigating to login');
      Get.off(() => const LoginView(), binding: LoginBinding());
    } catch (e) {
      // On any error, navigate to login
      print('❌ Splash error: $e');
      Get.off(() => const LoginView(), binding: LoginBinding());
    }
  }
}
