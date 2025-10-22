import '../models/notification_model.dart';
import 'base_services.dart';

class NotificationService extends BaseServices {
  static const String _notificationsEndpoint = '/api/notifications';

  /// Fetch notifications list with pagination and filters
  Future<MyResponse<NotificationListResponse?, dynamic>> fetchNotifications({
    String? type,
    String? category,
    bool? unreadOnly,
    int page = 1,
    int limit = 20,
  }) async {
    // Build path with query params
    var path = '$_notificationsEndpoint?page=$page&limit=$limit';
    if (type != null) path += '&type=$type';
    if (category != null) path += '&category=$category';
    if (unreadOnly != null) path += '&unreadOnly=$unreadOnly';

    final response = await callAPI(HttpRequestType.GET, path);

    if (response.isSuccess && response.data != null) {
      try {
        final data = NotificationListResponse.fromJson(response.data['data']);
        return MyResponse.complete(data);
      } catch (e) {
        print('❌ Error parsing notifications: $e');
        return MyResponse.error('Failed to parse notifications: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Mark a specific notification as read
  Future<MyResponse<Map<String, dynamic>?, dynamic>> markAsRead(
    String notificationId,
  ) async {
    final response = await callAPI(
      HttpRequestType.POST,
      '$_notificationsEndpoint/$notificationId/read',
      postBody: {},
    );

    if (response.isSuccess && response.data != null) {
      try {
        return MyResponse.complete(response.data['data']);
      } catch (e) {
        print('❌ Error marking as read: $e');
        return MyResponse.error('Failed to mark as read: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Mark all notifications as read
  Future<MyResponse<Map<String, dynamic>?, dynamic>> markAllAsRead({
    String? category,
    String? type,
  }) async {
    final postBody = <String, dynamic>{};
    if (category != null) postBody['category'] = category;
    if (type != null) postBody['type'] = type;

    final response = await callAPI(
      HttpRequestType.POST,
      '$_notificationsEndpoint/read-all',
      postBody: postBody,
    );

    if (response.isSuccess && response.data != null) {
      try {
        return MyResponse.complete(response.data['data']);
      } catch (e) {
        print('❌ Error marking all as read: $e');
        return MyResponse.error('Failed to mark all as read: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Track notification click/interaction
  Future<MyResponse<Map<String, dynamic>?, dynamic>> trackClick(
    String notificationId, {
    bool actionTaken = true,
  }) async {
    final response = await callAPI(
      HttpRequestType.POST,
      '$_notificationsEndpoint/$notificationId/click',
      postBody: {'actionTaken': actionTaken},
    );

    if (response.isSuccess && response.data != null) {
      try {
        return MyResponse.complete(response.data['data']);
      } catch (e) {
        print('❌ Error tracking click: $e');
        return MyResponse.error('Failed to track click: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Delete a notification
  Future<MyResponse<Map<String, dynamic>?, dynamic>> deleteNotification(
    String notificationId,
  ) async {
    final response = await callAPI(
      HttpRequestType.DELETE,
      '$_notificationsEndpoint/$notificationId',
    );

    if (response.isSuccess && response.data != null) {
      try {
        return MyResponse.complete(response.data['data']);
      } catch (e) {
        print('❌ Error deleting notification: $e');
        return MyResponse.error('Failed to delete notification: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get notification preferences
  Future<MyResponse<NotificationPreferencesModel?, dynamic>>
  getPreferences() async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_notificationsEndpoint/preferences',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final preferences = NotificationPreferencesModel.fromJson(
          response.data['data'],
        );
        return MyResponse.complete(preferences);
      } catch (e) {
        print('❌ Error fetching preferences: $e');
        return MyResponse.error('Failed to fetch preferences: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Update notification preferences
  Future<MyResponse<NotificationPreferencesModel?, dynamic>> updatePreferences(
    NotificationPreferencesModel preferences,
  ) async {
    final response = await callAPI(
      HttpRequestType.PUT,
      '$_notificationsEndpoint/preferences',
      postBody: {'preferences': preferences.toJson()},
    );

    if (response.isSuccess && response.data != null) {
      try {
        final updatedPreferences = NotificationPreferencesModel.fromJson(
          response.data['data'],
        );
        return MyResponse.complete(updatedPreferences);
      } catch (e) {
        print('❌ Error updating preferences: $e');
        return MyResponse.error('Failed to update preferences: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Register device for push notifications (prepared for future FCM)
  Future<MyResponse<Map<String, dynamic>?, dynamic>> registerDevice({
    required String deviceToken,
    required String platform,
    Map<String, dynamic>? deviceInfo,
  }) async {
    final postBody = {
      'deviceToken': deviceToken,
      'platform': platform,
      if (deviceInfo != null) 'deviceInfo': deviceInfo,
    };

    final response = await callAPI(
      HttpRequestType.POST,
      '$_notificationsEndpoint/register-device',
      postBody: postBody,
    );

    if (response.isSuccess && response.data != null) {
      try {
        return MyResponse.complete(response.data['data']);
      } catch (e) {
        print('❌ Error registering device: $e');
        return MyResponse.error('Failed to register device: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Send test notification (development only)
  Future<MyResponse<Map<String, dynamic>?, dynamic>> sendTestNotification({
    required String title,
    required String body,
  }) async {
    final response = await callAPI(
      HttpRequestType.POST,
      '$_notificationsEndpoint/test-push',
      postBody: {'title': title, 'body': body},
    );

    if (response.isSuccess && response.data != null) {
      try {
        return MyResponse.complete(response.data['data']);
      } catch (e) {
        print('❌ Error sending test notification: $e');
        return MyResponse.error('Failed to send test notification: $e');
      }
    }

    return MyResponse.error(response.error);
  }
}
