import '../models/store_model.dart';
import '../services/base_services.dart';
import '../services/store_service.dart';

class StoreRepository {
  final StoreService _storeService = StoreService();

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
    return await _storeService.getStores(
      limit: limit,
      page: page,
      city: city,
      search: search,
      minPrice: minPrice,
      maxPrice: maxPrice,
      amenities: amenities,
      isVerified: isVerified,
      isOpen: isOpen,
    );
  }

  /// Get store details by ID
  Future<MyResponse<Store?, dynamic>> getStoreById(String storeId) async {
    return await _storeService.getStoreById(storeId);
  }

  /// Get nearby stores based on location
  Future<MyResponse<StoresData?, dynamic>> getNearbyStores({
    required double latitude,
    required double longitude,
    double? maxDistance,
    int? limit,
  }) async {
    return await _storeService.getNearbyStores(
      latitude: latitude,
      longitude: longitude,
      maxDistance: maxDistance,
      limit: limit,
    );
  }
}
