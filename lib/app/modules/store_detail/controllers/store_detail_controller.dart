import 'package:get/get.dart';
import '../../../data/models/store_model.dart';
import '../../../data/models/service_model.dart' as service_model;
import '../../../data/services/store_service.dart';

class StoreDetailController extends GetxController {
  final StoreService _storeService = StoreService();

  final _isLoading = false.obs;
  final _isLoadingServices = false.obs;
  final Rx<Store?> _store = Rx<Store?>(null);
  final _services = <service_model.Service>[].obs;

  bool get isLoading => _isLoading.value;
  bool get isLoadingServices => _isLoadingServices.value;
  Store? get store => _store.value;
  List<service_model.Service> get services => _services;

  String? storeId;

  @override
  void onInit() {
    super.onInit();
    storeId = Get.arguments as String?;
    if (storeId != null) {
      loadStoreDetails();
      loadStoreServices();
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
    _isLoadingServices.value = false;

    if (response.isSuccess && response.data != null) {
      _services.value = response.data!;
    } else {
      Get.snackbar(
        'Error',
        'Failed to load services',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void navigateToServiceBooking(service_model.Service service) {
    // Navigate to therapist selection with service and store details
    Get.toNamed(
      '/therapist-selection',
      arguments: {'service': service, 'store': _store.value},
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
}
