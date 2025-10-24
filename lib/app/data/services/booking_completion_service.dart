import '../models/booking_model.dart';
import 'base_services.dart';

class BookingCompletionService extends BaseServices {
  static const String _bookingsEndpoint = '/api/bookings';

  /// Complete a booking (Therapist only)
  Future<MyResponse<BookingCompletionResponse?, dynamic>> completeBooking({
    required String bookingId,
    int? customerSatisfaction,
  }) async {
    final Map<String, dynamic> postBody = {};

    if (customerSatisfaction != null) {
      if (customerSatisfaction < 1 || customerSatisfaction > 5) {
        return MyResponse.error(
          'Customer satisfaction must be between 1 and 5',
        );
      }
      postBody['customerSatisfaction'] = customerSatisfaction;
    }

    final response = await callAPI(
      HttpRequestType.PUT,
      '$_bookingsEndpoint/$bookingId/complete',
      postBody: postBody.isNotEmpty ? postBody : null,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final completionResponse = BookingCompletionResponse.fromJson(
          response.data,
        );
        return MyResponse.complete(completionResponse);
      } catch (e) {
        return MyResponse.error('Failed to parse completion response: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get therapist's bookings with optional filters
  ///
  /// [status] - Filter by status (e.g., 'confirmed', 'in_progress', 'completed')
  /// [today] - Get only today's bookings
  /// [upcoming] - Get upcoming bookings only
  /// [past] - Get past bookings only
  /// [page] - Page number (default: 1)
  /// [limit] - Items per page (default: 20)
  Future<MyResponse<TherapistBookingsResponse, dynamic>> getTherapistBookings({
    String? status,
    bool? today,
    bool? upcoming,
    bool? past,
    int? page,
    int? limit,
  }) async {
    // Build query parameters
    final queryParams = <String, String>{};
    if (status != null) queryParams['status'] = status;
    if (today == true) queryParams['today'] = 'true';
    if (upcoming == true) queryParams['upcoming'] = 'true';
    if (past == true) queryParams['past'] = 'true';
    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();

    final queryString = queryParams.isEmpty
        ? ''
        : '?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}';

    final response = await callAPI(
      HttpRequestType.GET,
      '/api/bookings/therapist/my-bookings$queryString',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final therapistResponse = TherapistBookingsResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
        return MyResponse.complete(therapistResponse);
      } catch (e) {
        return MyResponse.error('Failed to parse bookings: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get therapist's active bookings (confirmed and in_progress only)
  Future<MyResponse<List<Booking>, dynamic>>
  getTherapistActiveBookings() async {
    final response = await getTherapistBookings(
      status: 'confirmed,in_progress',
      upcoming: true,
    );

    if (response.isSuccess && response.data != null) {
      return MyResponse.complete(response.data!.bookings);
    }

    return MyResponse.error(response.error);
  }
}

/// Response model for booking completion
class BookingCompletionResponse {
  final String? message;
  final BookingCompletionData? data;

  BookingCompletionResponse({this.message, this.data});

  factory BookingCompletionResponse.fromJson(Map<String, dynamic> json) {
    return BookingCompletionResponse(
      message: json['message'],
      data: json['data'] != null
          ? BookingCompletionData.fromJson(json['data'])
          : null,
    );
  }
}

class BookingCompletionData {
  final Booking? booking;
  final int? loyaltyPointsAwarded;
  final int? userNewBalance;

  BookingCompletionData({
    this.booking,
    this.loyaltyPointsAwarded,
    this.userNewBalance,
  });

  factory BookingCompletionData.fromJson(Map<String, dynamic> json) {
    return BookingCompletionData(
      booking: json['booking'] != null
          ? Booking.fromJson(json['booking'])
          : null,
      loyaltyPointsAwarded: json['loyaltyPointsAwarded'],
      userNewBalance: json['userNewBalance'],
    );
  }
}

/// Response model for therapist bookings list
class TherapistBookingsResponse {
  final String? message;
  final List<Booking> bookings;
  final BookingPagination? pagination;

  TherapistBookingsResponse({
    this.message,
    required this.bookings,
    this.pagination,
  });

  factory TherapistBookingsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final bookingsData = data['bookings'] ?? [];

    return TherapistBookingsResponse(
      message: json['message'],
      bookings: (bookingsData as List)
          .map((b) => Booking.fromJson(b as Map<String, dynamic>))
          .toList(),
      pagination: data['pagination'] != null
          ? BookingPagination.fromJson(
              data['pagination'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class BookingPagination {
  final int currentPage;
  final int totalPages;
  final int totalBookings;
  final bool hasNext;
  final bool hasPrev;

  BookingPagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalBookings,
    required this.hasNext,
    required this.hasPrev,
  });

  factory BookingPagination.fromJson(Map<String, dynamic> json) {
    return BookingPagination(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalBookings: json['totalBookings'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      hasPrev: json['hasPrev'] ?? false,
    );
  }
}
