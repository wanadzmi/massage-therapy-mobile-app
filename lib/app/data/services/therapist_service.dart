import 'dart:io';
import 'package:dio/dio.dart';
import 'base_services.dart';

class TherapistService extends BaseServices {
  static const String _therapistProfilePhotoEndpoint =
      '/api/therapists/profile/photo';
  static const String _therapistProfileEndpoint = '/api/therapists/profile';

  /// Upload therapist profile photo using multipart/form-data
  /// Returns the updated profile data with the new photo URL
  Future<MyResponse<Map<String, dynamic>?, dynamic>> uploadProfilePhoto(
    File imageFile,
  ) async {
    try {
      final fileName = imageFile.path.split('/').last;
      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final response = await callAPIUsingFormData(
        HttpRequestType.PUT,
        _therapistProfilePhotoEndpoint,
        formData: formData,
      );

      if (response.isSuccess && response.data != null) {
        try {
          final profileData = response.data['data'] ?? response.data;
          return MyResponse.complete(profileData);
        } catch (e) {
          return MyResponse.error('Failed to parse response: $e');
        }
      }

      return MyResponse.error(response.error);
    } catch (e) {
      return MyResponse.error('Failed to upload photo: $e');
    }
  }

  /// Get therapist profile data
  Future<MyResponse<Map<String, dynamic>?, dynamic>> getProfile() async {
    final response = await callAPI(
      HttpRequestType.GET,
      _therapistProfileEndpoint,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final profileData = response.data['data'] ?? response.data;
        return MyResponse.complete(profileData);
      } catch (e) {
        return MyResponse.error('Failed to parse profile data: $e');
      }
    }

    return MyResponse.error(response.error);
  }
}
