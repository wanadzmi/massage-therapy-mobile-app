import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/booking_service.dart';
import '../../../data/models/today_summary_model.dart';

class TodaySummaryController extends GetxController {
  final BookingService _bookingService = BookingService();

  final _isLoading = false.obs;
  final _todaySummary = Rx<TodaySummary?>(null);

  bool get isLoading => _isLoading.value;
  TodaySummary? get todaySummary => _todaySummary.value;

  // Summary Stats
  int get totalCustomers => todaySummary?.summary?.totalCustomers ?? 0;
  int get maleCustomers => todaySummary?.summary?.customerBreakdown?.male ?? 0;
  int get femaleCustomers =>
      todaySummary?.summary?.customerBreakdown?.female ?? 0;
  int get otherCustomers =>
      todaySummary?.summary?.customerBreakdown?.other ?? 0;
  int get totalBookings => todaySummary?.summary?.totalBookings ?? 0;
  int get completedBookings => todaySummary?.summary?.completedBookings ?? 0;
  int get pendingBookings => todaySummary?.summary?.pendingBookings ?? 0;
  int get cashCollectionNeeded =>
      todaySummary?.summary?.cashCollectionNeeded ?? 0;

  // Payment Stats
  int get cashPayments => todaySummary?.payments?.cash ?? 0;
  int get transferPayments => todaySummary?.payments?.transfer ?? 0;
  int get totalPayments => todaySummary?.payments?.total ?? 0;

  // Revenue Stats
  double get completedRevenue => todaySummary?.revenue?.completed ?? 0.0;
  double get pendingRevenue => todaySummary?.revenue?.pending ?? 0.0;
  double get totalRevenue => todaySummary?.revenue?.total ?? 0.0;

  // Upcoming Bookings
  List<UpcomingBooking> get upcomingBookings =>
      todaySummary?.upcomingBookings ?? [];

  @override
  void onInit() {
    super.onInit();
    loadTodaySummary();
  }

  Future<void> loadTodaySummary() async {
    try {
      _isLoading.value = true;

      final response = await _bookingService.getTodaySummary();

      if (response.isSuccess && response.data != null) {
        _todaySummary.value = response.data;
      } else {
        _todaySummary.value = null;
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to load today\'s summary',
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

  String formatCurrency(double amount) {
    return 'RM ${amount.toStringAsFixed(2)}';
  }
}
