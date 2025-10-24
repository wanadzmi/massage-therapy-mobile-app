import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../services/locale_service.dart';
import '../../../data/models/user_model.dart';
import '../../auth/views/login_view.dart';
import '../../auth/bindings/login_binding.dart';
import '../views/edit_profile_view.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final LocaleService _localeService = Get.find<LocaleService>();

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
  final _dateOfBirth = Rx<DateTime?>(null);
  final _gender = ''.obs;
  final _address = Rx<Address?>(null);
  final _emergencyContact = Rx<EmergencyContact?>(null);

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
  DateTime? get dateOfBirth => _dateOfBirth.value;
  String get gender => _gender.value;
  Address? get address => _address.value;
  EmergencyContact? get emergencyContact => _emergencyContact.value;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
    loadUserProfile();
  }

  /// Public refresh method that can be called from other screens
  Future<void> refresh() async {
    await loadUserProfile();
  }

  /// Load saved language from SharedPreferences
  void _loadSavedLanguage() {
    final savedLocale = _localeService.getSavedLocaleCode();
    if (savedLocale != null) {
      _language.value = savedLocale;
    } else {
      // Default to English
      _language.value = 'en';
    }
  }

  Future<void> loadUserProfile() async {
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
        // Don't override language if user has saved a local preference
        final savedLocale = _localeService.getSavedLocaleCode();
        if (savedLocale == null) {
          // Only use API language if no local preference exists
          _language.value = user.preferences?.language ?? 'en';
        }

        // Personal Information
        _dateOfBirth.value = user.dateOfBirth;
        _gender.value = user.gender ?? '';
        if (user.addresses != null && user.addresses!.isNotEmpty) {
          _address.value = user.addresses!.firstWhere(
            (addr) => addr.isDefault == true,
            orElse: () => user.addresses!.first,
          );
        }
        _emergencyContact.value = user.emergencyContact;

        // print('✅ Profile loaded successfully');
        // print('👤 Gender loaded: ${_gender.value}');
        // print('📅 Date of Birth loaded: ${_dateOfBirth.value}');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> editProfile() async {
    // Show loading dialog while fetching latest profile data
    Get.dialog(
      const Center(child: CircularProgressIndicator(color: Color(0xFFD4AF37))),
      barrierDismissible: false,
    );

    try {
      // Fetch latest profile data from API
      await loadUserProfile();

      // Close loading dialog
      Get.back();

      // Navigate to edit profile view with fresh data
      Get.to(() => const EditProfileView());
    } catch (e) {
      // Close loading dialog
      Get.back();

      // Show error message
      Get.snackbar(
        'Error',
        'Failed to load profile data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    DateTime? dateOfBirth,
    String? gender,
    String? street,
    String? city,
    String? state,
    String? postcode,
    String? country,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelationship,
  }) async {
    try {
      _isLoading.value = true;

      // Build address object if any address field is provided
      Map<String, dynamic>? addressData;
      if (street != null ||
          city != null ||
          state != null ||
          postcode != null ||
          country != null) {
        addressData = {
          if (street != null) 'street': street,
          if (city != null) 'city': city,
          if (state != null) 'state': state,
          if (postcode != null) 'postcode': postcode,
          if (country != null) 'country': country,
        };
      }

      // Build emergency contact object if any field is provided
      Map<String, dynamic>? emergencyContactData;
      if (emergencyContactName != null ||
          emergencyContactPhone != null ||
          emergencyContactRelationship != null) {
        emergencyContactData = {
          if (emergencyContactName != null) 'name': emergencyContactName,
          if (emergencyContactPhone != null) 'phone': emergencyContactPhone,
          if (emergencyContactRelationship != null)
            'relationship': emergencyContactRelationship,
        };
      }

      final response = await _authRepository.updateProfile(
        name: name,
        dateOfBirth: dateOfBirth,
        gender: gender,
        address: addressData,
        emergencyContact: emergencyContactData,
      );

      if (response.isSuccess && response.data != null) {
        // Reload profile to get updated data
        await loadUserProfile();

        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFD4AF37),
          colorText: Colors.black,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void viewBookingHistory() {
    Get.snackbar('Info', 'Booking history feature coming soon!');
  }

  void changeLanguage() {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(Get.context!)!.selectLanguage,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 20),
              _buildLanguageOption('en', 'English'),
              const SizedBox(height: 12),
              _buildLanguageOption('ms', 'Bahasa Melayu'),
              const SizedBox(height: 12),
              _buildLanguageOption('zh', '中文'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A2A2A),
                  foregroundColor: const Color(0xFFE0E0E0),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(AppLocalizations.of(Get.context!)!.cancel),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String code, String name) {
    final isSelected = _language.value == code;
    return GestureDetector(
      onTap: () => _setLanguage(code, name),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD4AF37).withValues(alpha: 0.15)
              : const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : const Color(0xFF2A2A2A),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFF606060),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? const Color(0xFFD4AF37)
                    : const Color(0xFFE0E0E0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setLanguage(String code, String name) async {
    _language.value = code;

    // Save to SharedPreferences
    await _localeService.saveLocale(code);

    Get.back();

    Get.snackbar(
      'Success',
      'Language changed to $name',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFFD4AF37),
      colorText: Colors.black,
      duration: const Duration(seconds: 2),
    );
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
