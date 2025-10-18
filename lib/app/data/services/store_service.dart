import '../models/store_model.dart';
import '../models/service_model.dart' as service_model;
import 'base_services.dart';

class StoreService extends BaseServices {
  static const String _storesEndpoint = '/api/stores';

  /// Get stores with pagination and filters
  Future<MyResponse<StoresData?, dynamic>> getStores({
    int? limit,
    int? page,
    String? city,
    String? search,
    double? minPrice,
    double? maxPrice,
    List<String>? amenities,
    bool? isVerified,
    bool? isOpen,
  }) async {
    final List<String> queryParts = [];

    if (limit != null) queryParts.add('limit=$limit');
    if (page != null) queryParts.add('page=$page');
    if (city != null) queryParts.add('city=$city');
    if (search != null) queryParts.add('search=$search');
    if (minPrice != null) queryParts.add('minPrice=$minPrice');
    if (maxPrice != null) queryParts.add('maxPrice=$maxPrice');
    if (amenities != null && amenities.isNotEmpty) {
      queryParts.add('amenities=${amenities.join(',')}');
    }
    if (isVerified != null) queryParts.add('isVerified=$isVerified');
    if (isOpen != null) queryParts.add('isOpen=$isOpen');

    final queryString = queryParts.isNotEmpty ? '?${queryParts.join('&')}' : '';
    final endpoint = '$_storesEndpoint$queryString';

    final response = await callAPI(
      HttpRequestType.GET,
      endpoint,
      requiresAuth: true,
    );
    if (response.isSuccess && response.data != null) {
      try {
        final responseData = response.data['data'] ?? response.data;
        final storesData = StoresData.fromJson(responseData);
        return MyResponse.complete(storesData);
      } catch (e) {
        return MyResponse.error('Failed to parse stores data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get store details by ID
  Future<MyResponse<Store?, dynamic>> getStoreById(String storeId) async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_storesEndpoint/$storeId',
      requiresAuth: true,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final storeData = response.data['data'] ?? response.data;
        final store = Store.fromJson(storeData);
        return MyResponse.complete(store);
      } catch (e) {
        return MyResponse.error('Failed to parse store data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get nearby stores based on location
  Future<MyResponse<StoresData?, dynamic>> getNearbyStores({
    required double latitude,
    required double longitude,
    double? maxDistance,
    int? limit,
  }) async {
    final List<String> queryParts = [
      'latitude=$latitude',
      'longitude=$longitude',
    ];

    if (maxDistance != null) queryParts.add('maxDistance=$maxDistance');
    if (limit != null) queryParts.add('limit=$limit');

    final queryString = '?${queryParts.join('&')}';
    final endpoint = '$_storesEndpoint/nearby$queryString';

    final response = await callAPI(
      HttpRequestType.GET,
      endpoint,
      requiresAuth: true,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final responseData = response.data['data'] ?? response.data;
        final storesData = StoresData.fromJson(responseData);
        return MyResponse.complete(storesData);
      } catch (e) {
        return MyResponse.error('Failed to parse nearby stores data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get store services with therapist availability
  Future<MyResponse<StoreServicesData, dynamic>> getStoreServices(
    String storeId,
  ) async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_storesEndpoint/$storeId/services',
      requiresAuth: false,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final responseData = response.data['data'] ?? response.data;

        // Parse services
        final List<dynamic> servicesData = responseData is List
            ? responseData
            : (responseData['services'] ?? []);
        final services = servicesData
            .map((s) => service_model.Service.fromJson(s))
            .toList();

        // Parse therapist availability
        final therapistAvailability = responseData['therapistAvailability'];
        final List<StoreTherapist> therapists = [];

        if (therapistAvailability != null &&
            therapistAvailability['therapists'] != null) {
          therapists.addAll(
            (therapistAvailability['therapists'] as List)
                .map((t) => StoreTherapist.fromJson(t))
                .toList(),
          );
        }

        return MyResponse.complete(
          StoreServicesData(
            services: services,
            therapists: therapists,
            totalTherapists: therapistAvailability?['totalTherapists'] ?? 0,
            activeTherapists: therapistAvailability?['activeTherapists'] ?? 0,
          ),
        );
      } catch (e) {
        return MyResponse.error('Failed to parse store services: $e');
      }
    }

    return MyResponse.error(response.error);
  }
}

/// Store services response data
class StoreServicesData {
  final List<service_model.Service> services;
  final List<StoreTherapist> therapists;
  final int totalTherapists;
  final int activeTherapists;

  StoreServicesData({
    required this.services,
    required this.therapists,
    required this.totalTherapists,
    required this.activeTherapists,
  });
}

/// Therapist info from store services
class StoreTherapist {
  final String id;
  final String name;
  final double? rating;
  final List<String> specializations;
  final bool isVerified;

  StoreTherapist({
    required this.id,
    required this.name,
    this.rating,
    required this.specializations,
    required this.isVerified,
  });

  factory StoreTherapist.fromJson(Map<String, dynamic> json) {
    return StoreTherapist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      rating: json['rating']?.toDouble(),
      specializations: List<String>.from(json['specializations'] ?? []),
      isVerified: json['isVerified'] ?? false,
    );
  }
}
