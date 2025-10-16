import '../models/booking_model.dart';
import '../services/booking_service.dart';
import '../services/base_services.dart';

class BookingRepository {
  final BookingService _bookingService = BookingService();

  /// Create a new booking
  Future<MyResponse<Booking?, dynamic>> createBooking({
    required String serviceId,
    required DateTime appointmentDate,
    required String appointmentTime,
    String? notes,
  }) async {
    return await _bookingService.createBooking(
      serviceId: serviceId,
      appointmentDate: _formatDateForAPI(appointmentDate),
      appointmentTime: appointmentTime,
      notes: notes,
    );
  }

  /// Get user's bookings
  Future<MyResponse<List<Booking>, dynamic>> getUserBookings({
    String? status,
    int? limit,
    int? offset,
  }) async {
    return await _bookingService.getUserBookings(
      status: status,
      limit: limit,
      offset: offset,
    );
  }

  /// Get booking by ID
  Future<MyResponse<Booking?, dynamic>> getBookingById(String bookingId) async {
    return await _bookingService.getBookingById(bookingId);
  }

  /// Check availability
  Future<MyResponse<List<String>, dynamic>> checkAvailability({
    required String serviceId,
    required DateTime date,
  }) async {
    return await _bookingService.checkAvailability(
      serviceId: serviceId,
      date: _formatDateForAPI(date),
    );
  }

  /// Cancel booking
  Future<MyResponse<bool, dynamic>> cancelBooking(String bookingId) async {
    return await _bookingService.cancelBooking(bookingId);
  }

  /// Reschedule booking
  Future<MyResponse<Booking?, dynamic>> rescheduleBooking({
    required String bookingId,
    required DateTime newDate,
    required String newTime,
  }) async {
    return await _bookingService.rescheduleBooking(
      bookingId: bookingId,
      newDate: _formatDateForAPI(newDate),
      newTime: newTime,
    );
  }

  /// Get booking history
  Future<MyResponse<List<Booking>, dynamic>> getBookingHistory() async {
    return await _bookingService.getBookingHistory();
  }

  /// Update booking status
  Future<MyResponse<Booking?, dynamic>> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    return await _bookingService.updateBookingStatus(
      bookingId: bookingId,
      status: status,
    );
  }

  /// Get upcoming bookings
  Future<List<Booking>> getUpcomingBookings() async {
    final response = await getUserBookings(status: 'confirmed');
    if (response.isSuccess && response.data != null) {
      final now = DateTime.now();
      return response.data!
          .where(
            (booking) =>
                booking.appointmentDate != null &&
                booking.appointmentDate!.isAfter(now),
          )
          .toList();
    }
    return [];
  }

  /// Get past bookings
  Future<List<Booking>> getPastBookings() async {
    final response = await getUserBookings(status: 'completed');
    if (response.isSuccess && response.data != null) {
      return response.data!;
    }
    return [];
  }

  /// Get pending bookings
  Future<List<Booking>> getPendingBookings() async {
    final response = await getUserBookings(status: 'pending');
    if (response.isSuccess && response.data != null) {
      return response.data!;
    }
    return [];
  }

  /// Check if a booking can be cancelled
  bool canCancelBooking(Booking booking) {
    if (booking.status == 'cancelled' || booking.status == 'completed') {
      return false;
    }

    if (booking.appointmentDate != null) {
      final now = DateTime.now();
      final bookingDateTime = booking.appointmentDate!;

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

    if (booking.appointmentDate != null) {
      final now = DateTime.now();
      final bookingDateTime = booking.appointmentDate!;

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
    final response = await getUserBookings();
    if (response.isSuccess && response.data != null) {
      return response.data!
          .where(
            (booking) =>
                booking.appointmentDate != null &&
                _isSameDate(booking.appointmentDate!, date),
          )
          .toList();
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
