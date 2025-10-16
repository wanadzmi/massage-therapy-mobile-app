import 'package:get/get.dart';

class ServicesController extends GetxController {
  // Observable variables
  final _isLoading = false.obs;
  final _services = <String>[].obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<String> get services => _services;

  @override
  void onInit() {
    super.onInit();
    loadServices();
  }

  void loadServices() {
    // Load massage/therapy services
    _services.addAll([
      'Swedish Massage',
      'Deep Tissue Massage',
      'Hot Stone Therapy',
      'Aromatherapy',
      'Sports Massage',
      'Reflexology',
    ]);
  }

  void bookService(String serviceName) {
    Get.toNamed('/booking', arguments: serviceName);
  }
}
