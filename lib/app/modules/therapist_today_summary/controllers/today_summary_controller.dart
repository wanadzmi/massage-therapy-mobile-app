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

      print('📱 Loading today summary...');
      final response = await _bookingService.getTodaySummary();

      print('📦 Today Summary response - Success: ${response.isSuccess}');
      print('📦 Today Summary response - Data: ${response.data}');
      print('📦 Today Summary response - Error: ${response.error}');

      if (response.isSuccess && response.data != null) {
        _todaySummary.value = response.data;

        print('✅ Loaded today summary successfully');
        print('   Total Customers: $totalCustomers');
        print('   Total Bookings: $totalBookings');
        print('   Cash Collection Needed: $cashCollectionNeeded');
        print('   Completed Revenue: RM$completedRevenue');
        print('   Pending Revenue: RM$pendingRevenue');
        print('   Total Revenue: RM$totalRevenue');
        print('   Upcoming Bookings: ${upcomingBookings.length}');
      } else {
        _todaySummary.value = null;
        print('❌ Failed to load today summary: ${response.error}');
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to load today\'s summary',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e, stackTrace) {
      print('❌ Exception loading today summary: $e');
      print('❌ Stack trace: $stackTrace');
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
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
