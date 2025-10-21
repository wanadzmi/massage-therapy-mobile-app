import '../models/booking_model.dart';
import 'base_services.dart';

class BookingService extends BaseServices {
  static const String _bookingsEndpoint = '/api/bookings';
  static const String _myBookingsEndpoint = '/api/bookings/my-bookings';

  /// Create a new booking
  Future<MyResponse<Booking?, dynamic>> createBooking({
    required String therapistId,
    required String serviceId,
    required String date,
    required String startTime,
    String? paymentMethod,
    String? voucherCode,
    Map<String, dynamic>? preferences,
    String? notes,
  }) async {
    final postBody = <String, dynamic>{
      'therapistId': therapistId,
      'serviceId': serviceId,
      'date': date,
      'startTime': startTime,
    };

    if (paymentMethod != null) postBody['paymentMethod'] = paymentMethod;
    if (voucherCode != null) postBody['voucherCode'] = voucherCode;
    if (preferences != null) postBody['preferences'] = preferences;
    if (notes != null) postBody['notes'] = notes;

    final response = await callAPI(
      HttpRequestType.POST,
      _bookingsEndpoint,
      postBody: postBody,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final bookingData = response.data['data'] ?? response.data;
        final booking = Booking.fromJson(bookingData);
        return MyResponse.complete(booking);
      } catch (e) {
        return MyResponse.error('Failed to parse booking data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get user's bookings (my-bookings endpoint)
  Future<MyResponse<MyBookingsResponse?, dynamic>> getMyBookings({
    String? status,
    int? page,
    int? limit,
  }) async {
    final queryParams = <String>[];

    if (status != null) queryParams.add('status=$status');
    if (page != null) queryParams.add('page=$page');
    if (limit != null) queryParams.add('limit=$limit');

    String endpoint = _myBookingsEndpoint;
    if (queryParams.isNotEmpty) {
      endpoint += '?${queryParams.join('&')}';
    }

    final response = await callAPI(HttpRequestType.GET, endpoint);

    if (response.isSuccess && response.data != null) {
      try {
        final myBookingsResponse = MyBookingsResponse.fromJson(response.data);
        return MyResponse.complete(myBookingsResponse);
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

  /// Cancel a booking with reason
  Future<MyResponse<Booking?, dynamic>> cancelBooking(
    String bookingId, {
    String? reason,
    String? details,
  }) async {
    final response = await callAPI(
      HttpRequestType.PUT,
      '$_bookingsEndpoint/$bookingId/cancel',
      postBody: {
        if (reason != null) 'reason': reason,
        if (details != null) 'details': details,
      },
    );

    if (response.isSuccess && response.data != null) {
      try {
        final bookingData = response.data['data'] ?? response.data;
        final booking = Booking.fromJson(bookingData);
        return MyResponse.complete(booking);
      } catch (e) {
        return MyResponse.error('Failed to parse booking data: $e');
      }
    }

    return MyResponse.error(response.error);
  }
}

/// Response model for my-bookings endpoint
class MyBookingsResponse {
  final List<Booking>? bookings;
  final BookingPagination? pagination;

  MyBookingsResponse({this.bookings, this.pagination});

  factory MyBookingsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return MyBookingsResponse(
      bookings: data['bookings'] != null
          ? (data['bookings'] as List).map((b) => Booking.fromJson(b)).toList()
          : null,
      pagination: data['pagination'] != null
          ? BookingPagination.fromJson(data['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookings': bookings?.map((b) => b.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class BookingPagination {
  final int? currentPage;
  final int? totalPages;
  final int? totalBookings;
  final bool? hasNext;
  final bool? hasPrev;

  BookingPagination({
    this.currentPage,
    this.totalPages,
    this.totalBookings,
    this.hasNext,
    this.hasPrev,
  });

  factory BookingPagination.fromJson(Map<String, dynamic> json) {
    return BookingPagination(
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalBookings: json['totalBookings'],
      hasNext: json['hasNext'],
      hasPrev: json['hasPrev'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalBookings': totalBookings,
      'hasNext': hasNext,
      'hasPrev': hasPrev,
    };
  }
}
