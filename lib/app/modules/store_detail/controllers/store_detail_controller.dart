import 'package:get/get.dart';
import '../../../data/models/store_model.dart';
import '../../../data/models/service_model.dart' as service_model;
import '../../../data/models/review_model.dart' as review_model;
import '../../../data/services/store_service.dart';

class StoreDetailController extends GetxController {
  final StoreService _storeService = StoreService();

  final _isLoading = false.obs;
  final _isLoadingServices = false.obs;
  final _isLoadingReviews = false.obs;
  final Rx<Store?> _store = Rx<Store?>(null);
  final _services = <service_model.Service>[].obs;
  final _therapists = <StoreTherapist>[].obs;
  final _totalTherapists = 0.obs;
  final _activeTherapists = 0.obs;
  final _recentReviews = <review_model.Review>[].obs;
  final Rx<ReviewStatistics?> _reviewStats = Rx<ReviewStatistics?>(null);

  bool get isLoading => _isLoading.value;
  bool get isLoadingServices => _isLoadingServices.value;
  bool get isLoadingReviews => _isLoadingReviews.value;
  Store? get store => _store.value;
  List<service_model.Service> get services => _services;
  List<StoreTherapist> get therapists => _therapists;
  int get totalTherapists => _totalTherapists.value;
  int get activeTherapists => _activeTherapists.value;
  List<review_model.Review> get recentReviews => _recentReviews;
  ReviewStatistics? get reviewStats => _reviewStats.value;

  String? storeId;

  @override
  void onInit() {
    super.onInit();
    storeId = Get.arguments as String?;
    if (storeId != null) {
      loadStoreDetails();
      loadStoreServices();
      loadRecentReviews();
    }
  }

  Future<void> loadStoreDetails() async {
    if (storeId == null) return;

    _isLoading.value = true;
    final response = await _storeService.getStoreById(storeId!);
    _isLoading.value = false;

    if (response.isSuccess && response.data != null) {
      _store.value = response.data;
    } else {
      Get.snackbar(
        'Error',
        'Failed to load store details',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> loadStoreServices() async {
    if (storeId == null) return;

    _isLoadingServices.value = true;
    final response = await _storeService.getStoreServices(storeId!);

    if (response.isSuccess && response.data != null) {
      final data = response.data!;
      _services.value = data.services;
      _therapists.value = data.therapists;
      _totalTherapists.value = data.totalTherapists;
      _activeTherapists.value = data.activeTherapists;
    } else {
      Get.snackbar(
        'Error',
        'Failed to load services',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    _isLoadingServices.value = false;
  }

  Future<void> loadRecentReviews() async {
    if (storeId == null) return;

    _isLoadingReviews.value = true;
    final response = await _storeService.getStoreReviews(
      storeId!,
      limit: 10,
      page: 1,
    );

    if (response.isSuccess && response.data != null) {
      _recentReviews.value = response.data!.reviews;
      _reviewStats.value = response.data!.statistics;
    } else {
      // Backend error - don't show error to user, just log it
      // Reviews section will show "No reviews yet" instead
      _recentReviews.value = [];
      _reviewStats.value = null;
    }

    _isLoadingReviews.value = false;
  }

  void navigateToServiceBooking(service_model.Service service) {
    // Navigate to therapist selection with service, store, and therapist details
    Get.toNamed(
      '/therapist-selection',
      arguments: {
        'service': service,
        'store': _store.value,
        'storeTherapists': _therapists,
      },
    );
  }

  String formatPrice(double? price, String? currency) {
    if (price == null) return 'N/A';
    return '${currency ?? 'MYR'} ${price.toStringAsFixed(2)}';
  }

  String formatDuration(int? minutes) {
    if (minutes == null) return 'N/A';
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0 && mins > 0) {
      return '${hours}h ${mins}min';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${mins}min';
    }
  }

  String formatTimeAgo(DateTime? dateTime) {
    if (dateTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
