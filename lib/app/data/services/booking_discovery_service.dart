import '../models/therapist_model.dart';
import 'base_services.dart';

class BookingDiscoveryService extends BaseServices {
  static const String _availableTherapistsEndpoint =
      '/api/booking-discovery/available-therapists';
  static const String _serviceAvailabilityCalendarEndpoint =
      '/api/booking-discovery/service-availability-calendar';

  /// Get 30-day availability calendar for a service
  Future<MyResponse<ServiceAvailabilityCalendar?, dynamic>>
  getServiceAvailabilityCalendar({required String serviceId}) async {
    final endpoint =
        '$_serviceAvailabilityCalendarEndpoint?serviceId=$serviceId';

    final response = await callAPI(
      HttpRequestType.GET,
      endpoint,
      requiresAuth: false,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final calendar = ServiceAvailabilityCalendar.fromJson(response.data);
        return MyResponse.complete(calendar);
      } catch (e) {
        return MyResponse.error('Failed to parse availability calendar: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get available therapists for a specific service, date, and time
  Future<MyResponse<AvailableTherapistsResponse?, dynamic>>
  getAvailableTherapists({
    required String serviceId,
    required String date,
    required String startTime,
    String? cityId,
    String? areaId,
    String? gender,
    double? minRating,
  }) async {
    // Build query parameters
    final queryParams = <String>[];
    queryParams.add('serviceId=$serviceId');
    queryParams.add('date=$date');
    queryParams.add('startTime=$startTime');

    if (cityId != null) queryParams.add('cityId=$cityId');
    if (areaId != null) queryParams.add('areaId=$areaId');
    if (gender != null) queryParams.add('gender=$gender');
    if (minRating != null) queryParams.add('minRating=$minRating');

    final endpoint = '$_availableTherapistsEndpoint?${queryParams.join('&')}';

    final response = await callAPI(
      HttpRequestType.GET,
      endpoint,
      requiresAuth: false,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final availableTherapists = AvailableTherapistsResponse.fromJson(
          response.data,
        );
        return MyResponse.complete(availableTherapists);
      } catch (e) {
        return MyResponse.error(
          'Failed to parse available therapists data: $e',
        );
      }
    }

    return MyResponse.error(response.error);
  }
}

class AvailableTherapistsResponse {
  final String? requestedDate;
  final String? requestedTime;
  final AvailableTherapistService? service;
  final List<Therapist>? availableTherapists;
  final int? totalAvailable;

  AvailableTherapistsResponse({
    this.requestedDate,
    this.requestedTime,
    this.service,
    this.availableTherapists,
    this.totalAvailable,
  });

  factory AvailableTherapistsResponse.fromJson(Map<String, dynamic> json) {
    // Handle nested data structure
    final data = json['data'] ?? json;

    // API returns 'therapists' not 'availableTherapists'
    final therapistsList = data['therapists'] ?? data['availableTherapists'];

    return AvailableTherapistsResponse(
      requestedDate: data['requestedDate'],
      requestedTime: data['requestedTime'],
      service: data['service'] != null
          ? AvailableTherapistService.fromJson(data['service'])
          : null,
      availableTherapists: therapistsList != null
          ? (therapistsList as List).map((t) => Therapist.fromJson(t)).toList()
          : null,
      totalAvailable: data['totalAvailable'] ?? data['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestedDate': requestedDate,
      'requestedTime': requestedTime,
      'service': service?.toJson(),
      'availableTherapists': availableTherapists
          ?.map((t) => t.toJson())
          .toList(),
      'totalAvailable': totalAvailable,
    };
  }
}

class AvailableTherapistService {
  final String? id;
  final String? name;
  final double? price;
  final int? duration;

  AvailableTherapistService({this.id, this.name, this.price, this.duration});

  factory AvailableTherapistService.fromJson(Map<String, dynamic> json) {
    return AvailableTherapistService(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      price: json['price']?.toDouble(),
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'price': price, 'duration': duration};
  }
}

// Service Availability Calendar Models

class ServiceAvailabilityCalendar {
  final CalendarService? service;
  final int? totalDaysWithAvailability;
  final List<DayAvailability>? availabilityCalendar;

  ServiceAvailabilityCalendar({
    this.service,
    this.totalDaysWithAvailability,
    this.availabilityCalendar,
  });

  factory ServiceAvailabilityCalendar.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return ServiceAvailabilityCalendar(
      service: data['service'] != null
          ? CalendarService.fromJson(data['service'])
          : null,
      totalDaysWithAvailability: data['totalDaysWithAvailability'],
      availabilityCalendar: data['availabilityCalendar'] != null
          ? (data['availabilityCalendar'] as List)
                .map((day) => DayAvailability.fromJson(day))
                .toList()
          : null,
    );
  }
}

class CalendarService {
  final String? id;
  final String? name;
  final ServiceDuration? duration;
  final double? price;

  CalendarService({this.id, this.name, this.duration, this.price});

  factory CalendarService.fromJson(Map<String, dynamic> json) {
    return CalendarService(
      id: json['id'],
      name: json['name'],
      duration: json['duration'] != null
          ? ServiceDuration.fromJson(json['duration'])
          : null,
      price: json['price']?.toDouble(),
    );
  }
}

class ServiceDuration {
  final int? minutes;
  final String? display;

  ServiceDuration({this.minutes, this.display});

  factory ServiceDuration.fromJson(Map<String, dynamic> json) {
    return ServiceDuration(minutes: json['minutes'], display: json['display']);
  }
}

class DayAvailability {
  final String? date;
  final String? dayOfWeek;
  final String? displayDate;
  final List<String>? availableSlots;
  final int? totalAvailableSlots;
  final List<SlotDetail>? slotDetails;

  DayAvailability({
    this.date,
    this.dayOfWeek,
    this.displayDate,
    this.availableSlots,
    this.totalAvailableSlots,
    this.slotDetails,
  });

  factory DayAvailability.fromJson(Map<String, dynamic> json) {
    return DayAvailability(
      date: json['date'],
      dayOfWeek: json['dayOfWeek'],
      displayDate: json['displayDate'],
      availableSlots: json['availableSlots'] != null
          ? List<String>.from(json['availableSlots'])
          : null,
      totalAvailableSlots: json['totalAvailableSlots'],
      slotDetails: json['slotDetails'] != null
          ? (json['slotDetails'] as List)
                .map((slot) => SlotDetail.fromJson(slot))
                .toList()
          : null,
    );
  }
}

class SlotDetail {
  final String? time;
  final int? availableTherapists;
  final List<SlotTherapist>? therapists;

  SlotDetail({this.time, this.availableTherapists, this.therapists});

  factory SlotDetail.fromJson(Map<String, dynamic> json) {
    return SlotDetail(
      time: json['time'],
      availableTherapists: json['availableTherapists'],
      therapists: json['therapists'] != null
          ? (json['therapists'] as List)
                .map((t) => SlotTherapist.fromJson(t))
                .toList()
          : null,
    );
  }
}

class SlotTherapist {
  final String? id;
  final String? name;
  final String? profileImage;
  final double? rating;
  final String? store;
  final String? gender;

  SlotTherapist({
    this.id,
    this.name,
    this.profileImage,
    this.rating,
    this.store,
    this.gender,
  });

  factory SlotTherapist.fromJson(Map<String, dynamic> json) {
    return SlotTherapist(
      id: json['id'],
      name: json['name'],
      profileImage: json['profileImage'],
      rating: json['rating']?.toDouble(),
      store: json['store'],
      gender: json['gender'],
    );
  }
}
