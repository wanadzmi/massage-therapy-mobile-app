import 'package:get/get.dart';

class HomeController extends GetxController {
  // Observable variables
  final _isLoading = false.obs;
  final _selectedIndex = 0.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  int get selectedIndex => _selectedIndex.value;

  @override
  void onInit() {
    super.onInit();
    // Initialize any data needed for the home screen
  }

  @override
  void onReady() {
    super.onReady();
    // Called after the widget is rendered on screen
  }

  @override
  void onClose() {
    super.onClose();
    // Clean up resources
  }

  // Methods
  void setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void changeTabIndex(int index) {
    _selectedIndex.value = index;
  }

  void navigateToServices() {
    Get.toNamed('/services');
  }

  void navigateToBooking() {
    Get.toNamed('/booking');
  }

  void navigateToProfile() {
    Get.toNamed('/profile');
  }
}
