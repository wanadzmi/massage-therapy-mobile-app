import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/banner_service.dart';
import '../../../data/models/banner_model.dart';

class HomeController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final BannerService _bannerService = BannerService();

  // Observable variables
  final _isLoading = false.obs;
  final _selectedIndex = 0.obs;
  final _walletBalance = 0.0.obs;
  final _currency = 'MYR'.obs;
  final _userName = 'User'.obs;
  final _banners = <BannerModel>[].obs;
  final _isBannersLoading = false.obs;
  final _viewedBanners = <String>{}.obs; // Track viewed banners

  // Getters
  bool get isLoading => _isLoading.value;
  int get selectedIndex => _selectedIndex.value;
  double get walletBalance => _walletBalance.value;
  String get currency => _currency.value;
  String get userName => _userName.value;
  List<BannerModel> get banners => _banners;
  bool get isBannersLoading => _isBannersLoading.value;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadBanners();
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
      // print('Error loading user data: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadBanners() async {
    try {
      _isBannersLoading.value = true;
      // Get user tier and role from auth if available
      final response = await _bannerService.getBanners(
        userTier: null, // Can be populated from user profile if needed
        userRole: 'customer', // Default to customer
      );

      if (response.isSuccess && response.data != null) {
        _banners.value = response.data!;
      } else {}
    } finally {
      _isBannersLoading.value = false;
    }
  }

  /// Record a banner view (called when banner is displayed)
  Future<void> recordBannerView(String bannerId) async {
    // Only record view once per session
    if (_viewedBanners.contains(bannerId)) return;

    try {
      await _bannerService.recordView(bannerId);
      _viewedBanners.add(bannerId);
    } catch (e) {
      // print('Error recording banner view: $e');
    }
  }

  /// Handle banner click and navigation
  Future<void> handleBannerClick(BannerModel banner) async {
    try {
      // Record click
      final response = await _bannerService.recordClick(banner.id);

      if (response.isSuccess && response.data != null) {
        final link = response.data!;

        // Navigate based on link type
        if (link.type == 'internal') {
          _handleInternalNavigation(link);
        } else if (link.type == 'external' && link.url != null) {
          await _handleExternalNavigation(link.url!);
        }
        // 'none' type - do nothing
      }
    } catch (e) {
      // print('Error handling banner click: $e');
    }
  }

  void _handleInternalNavigation(BannerLink link) {
    switch (link.target) {
      case 'service':
        if (link.targetId != null) {
          Get.toNamed('/service-detail', arguments: {'id': link.targetId});
        }
        break;
      case 'store':
        if (link.targetId != null) {
          Get.toNamed('/store-detail', arguments: {'storeId': link.targetId});
        }
        break;
      case 'voucher':
        if (link.targetId != null) {
          Get.toNamed('/vouchers');
        }
        break;
      case 'booking':
        Get.toNamed('/booking-create');
        break;
      default:
      // print('Unknown internal target: ${link.target}');
    }
  }

  Future<void> _handleExternalNavigation(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open link',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      // print('Error launching URL: $e');
      Get.snackbar('Error', 'Invalid URL', snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Public refresh method that can be called from other screens
  @override
  Future<void> refresh() async {
    await loadUserData();
    await loadBanners();
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
