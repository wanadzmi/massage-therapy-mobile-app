import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../auth/views/login_view.dart';
import '../../auth/bindings/login_binding.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  // Observable variables
  final _isLoading = false.obs;
  final _userName = 'John Doe'.obs;
  final _userEmail = 'john.doe@example.com'.obs;
  final _userPhone = '+1 234 567 8900'.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String get userName => _userName.value;
  String get userEmail => _userEmail.value;
  String get userPhone => _userPhone.value;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  void loadUserProfile() async {
    try {
      _isLoading.value = true;
      final response = await _authRepository.getUserProfile();
      if (response.isSuccess && response.data != null) {
        final user = response.data!;
        _userName.value = user.name ?? 'User';
        _userEmail.value = user.email ?? 'No email';
        _userPhone.value = user.phone ?? 'N/A';
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void editProfile() {
    Get.snackbar('Info', 'Edit profile feature coming soon!');
  }

  void viewBookingHistory() {
    Get.snackbar('Info', 'Booking history feature coming soon!');
  }

  Future<void> logout() async {
    try {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Call logout API
      await _authRepository.logout();

      // Close loading dialog
      Get.back();

      // Navigate to login screen
      Get.offAll(() => const LoginView(), binding: LoginBinding());

      Get.snackbar(
        'Success',
        'You have been logged out',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back(); // Close loading dialog
      Get.snackbar(
        'Error',
        'Logout failed: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
