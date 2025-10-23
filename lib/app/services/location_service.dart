import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission;
  }

  /// Get current position with permission handling
  Future<Position?> getCurrentPosition() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        return null;
      }

      // Check permission
      LocationPermission permission = await checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await requestPermission();
        if (permission == LocationPermission.denied) {
          _showPermissionDeniedSnackbar();
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showPermissionDeniedForeverDialog();
        return null;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );

      return position;
    } catch (e) {
      _showErrorSnackbar('Failed to get location: $e');
      return null;
    }
  }

  /// Get current latitude and longitude as a map
  Future<Map<String, double>?> getCurrentLatLng() async {
    Position? position = await getCurrentPosition();
    if (position != null) {
      return {'latitude': position.latitude, 'longitude': position.longitude};
    }
    return null;
  }

  /// Calculate distance between two coordinates in kilometers
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
          startLatitude,
          startLongitude,
          endLatitude,
          endLongitude,
        ) /
        1000; // Convert to kilometers
  }

  /// Format distance for display
  String formatDistance(double distanceInKm) {
    if (distanceInKm < 1) {
      return '${(distanceInKm * 1000).toStringAsFixed(0)} m';
    } else if (distanceInKm < 10) {
      return '${distanceInKm.toStringAsFixed(1)} km';
    } else {
      return '${distanceInKm.toStringAsFixed(0)} km';
    }
  }

  /// Open app settings for location permission
  Future<void> openAppSettings() async {
    await Geolocator.openAppSettings();
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  // UI Helper Methods

  void _showLocationServiceDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Location Service Disabled',
          style: TextStyle(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Please enable location services to find nearby stores.',
          style: TextStyle(color: Color(0xFF808080), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF808080)),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openLocationSettings();
            },
            child: const Text(
              'Open Settings',
              style: TextStyle(color: Color(0xFFD4AF37)),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showPermissionDeniedForeverDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Location Permission Required',
          style: TextStyle(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Location permission is permanently denied. Please enable it in app settings to use location-based features.',
          style: TextStyle(color: Color(0xFF808080), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF808080)),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text(
              'Open Settings',
              style: TextStyle(color: Color(0xFFD4AF37)),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showPermissionDeniedSnackbar() {
    Get.snackbar(
      'Permission Denied',
      'Location permission is required to find nearby stores',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E1E1E),
      colorText: const Color(0xFFE53E3E),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      icon: const Icon(Icons.location_off, color: Color(0xFFE53E3E)),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E1E1E),
      colorText: const Color(0xFFE53E3E),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
