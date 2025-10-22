import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/services/notification_service.dart';

class NotificationController extends GetxController {
  final NotificationService _notificationService = NotificationService();

  // Observables
  final _notifications = <NotificationModel>[].obs;
  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _unreadCount = 0.obs;
  final _currentPage = 1.obs;
  final _hasMore = true.obs;
  final _selectedCategory = 'all'.obs;
  final _unreadOnly = false.obs;

  // Getters
  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  int get unreadCount => _unreadCount.value;
  int get currentPage => _currentPage.value;
  bool get hasMore => _hasMore.value;
  String get selectedCategory => _selectedCategory.value;
  bool get unreadOnly => _unreadOnly.value;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  /// Fetch notifications with current filters
  Future<void> fetchNotifications({bool refresh = false}) async {
    if (refresh) {
      _currentPage.value = 1;
      _notifications.clear();
      _hasMore.value = true;
    }

    if (_isLoading.value || _isLoadingMore.value) return;

    if (refresh) {
      _isLoading.value = true;
    } else {
      _isLoadingMore.value = true;
    }

    try {
      final response = await _notificationService.fetchNotifications(
        category: _selectedCategory.value != 'all'
            ? _selectedCategory.value
            : null,
        unreadOnly: _unreadOnly.value ? true : null,
        page: _currentPage.value,
        limit: 20,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!;

        if (refresh) {
          _notifications.value = data.notifications;
        } else {
          _notifications.addAll(data.notifications);
        }

        _unreadCount.value = data.unreadCount;
        _hasMore.value = data.pagination.hasMore;

        print('✅ Fetched ${data.notifications.length} notifications');
        print('📊 Unread count: ${data.unreadCount}');
      } else {
        print('❌ Failed to fetch notifications: ${response.error}');
        _showError('Failed to load notifications');
      }
    } catch (e) {
      print('❌ Error fetching notifications: $e');
      _showError('An error occurred while loading notifications');
    } finally {
      _isLoading.value = false;
      _isLoadingMore.value = false;
    }
  }

  /// Load more notifications (pagination)
  Future<void> loadMore() async {
    if (!_hasMore.value || _isLoadingMore.value) return;

    _currentPage.value++;
    await fetchNotifications();
  }

  /// Refresh notifications (pull-to-refresh)
  Future<void> refresh() async {
    await fetchNotifications(refresh: true);
  }

