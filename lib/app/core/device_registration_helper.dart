import 'dart:io';
import 'package:flutter/foundation.dart';

/// Helper class for device registration
class DeviceRegistrationHelper {
  /// Get platform name
  static String getPlatform() {
    if (kIsWeb) {
      return 'web';
    } else if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isMacOS) {
      return 'macos';
    } else if (Platform.isWindows) {
      return 'windows';
    } else if (Platform.isLinux) {
      return 'linux';
    }
    return 'unknown';
  }

  /// Get device model (simplified version)
  static String getDeviceModel() {
    if (kIsWeb) {
      return 'Web Browser';
    } else if (Platform.isIOS) {
      return 'iOS Device';
    } else if (Platform.isAndroid) {
      return 'Android Device';
    } else {
      return '${getPlatform()} Device';
    }
  }

  /// Get OS version (simplified)
  static String getOsVersion() {
    if (kIsWeb) {
      return 'Web';
    }
    return Platform.operatingSystemVersion;
  }

  /// Get app version (this should match pubspec.yaml version)
  static String getAppVersion() {
    return '1.0.0'; // This should ideally come from package_info_plus
  }

  /// Generate a placeholder device token for future FCM integration
  /// In production, this will be replaced with actual FCM token
  static String getPlaceholderToken() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final platform = getPlatform();
    return 'placeholder_${platform}_$timestamp';
  }
}
