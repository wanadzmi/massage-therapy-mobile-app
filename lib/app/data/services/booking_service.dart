import '../models/booking_model.dart';
import 'base_services.dart';

class BookingService extends BaseServices {
  static const String _bookingsEndpoint = '/api/bookings';
  static const String _availabilityEndpoint = '/api/bookings/availability';
  static const String _cancelEndpoint = '/api/bookings/cancel';
  static const String _rescheduleEndpoint = '/api/bookings/reschedule';

  /// Create a new booking
  Future<MyResponse<Booking?, dynamic>> createBooking({
    required String serviceId,
    required String appointmentDate,
    required String appointmentTime,
    String? notes,
  }) async {
    final response = await callAPI(
      HttpRequestType.POST,
      _bookingsEndpoint,
      postBody: {
        'service_id': serviceId,
        'appointment_date': appointmentDate,
        'appointment_time': appointmentTime,
        if (notes != null) 'notes': notes,
      },
    );

    if (response.isSuccess && response.data != null) {
      try {
        final booking = Booking.fromJson(response.data);
        return MyResponse.complete(booking);
      } catch (e) {
        return MyResponse.error('Failed to parse booking data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get user's bookings
  Future<MyResponse<List<Booking>, dynamic>> getUserBookings({
    String? status,
    int? limit,
    int? offset,
  }) async {
    String endpoint = _bookingsEndpoint;
    final queryParams = <String>[];

    if (status != null) queryParams.add('status=$status');
    if (limit != null) queryParams.add('limit=$limit');
    if (offset != null) queryParams.add('offset=$offset');

    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }

    final response = await callAPI(HttpRequestType.GET, endpoint);

    if (response.isSuccess && response.data != null) {
      try {
        final List<dynamic> bookingsData =
            response.data['bookings'] ?? response.data;
        final bookings = bookingsData
            .map((bookingJson) => Booking.fromJson(bookingJson))
            .toList();
        return MyResponse.complete(bookings);
      } catch (e) {
        return MyResponse.error('Failed to parse bookings data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get booking by ID
  Future<MyResponse<Booking?, dynamic>> getBookingById(String bookingId) async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_bookingsEndpoint/$bookingId',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final booking = Booking.fromJson(response.data);
        return MyResponse.complete(booking);
      } catch (e) {
        return MyResponse.error('Failed to parse booking data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Check availability for a specific date and service
  Future<MyResponse<List<String>, dynamic>> checkAvailability({
    required String serviceId,
    required String date,
  }) async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_availabilityEndpoint?service_id=$serviceId&date=$date',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final List<dynamic> timeSlotsData =
            response.data['available_times'] ?? response.data;
        final timeSlots = timeSlotsData.cast<String>();
        return MyResponse.complete(timeSlots);
      } catch (e) {
        return MyResponse.error('Failed to parse availability data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Cancel a booking
  Future<MyResponse<bool, dynamic>> cancelBooking(String bookingId) async {
    final response = await callAPI(
      HttpRequestType.POST,
      '$_cancelEndpoint/$bookingId',
    );

    if (response.isSuccess) {
      return MyResponse.complete(true);
    }

    return MyResponse.error(response.error);
  }

  /// Reschedule a booking
  Future<MyResponse<Booking?, dynamic>> rescheduleBooking({
    required String bookingId,
    required String newDate,
    required String newTime,
  }) async {
    final response = await callAPI(
      HttpRequestType.POST,
      '$_rescheduleEndpoint/$bookingId',
      postBody: {'appointment_date': newDate, 'appointment_time': newTime},
    );

    if (response.isSuccess && response.data != null) {
      try {
        final booking = Booking.fromJson(response.data);
        return MyResponse.complete(booking);
      } catch (e) {
        return MyResponse.error('Failed to parse booking data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Update booking status (for admin/therapist use)
  Future<MyResponse<Booking?, dynamic>> updateBookingStatus({
    required String bookingId,
    required String status,
  }) async {
    final response = await callAPI(
      HttpRequestType.PUT,
      '$_bookingsEndpoint/$bookingId/status',
      postBody: {'status': status},
    );

    if (response.isSuccess && response.data != null) {
      try {
        final booking = Booking.fromJson(response.data);
        return MyResponse.complete(booking);
      } catch (e) {
        return MyResponse.error('Failed to parse booking data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get booking history
  Future<MyResponse<List<Booking>, dynamic>> getBookingHistory() async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_bookingsEndpoint/history',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final List<dynamic> bookingsData =
            response.data['bookings'] ?? response.data;
        final bookings = bookingsData
            .map((bookingJson) => Booking.fromJson(bookingJson))
            .toList();
        return MyResponse.complete(bookings);
      } catch (e) {
        return MyResponse.error('Failed to parse bookings data: $e');
      }
    }

    return MyResponse.error(response.error);
  }
}
