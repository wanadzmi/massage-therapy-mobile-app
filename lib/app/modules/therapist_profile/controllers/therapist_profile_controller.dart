import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/therapist_service.dart';

class TherapistProfileController extends GetxController {
  final TherapistService _therapistService = TherapistService();
  final ImagePicker _picker = ImagePicker();

  final isLoading = false.obs;
  final isUploadingPhoto = false.obs;
  final profileImageUrl = Rxn<String>();
  final therapistName = ''.obs;
  final therapistEmail = ''.obs;
  final therapistPhone = ''.obs;
  final therapistSpecialization = ''.obs;
  final experienceYears = 0.obs;
  final rating = 0.0.obs;
  final completedSessions = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;

      print('📱 Loading therapist profile...');
      final response = await _therapistService.getProfile();

      print('📦 Profile response - Success: ${response.isSuccess}');
      print('📦 Profile response - Data: ${response.data}');
      print('📦 Profile response - Error: ${response.error}');

      if (response.isSuccess && response.data != null) {
        final data = response.data!;

        print('✅ Profile data received: $data');

        // Extract basic profile info
        therapistName.value = data['name'] ?? data['fullName'] ?? '';
        therapistEmail.value = data['email'] ?? '';
        therapistPhone.value = data['phone'] ?? data['phoneNumber'] ?? '';
        profileImageUrl.value = data['profileImage'] ?? data['photo'];

        // Extract therapist-specific info from nested therapistInfo object
        final therapistInfo = data['therapistInfo'] as Map<String, dynamic>?;

        if (therapistInfo != null) {
          print('🔍 TherapistInfo found: $therapistInfo');

          // Get specializations (array)
          final specializations = therapistInfo['specializations'] as List?;
          if (specializations != null && specializations.isNotEmpty) {
            therapistSpecialization.value = specializations.first.toString();
          } else {
            therapistSpecialization.value = 'Massage Therapist';
          }

          // Get experience (direct value)
          experienceYears.value = therapistInfo['experience'] ?? 0;

          // Get rating from nested rating object
          final ratingData = therapistInfo['rating'] as Map<String, dynamic>?;
          if (ratingData != null) {
            rating.value = (ratingData['average'] ?? 0.0).toDouble();
          }
        }

        // Get completed sessions from bookingStats
        final bookingStats = data['bookingStats'] as Map<String, dynamic>?;
        if (bookingStats != null) {
          completedSessions.value = bookingStats['completedBookings'] ?? 0;
          print(
            '🔍 BookingStats: completedBookings = ${completedSessions.value}',
          );
        }

        print('✅ Profile loaded:');
        print('   Name: ${therapistName.value}');
        print('   Email: ${therapistEmail.value}');
        print('   Phone: ${therapistPhone.value}');
        print('   Specialization: ${therapistSpecialization.value}');
        print('   Experience: ${experienceYears.value} years');
        print('   Rating: ${rating.value}');
        print('   Completed Sessions: ${completedSessions.value}');
      } else {
        print('❌ Failed to load profile: ${response.error}');
        Get.snackbar(
          'Profile Error',
          response.error ?? 'Failed to load profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e, stackTrace) {
      print('❌ Exception loading profile: $e');
      print('❌ Stack trace: $stackTrace');
      Get.snackbar(
        'Error',
        'Failed to load profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAndUploadImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      isUploadingPhoto.value = true;
      Get.back(); // Close the picker dialog

      final file = File(pickedFile.path);
      final response = await _therapistService.uploadProfilePhoto(file);

      if (response.isSuccess && response.data != null) {
        final newPhotoUrl = response.data!['profileImage'] as String?;
        profileImageUrl.value = newPhotoUrl;

        Get.dialog(
          Dialog(
            backgroundColor: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF4CAF50).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Photo Updated!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your profile photo has been successfully updated.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xFF808080)),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to upload photo',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isUploadingPhoto.value = false;
    }
  }

  void showImagePickerOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF808080),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose Photo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.camera_alt, color: Color(0xFF2196F3)),
                ),
                title: const Text(
                  'Take Photo',
                  style: TextStyle(fontSize: 16, color: Color(0xFFE0E0E0)),
                ),
                onTap: () => pickAndUploadImage(ImageSource.camera),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.photo_library,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(fontSize: 16, color: Color(0xFFE0E0E0)),
                ),
                onTap: () => pickAndUploadImage(ImageSource.gallery),
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF808080).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.close, color: Color(0xFF808080)),
                ),
                title: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 16, color: Color(0xFF808080)),
                ),
                onTap: () => Get.back(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
