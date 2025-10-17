import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';

class HomeController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  // Observable variables
  final _isLoading = false.obs;
  final _selectedIndex = 0.obs;
  final _walletBalance = 0.0.obs;
  final _currency = 'MYR'.obs;
  final _userName = 'User'.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  int get selectedIndex => _selectedIndex.value;
  double get walletBalance => _walletBalance.value;
  String get currency => _currency.value;
  String get userName => _userName.value;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      _isLoading.value = true;
      final response = await _authRepository.getUserProfile();
      if (response.isSuccess && response.data != null) {
        final user = response.data!;
        _userName.value = user.name ?? 'User';
        _walletBalance.value = user.wallet?.balance?.toDouble() ?? 0.0;
        _currency.value = user.wallet?.currency ?? 'MYR';
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      _isLoading.value = false;
    }
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

  void navigateToFindStore() {
    Get.toNamed('/find-store');
  }

  void navigateToFindTherapist() {
    Get.snackbar(
      'Find Therapist',
      'Feature coming soon! You will be able to book a therapist to visit your home.',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Navigate to therapist finder page
    // Get.toNamed('/therapists');
  }
}
