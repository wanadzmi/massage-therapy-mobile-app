import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/notification_service.dart';
import '../../../core/device_registration_helper.dart';
import '../../auth/views/login_view.dart';
import '../../auth/bindings/login_binding.dart';
import '../../main_navigation/main_navigation_view.dart';
import '../../main_navigation/main_navigation_binding.dart';

class SplashController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final NotificationService _notificationService = NotificationService();

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
      // print('🔐 Is authenticated: $isAuthenticated');

      if (isAuthenticated) {
        // If token exists, try to validate it with profile API (with timeout)
        try {
          // print('🌐 Fetching user profile...');
          final profileResponse = await _authRepository
              .getUserProfile()
              .timeout(const Duration(seconds: 5));

          // print('📊 Profile response success: ${profileResponse.isSuccess}');

          if (profileResponse.isSuccess && profileResponse.data != null) {
            final user = profileResponse.data!;
            // print('👤 User role: ${user.role}');

            // Register device for notifications (non-blocking)
            _registerDevice();

            // Navigate based on user role
            if (user.role == 'customer') {
              // Navigate to customer home
              // print('✅ Navigating to customer home');
              Get.off(
                () => const MainNavigationView(),
                binding: MainNavigationBinding(),
              );
              return;
            } else if (user.role == 'therapist') {
              // Navigate to therapist home
              // print('✅ Navigating to therapist home');
              Get.offAllNamed('/therapist-home');
              return;
            } else {}
          } else {}
        } catch (e) {
          // If profile fetch fails, clear token and go to login
          await _authRepository.logout();
        }
      } else {}

      // Navigate to login if not authenticated or not a customer
      Get.off(() => const LoginView(), binding: LoginBinding());
    } catch (e) {
      // On any error, navigate to login
      Get.off(() => const LoginView(), binding: LoginBinding());
    }
  }

  /// Register device for push notifications
  /// This is called after successful authentication
  Future<void> _registerDevice() async {
    try {
      // print('📱 Registering device for notifications...');

      final platform = DeviceRegistrationHelper.getPlatform();
      final deviceModel = DeviceRegistrationHelper.getDeviceModel();
      final osVersion = DeviceRegistrationHelper.getOsVersion();
      final appVersion = DeviceRegistrationHelper.getAppVersion();
      final deviceToken = DeviceRegistrationHelper.getPlaceholderToken();

      final response = await _notificationService.registerDevice(
        deviceToken: deviceToken,
        platform: platform,
        deviceInfo: {
          'model': deviceModel,
          'osVersion': osVersion,
          'appVersion': appVersion,
        },
      );

      if (response.isSuccess) {
        // print('✅ Device registered successfully');
      } else {}
    } catch (e) {
      // Don't block app launch if device registration fails
    }
  }
}
