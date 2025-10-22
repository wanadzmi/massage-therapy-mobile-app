import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/notification/controllers/notification_controller.dart';

/// Observer that handles app lifecycle events
/// Updates notification count when app comes to foreground
class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // App came to foreground
      _onAppResumed();
    }
  }

  void _onAppResumed() {
    print('🔄 App resumed - refreshing notifications...');

    try {
      // Check if NotificationController exists and update it
      if (Get.isRegistered<NotificationController>()) {
        final notificationController = Get.find<NotificationController>();
        notificationController.updateUnreadCount();
        print('✅ Notifications refreshed');
      }
    } catch (e) {
      print('⚠️ Failed to refresh notifications: $e');
    }
  }
}
