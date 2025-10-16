import '../models/service_model.dart';
import 'base_services.dart';

class ServicesService extends BaseServices {
  static const String _servicesEndpoint = '/api/services';
  static const String _categoriesEndpoint = '/api/services/categories';
  static const String _searchEndpoint = '/api/services/search';

  /// Get all available services
  Future<MyResponse<List<Service>, dynamic>> getAllServices() async {
    final response = await callAPI(
      HttpRequestType.GET,
      _servicesEndpoint,
      requiresAuth: false,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final List<dynamic> servicesData =
            response.data['services'] ?? response.data;
        final services = servicesData
            .map((serviceJson) => Service.fromJson(serviceJson))
            .toList();
        return MyResponse.complete(services);
      } catch (e) {
        return MyResponse.error('Failed to parse services data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get services by category
  Future<MyResponse<List<Service>, dynamic>> getServicesByCategory(
    String category,
  ) async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_servicesEndpoint?category=$category',
      requiresAuth: false,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final List<dynamic> servicesData =
            response.data['services'] ?? response.data;
        final services = servicesData
            .map((serviceJson) => Service.fromJson(serviceJson))
            .toList();
        return MyResponse.complete(services);
      } catch (e) {
        return MyResponse.error('Failed to parse services data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get service by ID
  Future<MyResponse<Service?, dynamic>> getServiceById(String serviceId) async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_servicesEndpoint/$serviceId',
      requiresAuth: false,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final service = Service.fromJson(response.data);
        return MyResponse.complete(service);
      } catch (e) {
        return MyResponse.error('Failed to parse service data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Search services by name or description
  Future<MyResponse<List<Service>, dynamic>> searchServices(
    String query,
  ) async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_searchEndpoint?q=$query',
      requiresAuth: false,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final List<dynamic> servicesData =
            response.data['services'] ?? response.data;
        final services = servicesData
            .map((serviceJson) => Service.fromJson(serviceJson))
            .toList();
        return MyResponse.complete(services);
      } catch (e) {
        return MyResponse.error('Failed to parse services data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get service categories
  Future<MyResponse<List<String>, dynamic>> getCategories() async {
    final response = await callAPI(
      HttpRequestType.GET,
      _categoriesEndpoint,
      requiresAuth: false,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final List<dynamic> categoriesData =
            response.data['categories'] ?? response.data;
        final categories = categoriesData.cast<String>();
        return MyResponse.complete(categories);
      } catch (e) {
        return MyResponse.error('Failed to parse categories data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get featured/popular services
  Future<MyResponse<List<Service>, dynamic>> getFeaturedServices() async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_servicesEndpoint/featured',
      requiresAuth: false,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final List<dynamic> servicesData =
            response.data['services'] ?? response.data;
        final services = servicesData
            .map((serviceJson) => Service.fromJson(serviceJson))
            .toList();
        return MyResponse.complete(services);
      } catch (e) {
        return MyResponse.error('Failed to parse services data: $e');
      }
    }

    return MyResponse.error(response.error);
  }
}