  /// Set category filter
  void setCategory(String category) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      fetchNotifications(refresh: true);
    }
  }

  /// Toggle unread only filter
  void toggleUnreadOnly() {
    _unreadOnly.value = !_unreadOnly.value;
    fetchNotifications(refresh: true);
  }

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await _notificationService.markAsRead(notificationId);

      if (response.isSuccess) {
        // Update local notification state
        final index = _notifications.indexWhere(
          (n) => n.notificationId == notificationId,
        );
        if (index != -1 && !_notifications[index].isRead) {
          // Create updated notification
          final oldNotification = _notifications[index];
          final updatedChannel = InAppChannel(
            enabled: oldNotification.channels.inApp.enabled,
            read: true,
            readAt: DateTime.now(),
          );
          final updatedChannels = NotificationChannels(
            inApp: updatedChannel,
            push: oldNotification.channels.push,
            email: oldNotification.channels.email,
            sms: oldNotification.channels.sms,
          );

          // Replace with updated notification
          _notifications[index] = NotificationModel(
            id: oldNotification.id,
            notificationId: oldNotification.notificationId,
            title: oldNotification.title,
            body: oldNotification.body,
            shortText: oldNotification.shortText,
            type: oldNotification.type,
            category: oldNotification.category,
            priority: oldNotification.priority,
            isUrgent: oldNotification.isUrgent,
            channels: updatedChannels,
            data: oldNotification.data,
            createdAt: oldNotification.createdAt,
            updatedAt: DateTime.now(),
          );

          // Update unread count
          _unreadCount.value = (_unreadCount.value - 1).clamp(0, 999);
          _notifications.refresh();

          print('✅ Marked notification as read');
        }
      } else {
        print('❌ Failed to mark as read: ${response.error}');
      }
    } catch (e) {
      print('❌ Error marking as read: $e');
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final response = await _notificationService.markAllAsRead(
        category: _selectedCategory.value != 'all'
            ? _selectedCategory.value
            : null,
      );

      if (response.isSuccess) {
        // Update all local notifications
        for (var i = 0; i < _notifications.length; i++) {
          if (!_notifications[i].isRead) {
            final oldNotification = _notifications[i];
            final updatedChannel = InAppChannel(
              enabled: oldNotification.channels.inApp.enabled,
              read: true,
              readAt: DateTime.now(),
            );
            final updatedChannels = NotificationChannels(
              inApp: updatedChannel,
              push: oldNotification.channels.push,
              email: oldNotification.channels.email,
              sms: oldNotification.channels.sms,
            );

            _notifications[i] = NotificationModel(
              id: oldNotification.id,
              notificationId: oldNotification.notificationId,
              title: oldNotification.title,
              body: oldNotification.body,
              shortText: oldNotification.shortText,
              type: oldNotification.type,
              category: oldNotification.category,
              priority: oldNotification.priority,
              isUrgent: oldNotification.isUrgent,
              channels: updatedChannels,
              data: oldNotification.data,
              createdAt: oldNotification.createdAt,
              updatedAt: DateTime.now(),
            );
          }
        }

        _unreadCount.value = 0;
        _notifications.refresh();

        Get.snackbar(
          'Success',
          'All notifications marked as read',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFD4AF37),
          colorText: Colors.black,
          duration: const Duration(seconds: 2),
        );

        print('✅ Marked all as read');
      } else {
        print('❌ Failed to mark all as read: ${response.error}');
        _showError('Failed to mark all as read');
      }
    } catch (e) {
      print('❌ Error marking all as read: $e');
      _showError('An error occurred');
    }
  }

  /// Track notification click
  Future<void> trackClick(String notificationId) async {
    try {
      await _notificationService.trackClick(notificationId, actionTaken: true);
      print('✅ Tracked notification click');
    } catch (e) {
      print('❌ Error tracking click: $e');
    }
  }

  /// Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      final response = await _notificationService.deleteNotification(
        notificationId,
      );

      if (response.isSuccess) {
        final index = _notifications.indexWhere(
          (n) => n.notificationId == notificationId,
        );
        if (index != -1) {
          final wasUnread = !_notifications[index].isRead;
          _notifications.removeAt(index);

          if (wasUnread) {
            _unreadCount.value = (_unreadCount.value - 1).clamp(0, 999);
          }

          print('✅ Notification deleted');
        }
      } else {
        print('❌ Failed to delete notification: ${response.error}');
        _showError('Failed to delete notification');
      }
    } catch (e) {
      print('❌ Error deleting notification: $e');
      _showError('An error occurred');
    }
  }

  /// Handle notification click (mark as read, track, navigate)
  Future<void> handleNotificationClick(NotificationModel notification) async {
    // Mark as read if not already
    if (!notification.isRead) {
      await markAsRead(notification.notificationId);
    }

    // Track click
    await trackClick(notification.notificationId);

    // Navigate based on action URL
    if (notification.data.actionUrl != null) {
      _navigateToAction(
        notification.data.actionUrl!,
        notification.data.actionData,
      );
    }
  }

  /// Navigate to the appropriate screen based on action URL
  void _navigateToAction(String actionUrl, Map<String, dynamic>? actionData) {
    print('🔗 Navigating to: $actionUrl');

    if (actionUrl.startsWith('/bookings/')) {
      // Extract booking ID and navigate to booking details
      final bookingId = actionUrl.split('/').last;
      Get.toNamed('/booking-detail', arguments: {'bookingId': bookingId});
    } else if (actionUrl == '/wallet') {
      Get.toNamed('/wallet-topup');
    } else if (actionUrl == '/profile') {
      Get.toNamed('/profile');
    } else if (actionUrl.startsWith('/')) {
      // Generic route navigation
      Get.toNamed(actionUrl);
    } else {
      print('⚠️ Unknown action URL: $actionUrl');
    }
  }

  /// Show error snackbar
  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  /// Get unread count only (for badge updates)
  Future<void> updateUnreadCount() async {
    try {
      final response = await _notificationService.fetchNotifications(
        page: 1,
        limit: 1,
      );

      if (response.isSuccess && response.data != null) {
        _unreadCount.value = response.data!.unreadCount;
      }
    } catch (e) {
      print('❌ Error updating unread count: $e');
    }
  }
}
