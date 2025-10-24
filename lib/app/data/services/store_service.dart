import '../models/store_model.dart';
import '../models/service_model.dart' as service_model;
import '../models/review_model.dart' as review_model;
import 'base_services.dart';

class StoreService extends BaseServices {
  static const String _storesEndpoint = '/api/stores';

  /// Get stores with pagination and filters
  Future<MyResponse<StoresData?, dynamic>> getStores({
    int? limit,
    int? page,
    String? city,
    String? area,
    String? search,
    double? lat,
    double? lng,
    double? radius,
    double? rating,
    String? priceRange,
    double? minPrice,
    double? maxPrice,
    List<String>? amenities,
    String? sortBy,
    String? sortOrder,
    bool? isVerified,
    bool? isOpen,
  }) async {
    final List<String> queryParts = [];

    if (limit != null) queryParts.add('limit=$limit');
    if (page != null) queryParts.add('page=$page');
    if (city != null) queryParts.add('city=$city');
    if (area != null) queryParts.add('area=$area');
    if (search != null) queryParts.add('search=$search');
    if (lat != null) queryParts.add('lat=$lat');
    if (lng != null) queryParts.add('lng=$lng');
    if (radius != null) queryParts.add('radius=$radius');
    if (rating != null) queryParts.add('rating=$rating');
    if (priceRange != null) queryParts.add('priceRange=$priceRange');
    if (minPrice != null) queryParts.add('minPrice=$minPrice');
    if (maxPrice != null) queryParts.add('maxPrice=$maxPrice');
    if (amenities != null && amenities.isNotEmpty) {
      queryParts.add('amenities=${amenities.join(',')}');
    }
    if (sortBy != null) queryParts.add('sortBy=$sortBy');
    if (sortOrder != null) queryParts.add('sortOrder=$sortOrder');
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

  /// Get store reviews (paginated)
  Future<MyResponse<ReviewData, dynamic>> getStoreReviews(
    String storeId, {
    int? page,
    int? limit,
    int? rating,
    String? sortBy,
    String? sortOrder,
  }) async {
    final List<String> queryParts = [];

    if (page != null) queryParts.add('page=$page');
    if (limit != null) queryParts.add('limit=$limit');
    if (rating != null) queryParts.add('rating=$rating');
    if (sortBy != null) queryParts.add('sortBy=$sortBy');
    if (sortOrder != null) queryParts.add('sortOrder=$sortOrder');

    final queryString = queryParts.isNotEmpty ? '?${queryParts.join('&')}' : '';
    final endpoint = '$_storesEndpoint/$storeId/reviews$queryString';

    final response = await callAPI(
      HttpRequestType.GET,
      endpoint,
      requiresAuth: true,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final responseData = response.data['data'] ?? response.data;

        if (responseData['statistics'] != null) {
          if (responseData['statistics']['ratingDistribution'] != null) {}
        }

        final reviewData = ReviewData.fromJson(responseData);
        return MyResponse.complete(reviewData);
      } catch (e) {
        return MyResponse.error('Failed to parse reviews: $e');
      }
    }

    return MyResponse.error(response.error);
  }
}

/// Review data response
class ReviewData {
  final List<review_model.Review> reviews;
  final ReviewStatistics? statistics;
  final ReviewPagination? pagination;

  ReviewData({required this.reviews, this.statistics, this.pagination});

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    List<review_model.Review> reviews = [];
    if (json['reviews'] != null) {
      try {
        reviews = (json['reviews'] as List).map((e) {
          return review_model.Review.fromJson(e);
        }).toList();
      } catch (e) {
        rethrow;
      }
    }

    ReviewStatistics? statistics;
    if (json['statistics'] != null) {
      try {
        statistics = ReviewStatistics.fromJson(json['statistics']);
      } catch (e) {
        rethrow;
      }
    }

    ReviewPagination? pagination;
    if (json['pagination'] != null) {
      try {
        pagination = ReviewPagination.fromJson(json['pagination']);
      } catch (e) {
        rethrow;
      }
    }

    return ReviewData(
      reviews: reviews,
      statistics: statistics,
      pagination: pagination,
    );
  }
}

class ReviewStatistics {
  final double? averageRating;
  final int? totalReviews;
  final Map<String, int>? ratingDistribution;

  ReviewStatistics({
    this.averageRating,
    this.totalReviews,
    this.ratingDistribution,
  });

  factory ReviewStatistics.fromJson(Map<String, dynamic> json) {
    Map<String, int>? ratingDistribution;
    if (json['ratingDistribution'] != null) {
      ratingDistribution = {};
      try {
        (json['ratingDistribution'] as Map<String, dynamic>).forEach((
          key,
          value,
        ) {
          // Handle both int, num, and string values from backend
          if (value is int) {
            ratingDistribution![key] = value;
          } else if (value is num) {
            ratingDistribution![key] = value.toInt();
          } else if (value is String) {
            ratingDistribution![key] = int.tryParse(value) ?? 0;
          } else {
            ratingDistribution![key] = 0;
          }
        });
      } catch (e) {
        ratingDistribution = null;
      }
    }

    return ReviewStatistics(
      averageRating: json['averageRating']?.toDouble(),
      totalReviews: json['totalReviews'] is int
          ? json['totalReviews']
          : (json['totalReviews'] is String
                ? int.tryParse(json['totalReviews'])
                : null),
      ratingDistribution: ratingDistribution,
    );
  }
}

class ReviewPagination {
  final int? current;
  final int? total;
  final int? limit;
  final int? totalReviews;

  ReviewPagination({this.current, this.total, this.limit, this.totalReviews});

  factory ReviewPagination.fromJson(Map<String, dynamic> json) {
    return ReviewPagination(
      current: json['current'],
      total: json['total'],
      limit: json['limit'],
      totalReviews: json['totalReviews'],
    );
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
