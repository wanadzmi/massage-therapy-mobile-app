import '../models/banner_model.dart';
import 'base_services.dart';

class BannerService extends BaseServices {
  /// Fetch active banners with optional user tier and role filtering
  Future<MyResponse<List<BannerModel>, dynamic>> getBanners({
    String? userTier,
    String? userRole,
  }) async {
    try {
      // Build query parameters
      final queryParams = <String, String>{};
      if (userTier != null) queryParams['userTier'] = userTier;
      if (userRole != null) queryParams['userRole'] = userRole;

      // Build URL with query params
      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      final path = queryString.isEmpty
          ? '/api/banners'
          : '/api/banners?$queryString';

      print('🎯 BANNER ENDPOINT: GET $path');

      final response = await callAPI(
        HttpRequestType.GET,
        path,
        requiresAuth: false, // Public endpoint
      );

      print('🎯 Banner API response success: ${response.isSuccess}');
      print('🎯 RAW JSON RESPONSE:');
      print('${response.data}');

      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final bannersJson = data['banners'] as List<dynamic>?;

        print('🎯 Banners JSON: $bannersJson');
        print('🎯 Number of banners: ${bannersJson?.length ?? 0}');

        if (bannersJson != null) {
          final banners = bannersJson
              .map((json) => BannerModel.fromJson(json as Map<String, dynamic>))
              .toList();
          print('✅ Successfully parsed ${banners.length} banners');
          return MyResponse.complete(banners);
        }
      }

      print('❌ Banner fetch failed: ${response.error}');
      return MyResponse.error(response.error ?? 'Failed to fetch banners');
    } catch (e) {
      return MyResponse.error('Error fetching banners: $e');
    }
  }

  /// Record a banner view for analytics
  Future<MyResponse<void, dynamic>> recordView(String bannerId) async {
    try {
      final response = await callAPI(
        HttpRequestType.POST,
        '/api/banners/$bannerId/view',
        requiresAuth: false, // Public endpoint
      );

      if (response.isSuccess) {
        return MyResponse.complete(null);
      }

      return MyResponse.error(response.error ?? 'Failed to record view');
    } catch (e) {
      return MyResponse.error('Error recording view: $e');
    }
  }

  /// Record a banner click and get link information
  Future<MyResponse<BannerLink?, dynamic>> recordClick(String bannerId) async {
    try {
      final response = await callAPI(
        HttpRequestType.POST,
        '/api/banners/$bannerId/click',
        requiresAuth: false, // Public endpoint
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final linkJson = data['link'] as Map<String, dynamic>?;

        if (linkJson != null) {
          final link = BannerLink.fromJson(linkJson);
          return MyResponse.complete(link);
        }
        return MyResponse.complete(null);
      }

      return MyResponse.error(response.error ?? 'Failed to record click');
    } catch (e) {
      return MyResponse.error('Error recording click: $e');
    }
  }
}
