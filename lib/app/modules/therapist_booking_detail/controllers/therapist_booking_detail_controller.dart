import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/booking_service.dart' as service;
import '../../../data/models/booking_model.dart';

class TherapistBookingDetailController extends GetxController {
  final service.BookingService _bookingService = service.BookingService();

  final _isLoading = false.obs;
  final _booking = Rx<Booking?>(null);

  bool get isLoading => _isLoading.value;
  Booking? get booking => _booking.value;

  @override
  void onInit() {
    super.onInit();
    final bookingId = Get.parameters['bookingId'];
    if (bookingId != null) {
      loadBookingDetails(bookingId);
    }
  }

  Future<void> loadBookingDetails(String bookingId) async {
    try {
      _isLoading.value = true;
      final response = await _bookingService.getBookingDetails(bookingId);

      if (response.isSuccess && response.data != null) {
        _booking.value = response.data;
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to load booking details',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  String formatCurrency(double? amount) {
    if (amount == null) return 'RM 0.00';
    return 'RM ${amount.toStringAsFixed(2)}';
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }
}
