import '../models/booking_model.dart';
import '../services/booking_service.dart' as service;
import '../services/base_services.dart';

class BookingRepository {
  final service.BookingService _bookingService = service.BookingService();

  /// Create a new booking
  Future<MyResponse<Booking?, dynamic>> createBooking({
    required String therapistId,
    required String serviceId,
    required DateTime date,
    required String startTime,
    String? paymentMethod,
    String? voucherCode,
    Map<String, dynamic>? preferences,
    String? notes,
  }) async {
    return await _bookingService.createBooking(
      therapistId: therapistId,
      serviceId: serviceId,
      date: _formatDateForAPI(date),
      startTime: startTime,
      paymentMethod: paymentMethod,
      voucherCode: voucherCode,
      preferences: preferences,
      notes: notes,
    );
  }

  /// Get user's bookings
  Future<MyResponse<service.MyBookingsResponse?, dynamic>> getMyBookings({
    String? status,
    int? page,
    int? limit,
  }) async {
    return await _bookingService.getMyBookings(
      status: status,
      page: page,
      limit: limit,
    );
  }

  /// Get booking by ID
  Future<MyResponse<Booking?, dynamic>> getBookingById(String bookingId) async {
    return await _bookingService.getBookingById(bookingId);
  }

  /// Cancel booking
  Future<MyResponse<Booking?, dynamic>> cancelBooking(
    String bookingId, {
    String? reason,
  }) async {
    return await _bookingService.cancelBooking(bookingId, reason: reason);
  }

  /// Get upcoming bookings
  Future<List<Booking>> getUpcomingBookings() async {
    final response = await getMyBookings(status: 'confirmed');
    if (response.isSuccess && response.data != null) {
      final now = DateTime.now();
      return response.data!.bookings
              ?.where(
                (booking) => booking.date != null && booking.date!.isAfter(now),
              )
              .toList() ??
          [];
    }
    return [];
  }

  /// Get past bookings
  Future<List<Booking>> getPastBookings() async {
    final response = await getMyBookings(status: 'completed');
    if (response.isSuccess && response.data != null) {
      return response.data!.bookings ?? [];
    }
    return [];
  }

  /// Get pending bookings
  Future<List<Booking>> getPendingBookings() async {
    final response = await getMyBookings(status: 'pending');
    if (response.isSuccess && response.data != null) {
      return response.data!.bookings ?? [];
    }
    return [];
  }

  /// Check if a booking can be cancelled
  bool canCancelBooking(Booking booking) {
    if (booking.status == 'cancelled' || booking.status == 'completed') {
      return false;
    }

    if (booking.date != null) {
      final now = DateTime.now();
      final bookingDateTime = booking.date!;

      // Allow cancellation if booking is more than 2 hours away
      final hoursUntilBooking = bookingDateTime.difference(now).inHours;
      return hoursUntilBooking > 2;
    }

    return false;
  }

  /// Check if a booking can be rescheduled
  bool canRescheduleBooking(Booking booking) {
    if (booking.status == 'cancelled' || booking.status == 'completed') {
      return false;
    }

    if (booking.date != null) {
      final now = DateTime.now();
      final bookingDateTime = booking.date!;

      // Allow rescheduling if booking is more than 4 hours away
      final hoursUntilBooking = bookingDateTime.difference(now).inHours;
      return hoursUntilBooking > 4;
    }

    return false;
  }

  /// Format date for API calls
  String _formatDateForAPI(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Get bookings for a specific date
  Future<List<Booking>> getBookingsForDate(DateTime date) async {
    final response = await getMyBookings();
    if (response.isSuccess && response.data != null) {
      return response.data!.bookings
              ?.where(
                (booking) =>
                    booking.date != null && _isSameDate(booking.date!, date),
              )
              .toList() ??
          [];
    }
    return [];
  }

  /// Check if two dates are the same day
  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
