import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../data/services/therapist_service.dart';

class ProfilePhotoUploadWidget extends StatefulWidget {
  final String? currentPhotoUrl;
  final Function(String?)? onPhotoUpdated;
  final double size;
  final bool isEditable;

  const ProfilePhotoUploadWidget({
    super.key,
    this.currentPhotoUrl,
    this.onPhotoUpdated,
    this.size = 120,
    this.isEditable = true,
  });

  @override
  State<ProfilePhotoUploadWidget> createState() =>
      _ProfilePhotoUploadWidgetState();
}

class _ProfilePhotoUploadWidgetState extends State<ProfilePhotoUploadWidget> {
  final TherapistService _therapistService = TherapistService();
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  File? _selectedImage;

  Future<void> _pickAndUploadImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() {
        _selectedImage = File(pickedFile.path);
        _isUploading = true;
      });

      // Upload the image
      final response = await _therapistService.uploadProfilePhoto(
        _selectedImage!,
      );

      if (response.isSuccess && response.data != null) {
        final newPhotoUrl = response.data!['profileImage'] as String?;

        Get.back(); // Close the picker dialog

        // Show success dialog
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
                      onPressed: () {
                        Get.back();
                        widget.onPhotoUpdated?.call(newPhotoUrl);
                      },
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
        Get.back();
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to upload photo',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.back();
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _selectedImage = null;
        });
      }
    }
  }

  void _showImagePickerOptions() {
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
                onTap: () => _pickAndUploadImage(ImageSource.camera),
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
                onTap: () => _pickAndUploadImage(ImageSource.gallery),
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEditable && !_isUploading
          ? _showImagePickerOptions
          : null,
      child: Stack(
        children: [
          Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD4AF37), width: 3),
              image: _selectedImage != null
                  ? DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    )
                  : widget.currentPhotoUrl != null
                  ? DecorationImage(
                      image: NetworkImage(widget.currentPhotoUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _selectedImage == null && widget.currentPhotoUrl == null
                ? const Icon(Icons.person, size: 60, color: Color(0xFF808080))
                : null,
          ),
          if (_isUploading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.6),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFD4AF37),
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
          if (widget.isEditable && !_isUploading)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF1A1A1A), width: 3),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
