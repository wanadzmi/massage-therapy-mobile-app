import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/services/booking_service.dart' as api;

class BookingController extends GetxController {
  final api.BookingService _bookingService = api.BookingService();

  // Observable variables
  final _isLoading = false.obs;
  final _bookings = <Booking>[].obs;
  final _currentPage = 1.obs;
  final _totalPages = 1.obs;
  final _hasMore = false.obs;
  final _selectedFilter = 'all'.obs; // all, confirmed, completed, cancelled

  // Getters
  bool get isLoading => _isLoading.value;
  List<Booking> get bookings => _bookings;
  String get selectedFilter => _selectedFilter.value;
  bool get hasMore => _hasMore.value;

  @override
  void onInit() {
    super.onInit();
    loadBookings();
  }

  Future<void> loadBookings({bool refresh = false}) async {
    if (refresh) {
      _currentPage.value = 1;
      _bookings.clear();
    }

    _isLoading.value = true;

    try {
      final response = await _bookingService.getMyBookings(
        status: _selectedFilter.value == 'all' ? null : _selectedFilter.value,
        page: _currentPage.value,
        limit: 20,
      );

      if (response.isSuccess && response.data != null) {
        final myBookingsResponse = response.data!;

        if (myBookingsResponse.bookings != null) {
          // Sort bookings by createdAt in descending order (newest first)
          final sortedBookings = myBookingsResponse.bookings!;
          sortedBookings.sort((a, b) {
            final aDate = a.createdAt ?? DateTime(1970);
            final bDate = b.createdAt ?? DateTime(1970);
            return bDate.compareTo(aDate); // Descending order
          });

          if (refresh) {
            _bookings.value = sortedBookings;
          } else {
            _bookings.addAll(sortedBookings);
          }
        }

        if (myBookingsResponse.pagination != null) {
          _totalPages.value = myBookingsResponse.pagination!.totalPages ?? 1;
          _hasMore.value = myBookingsResponse.pagination!.hasNext ?? false;
        }
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to load bookings',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E1E1E),
          colorText: const Color(0xFFE53E3E),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFE53E3E),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (_isLoading.value || !_hasMore.value) return;
    _currentPage.value++;
    await loadBookings();
  }

  Future<void> refresh() async {
    await loadBookings(refresh: true);
  }

  void setFilter(String filter) {
    if (_selectedFilter.value != filter) {
      _selectedFilter.value = filter;
      loadBookings(refresh: true);
    }
  }

  void viewBookingDetails(Booking booking) {
    // TODO: Navigate to booking details page
    Get.snackbar(
      'Booking Details',
      'Booking ${booking.bookingCode}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E1E1E),
      colorText: const Color(0xFFE0E0E0),
    );
  }

  Future<void> cancelBooking(
    Booking booking,
    String reason, {
    String? details,
  }) async {
    try {
      _isLoading.value = true;
      final response = await _bookingService.cancelBooking(
        booking.id!,
        reason: reason,
        details: details,
      );

      if (response.isSuccess) {
        Get.snackbar(
          'Success',
          'Booking cancelled successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E1E1E),
          colorText: const Color(0xFF4CAF50),
        );
        await loadBookings(refresh: true);
      } else {
        // Extract detailed error message from response.error
        String errorMessage = 'Failed to cancel booking';
        if (response.error != null) {
          errorMessage = response.error!;
        }

        Get.snackbar(
          'Cannot Cancel',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E1E1E),
          colorText: const Color(0xFFE53E3E),
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFE53E3E),
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
