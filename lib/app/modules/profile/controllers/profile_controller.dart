import 'package:get/get.dart';
import 'package:therapy_massage_app/app/modules/auth/controllers/auth_controller.dart';

class ProfileController extends GetxController {
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

  void loadUserProfile() {
    // Load user profile data
    // This would typically come from an API or local storage
  }

  void editProfile() {
    // Navigate to edit profile screen
    Get.snackbar('Info', 'Edit profile feature coming soon!');
  }

  void viewBookingHistory() {
    // Navigate to booking history screen
    Get.snackbar('Info', 'Booking history feature coming soon!');
  }

  void logout() {
    // Clear user data and navigate to auth
    Get.find<AuthController>().logout();
  }
}
