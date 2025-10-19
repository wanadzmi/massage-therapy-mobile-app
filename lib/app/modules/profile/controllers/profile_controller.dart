import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../auth/views/login_view.dart';
import '../../auth/bindings/login_binding.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  // Observable variables
  final _isLoading = false.obs;
  final _userName = ''.obs;
  final _userEmail = ''.obs;
  final _userPhone = ''.obs;
  final _memberTier = 'bronze'.obs;
  final _memberSince = Rx<DateTime?>(null);
  final _walletBalance = 0.0.obs;
  final _currency = 'MYR'.obs;
  final _loyaltyBalance = 0.obs;
  final _loyaltyEarned = 0.obs;
  final _loyaltyRedeemed = 0.obs;
  final _referralCode = ''.obs;
  final _totalReferrals = 0.obs;
  final _successfulReferrals = 0.obs;
  final _referralEarnings = 0.0.obs;
  final _isPhoneVerified = false.obs;
  final _isEmailVerified = false.obs;
  final _discount = 0.obs;
  final _pointsMultiplier = 1.0.obs;
  final _totalBookings = 0.obs;
  final _completedBookings = 0.obs;
  final _cancelledBookings = 0.obs;
  final _totalSpent = 0.0.obs;
  final _averageRating = 0.0.obs;
  final _language = 'en'.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String get userName => _userName.value;
  String get userEmail => _userEmail.value;
  String get userPhone => _userPhone.value;
  String get memberTier => _memberTier.value;
  DateTime? get memberSince => _memberSince.value;
  double get walletBalance => _walletBalance.value;
  String get currency => _currency.value;
  int get loyaltyBalance => _loyaltyBalance.value;
  int get loyaltyEarned => _loyaltyEarned.value;
  int get loyaltyRedeemed => _loyaltyRedeemed.value;
  String get referralCode => _referralCode.value;
  int get totalReferrals => _totalReferrals.value;
  int get successfulReferrals => _successfulReferrals.value;
  double get referralEarnings => _referralEarnings.value;
  bool get isPhoneVerified => _isPhoneVerified.value;
  bool get isEmailVerified => _isEmailVerified.value;
  int get discount => _discount.value;
  double get pointsMultiplier => _pointsMultiplier.value;
  int get totalBookings => _totalBookings.value;
  int get completedBookings => _completedBookings.value;
  int get cancelledBookings => _cancelledBookings.value;
  double get totalSpent => _totalSpent.value;
  double get averageRating => _averageRating.value;
  String get language => _language.value;

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
        _userEmail.value = user.email ?? '';
        _userPhone.value = user.phone ?? '';
        _memberTier.value = user.memberTier ?? 'bronze';
        _memberSince.value = user.memberSince;

        // Wallet
        _walletBalance.value = user.wallet?.balance ?? 0.0;
        _currency.value = user.wallet?.currency ?? 'MYR';

        // Loyalty Points
        _loyaltyBalance.value = user.loyaltyPoints?.balance ?? 0;
        _loyaltyEarned.value = user.loyaltyPoints?.totalEarned ?? 0;
        _loyaltyRedeemed.value = user.loyaltyPoints?.totalRedeemed ?? 0;

        // Referral
        _referralCode.value = user.referral?.code ?? '';
        _totalReferrals.value = user.referral?.totalReferrals ?? 0;
        _successfulReferrals.value = user.referral?.successfulReferrals ?? 0;
        _referralEarnings.value = user.referral?.referralEarnings ?? 0.0;

        // Verification
        _isPhoneVerified.value = user.isPhoneVerified ?? false;
        _isEmailVerified.value = user.isEmailVerified ?? false;

        // Tier Benefits
        _discount.value = user.tierBenefits?.discount ?? 0;
        _pointsMultiplier.value =
            user.tierBenefits?.pointsMultiplier?.toDouble() ?? 1.0;

        // Booking Stats
        _totalBookings.value = user.bookingStats?.totalBookings ?? 0;
        _completedBookings.value = user.bookingStats?.completedBookings ?? 0;
        _cancelledBookings.value = user.bookingStats?.cancelledBookings ?? 0;
        _totalSpent.value = user.bookingStats?.totalSpent ?? 0.0;
        _averageRating.value = user.bookingStats?.averageRating ?? 0.0;

        // Preferences
        _language.value = user.preferences?.language ?? 'en';

        print('✅ Profile loaded successfully');
      }
    } catch (e) {
      print('❌ Error loading profile: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
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
