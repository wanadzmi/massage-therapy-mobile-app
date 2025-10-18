import '../models/service_model.dart';
import '../services/services_service.dart';
import '../services/base_services.dart';

class ServicesRepository {
  final ServicesService _servicesService = ServicesService();

  /// Get all available services
  Future<MyResponse<List<Service>, dynamic>> getAllServices() async {
    return await _servicesService.getAllServices();
  }

  /// Get services by category
  Future<MyResponse<List<Service>, dynamic>> getServicesByCategory(
    String category,
  ) async {
    return await _servicesService.getServicesByCategory(category);
  }

  /// Get service by ID
  Future<MyResponse<Service?, dynamic>> getServiceById(String serviceId) async {
    return await _servicesService.getServiceById(serviceId);
  }

  /// Search services
  Future<MyResponse<List<Service>, dynamic>> searchServices(
    String query,
  ) async {
    return await _servicesService.searchServices(query);
  }

  /// Get service categories
  Future<MyResponse<List<String>, dynamic>> getCategories() async {
    return await _servicesService.getCategories();
  }

  /// Get featured services
  Future<MyResponse<List<Service>, dynamic>> getFeaturedServices() async {
    return await _servicesService.getFeaturedServices();
  }

  /// Get services with local caching (optional enhancement)
  Future<List<Service>> getCachedServices() async {
    // This could implement local caching logic
    // For now, just return from API
    final response = await getAllServices();
    return response.isSuccess ? response.data ?? [] : [];
  }

  /// Filter services by price range
  List<Service> filterServicesByPrice(
    List<Service> services,
    double minPrice,
    double maxPrice,
  ) {
    return services.where((service) {
      final price = service.pricing?.finalPrice ?? 0.0;
      return price >= minPrice && price <= maxPrice;
    }).toList();
  }

  /// Filter services by duration
  List<Service> filterServicesByDuration(
    List<Service> services,
    int minDuration,
    int maxDuration,
  ) {
    return services.where((service) {
      final duration = service.duration?.minutes ?? 0;
      return duration >= minDuration && duration <= maxDuration;
    }).toList();
  }

  /// Sort services by price
  List<Service> sortServicesByPrice(
    List<Service> services, {
    bool ascending = true,
  }) {
    final sortedServices = List<Service>.from(services);
    sortedServices.sort((a, b) {
      final priceA = a.pricing?.finalPrice ?? 0.0;
      final priceB = b.pricing?.finalPrice ?? 0.0;
      return ascending ? priceA.compareTo(priceB) : priceB.compareTo(priceA);
    });
    return sortedServices;
  }

  /// Sort services by duration
  List<Service> sortServicesByDuration(
    List<Service> services, {
    bool ascending = true,
  }) {
    final sortedServices = List<Service>.from(services);
    sortedServices.sort((a, b) {
      final durationA = a.duration?.minutes ?? 0;
      final durationB = b.duration?.minutes ?? 0;
      return ascending
          ? durationA.compareTo(durationB)
          : durationB.compareTo(durationA);
    });
    return sortedServices;
  }
}
