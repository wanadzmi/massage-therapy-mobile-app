import 'package:get/get.dart';

class BookingController extends GetxController {
  // Observable variables
  final _isLoading = false.obs;
  final _selectedService = ''.obs;
  final _selectedDate = DateTime.now().obs;
  final _selectedTime = ''.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  String get selectedService => _selectedService.value;
  DateTime get selectedDate => _selectedDate.value;
  String get selectedTime => _selectedTime.value;

  @override
  void onInit() {
    super.onInit();
    // Check if service was passed as argument
    if (Get.arguments != null) {
      _selectedService.value = Get.arguments;
    }
  }

  void selectService(String service) {
    _selectedService.value = service;
  }

  void selectDate(DateTime date) {
    _selectedDate.value = date;
  }

  void selectTime(String time) {
    _selectedTime.value = time;
  }

  Future<void> confirmBooking() async {
    try {
      _isLoading.value = true;

      // Simulate booking API call
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar('Success', 'Booking confirmed!');
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Booking failed: ${e.toString()}');
    } finally {
      _isLoading.value = false;
    }
  }
}
