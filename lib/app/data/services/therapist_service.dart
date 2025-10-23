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
      print('📸 Starting photo upload...');
      print('   File path: ${imageFile.path}');
      print('   File exists: ${await imageFile.exists()}');

      final fileSize = await imageFile.length();
      print('   File size: ${(fileSize / 1024).toStringAsFixed(2)} KB');

      final fileName = imageFile.path.split('/').last;
      print('   File name: $fileName');
      print('   Endpoint: $_therapistProfilePhotoEndpoint');

      final formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      print('📤 Uploading to: PUT $_therapistProfilePhotoEndpoint');

      final response = await callAPIUsingFormData(
        HttpRequestType.PUT,
        _therapistProfilePhotoEndpoint,
        formData: formData,
      );

      print('📥 Upload response received:');
      print('   Success: ${response.isSuccess}');
      print('   Raw Data: ${response.data}');
      print('   Error: ${response.error}');

      if (response.isSuccess && response.data != null) {
        try {
          final profileData = response.data['data'] ?? response.data;
          print('✅ Photo uploaded successfully');
          print('   Profile data: $profileData');
          return MyResponse.complete(profileData);
        } catch (e) {
          print('❌ Failed to parse response: $e');
          return MyResponse.error('Failed to parse response: $e');
        }
      }

      print('❌ Upload failed: ${response.error}');
      return MyResponse.error(response.error);
    } catch (e, stackTrace) {
      print('❌ Exception during photo upload: $e');
      print('❌ Stack trace: $stackTrace');
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
