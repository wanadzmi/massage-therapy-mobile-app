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
  final _memberTier = 'bronze'.obs;
  final _walletBalance = 0.0.obs;
  final _currency = 'MYR'.obs;
  final _referralCode = ''.obs;
  final _isPhoneVerified = false.obs;
  final _isEmailVerified = false.obs;
  final _discount = 0.obs;
  final _pointsMultiplier = 1.0.obs;
  final _totalBookings = 0.obs;
  final _rating = 0.0.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String get userName => _userName.value;
  String get userEmail => _userEmail.value;
  String get userPhone => _userPhone.value;
  String get memberTier => _memberTier.value;
  double get walletBalance => _walletBalance.value;
  String get currency => _currency.value;
  String get referralCode => _referralCode.value;
  bool get isPhoneVerified => _isPhoneVerified.value;
  bool get isEmailVerified => _isEmailVerified.value;
  int get discount => _discount.value;
  double get pointsMultiplier => _pointsMultiplier.value;
  int get totalBookings => _totalBookings.value;
  double get rating => _rating.value;

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

        // Additional user details
        _memberTier.value = user.memberTier ?? 'bronze';
        _walletBalance.value = user.wallet?.balance ?? 0.0;
        _currency.value = user.wallet?.currency ?? 'MYR';
        _referralCode.value = user.referralCode ?? '';
        _isPhoneVerified.value = user.isPhoneVerified ?? false;
        _isEmailVerified.value = user.isEmailVerified ?? false;
        _discount.value = user.tierBenefits?.discount ?? 0;
        _pointsMultiplier.value =
            user.tierBenefits?.pointsMultiplier?.toDouble() ?? 1.0;
        // Note: totalBookings and rating would come from a separate endpoint
        // For now keeping mock values in the view
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
