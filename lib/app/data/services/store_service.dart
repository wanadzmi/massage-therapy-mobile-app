import '../models/store_model.dart';
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
}
