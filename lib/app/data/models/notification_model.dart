class NotificationModel {
  final String id;
  final String notificationId;
  final String title;
  final String body;
  final String shortText;
  final String type;
  final String category;
  final String priority;
  final bool isUrgent;
  final NotificationChannels channels;
  final NotificationData data;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.notificationId,
    required this.title,
    required this.body,
    required this.shortText,
    required this.type,
    required this.category,
    required this.priority,
    required this.isUrgent,
    required this.channels,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isRead => channels.inApp.read;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      notificationId: json['notificationId'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      shortText: json['shortText'] ?? json['body'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      priority: json['priority'] ?? 'normal',
      isUrgent: json['isUrgent'] ?? false,
      channels: NotificationChannels.fromJson(json['channels'] ?? {}),
      data: NotificationData.fromJson(json['data'] ?? {}),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'notificationId': notificationId,
      'title': title,
      'body': body,
      'shortText': shortText,
      'type': type,
      'category': category,
      'priority': priority,
      'isUrgent': isUrgent,
      'channels': channels.toJson(),
      'data': data.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class NotificationChannels {
  final InAppChannel inApp;
  final PushChannel? push;
  final EmailChannel? email;
  final SmsChannel? sms;

  NotificationChannels({required this.inApp, this.push, this.email, this.sms});

  factory NotificationChannels.fromJson(Map<String, dynamic> json) {
    return NotificationChannels(
      inApp: InAppChannel.fromJson(json['inApp'] ?? {}),
      push: json['push'] != null ? PushChannel.fromJson(json['push']) : null,
      email: json['email'] != null
          ? EmailChannel.fromJson(json['email'])
          : null,
      sms: json['sms'] != null ? SmsChannel.fromJson(json['sms']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inApp': inApp.toJson(),
      if (push != null) 'push': push!.toJson(),
      if (email != null) 'email': email!.toJson(),
      if (sms != null) 'sms': sms!.toJson(),
    };
  }
}

class InAppChannel {
  final bool enabled;
  final bool read;
  final DateTime? readAt;

  InAppChannel({required this.enabled, required this.read, this.readAt});

  factory InAppChannel.fromJson(Map<String, dynamic> json) {
    return InAppChannel(
      enabled: json['enabled'] ?? true,
      read: json['read'] ?? false,
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'read': read,
      'readAt': readAt?.toIso8601String(),
    };
  }
}

class PushChannel {
  final bool enabled;
  final bool sent;
  final DateTime? sentAt;

  PushChannel({required this.enabled, required this.sent, this.sentAt});

  factory PushChannel.fromJson(Map<String, dynamic> json) {
    return PushChannel(
      enabled: json['enabled'] ?? false,
      sent: json['sent'] ?? false,
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'sent': sent,
      'sentAt': sentAt?.toIso8601String(),
    };
  }
}

class EmailChannel {
  final bool enabled;
  final bool sent;
  final DateTime? sentAt;

  EmailChannel({required this.enabled, required this.sent, this.sentAt});

  factory EmailChannel.fromJson(Map<String, dynamic> json) {
    return EmailChannel(
      enabled: json['enabled'] ?? false,
      sent: json['sent'] ?? false,
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'sent': sent,
      'sentAt': sentAt?.toIso8601String(),
    };
  }
}

class SmsChannel {
  final bool enabled;
  final bool sent;
  final DateTime? sentAt;

  SmsChannel({required this.enabled, required this.sent, this.sentAt});

  factory SmsChannel.fromJson(Map<String, dynamic> json) {
    return SmsChannel(
      enabled: json['enabled'] ?? false,
      sent: json['sent'] ?? false,
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'enabled': enabled,
      'sent': sent,
      'sentAt': sentAt?.toIso8601String(),
    };
  }
}

class NotificationData {
  final String? bookingId;
  final String? actionType;
  final String? actionUrl;
  final Map<String, dynamic>? actionData;
  final String? imageUrl;
  final String? iconType;
  final String? backgroundColor;
  final String? serviceName;
  final String? therapistName;
  final String? storeName;
  final DateTime? date;
  final String? time;
  final double? amount;

  NotificationData({
    this.bookingId,
    this.actionType,
    this.actionUrl,
    this.actionData,
    this.imageUrl,
    this.iconType,
    this.backgroundColor,
    this.serviceName,
    this.therapistName,
    this.storeName,
    this.date,
    this.time,
    this.amount,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      bookingId: json['bookingId'],
      actionType: json['actionType'],
      actionUrl: json['actionUrl'],
      actionData: json['actionData'],
      imageUrl: json['imageUrl'],
      iconType: json['iconType'],
      backgroundColor: json['backgroundColor'],
      serviceName: json['serviceName'],
      therapistName: json['therapistName'],
      storeName: json['storeName'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      time: json['time'],
      amount: json['amount']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (bookingId != null) 'bookingId': bookingId,
      if (actionType != null) 'actionType': actionType,
      if (actionUrl != null) 'actionUrl': actionUrl,
      if (actionData != null) 'actionData': actionData,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (iconType != null) 'iconType': iconType,
      if (backgroundColor != null) 'backgroundColor': backgroundColor,
      if (serviceName != null) 'serviceName': serviceName,
      if (therapistName != null) 'therapistName': therapistName,
      if (storeName != null) 'storeName': storeName,
      if (date != null) 'date': date!.toIso8601String(),
      if (time != null) 'time': time,
      if (amount != null) 'amount': amount,
    };
  }
}

class NotificationListResponse {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final Map<String, CategoryStats> categoryStats;
  final PaginationInfo pagination;

  NotificationListResponse({
    required this.notifications,
    required this.unreadCount,
    required this.categoryStats,
    required this.pagination,
  });

  factory NotificationListResponse.fromJson(Map<String, dynamic> json) {
    final categoryStatsJson = json['categoryStats'] as Map<String, dynamic>?;
    final categoryStatsMap = <String, CategoryStats>{};

    if (categoryStatsJson != null) {
      categoryStatsJson.forEach((key, value) {
        categoryStatsMap[key] = CategoryStats.fromJson(value);
      });
    }

    return NotificationListResponse(
      notifications:
          (json['notifications'] as List<dynamic>?)
              ?.map((e) => NotificationModel.fromJson(e))
              .toList() ??
          [],
      unreadCount: json['unreadCount'] ?? 0,
      categoryStats: categoryStatsMap,
      pagination: PaginationInfo.fromJson(json['pagination'] ?? {}),
    );
  }
}

class CategoryStats {
  final int total;
  final int unread;

  CategoryStats({required this.total, required this.unread});

  factory CategoryStats.fromJson(Map<String, dynamic> json) {
    return CategoryStats(
      total: json['total'] ?? 0,
      unread: json['unread'] ?? 0,
    );
  }
}

class PaginationInfo {
  final int current;
  final int total;
  final int limit;
  final int totalNotifications;

  PaginationInfo({
    required this.current,
    required this.total,
    required this.limit,
    required this.totalNotifications,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      current: json['current'] ?? 1,
      total: json['total'] ?? 1,
      limit: json['limit'] ?? 20,
      totalNotifications: json['totalNotifications'] ?? 0,
    );
  }

  bool get hasMore => current < total;
}

class NotificationPreferencesModel {
  final ChannelPreference push;
  final ChannelPreference email;
  final ChannelPreference sms;
  final MarketingPreference marketing;
  final RemindersPreference reminders;
  final QuietHoursPreference quietHours;

  NotificationPreferencesModel({
    required this.push,
    required this.email,
    required this.sms,
    required this.marketing,
    required this.reminders,
    required this.quietHours,
  });

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) {
    return NotificationPreferencesModel(
      push: ChannelPreference.fromJson(json['push'] ?? {}),
      email: ChannelPreference.fromJson(json['email'] ?? {}),
      sms: ChannelPreference.fromJson(json['sms'] ?? {}),
      marketing: MarketingPreference.fromJson(json['marketing'] ?? {}),
      reminders: RemindersPreference.fromJson(json['reminders'] ?? {}),
      quietHours: QuietHoursPreference.fromJson(json['quietHours'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'push': push.toJson(),
      'email': email.toJson(),
      'sms': sms.toJson(),
      'marketing': marketing.toJson(),
      'reminders': reminders.toJson(),
      'quietHours': quietHours.toJson(),
    };
  }
}

class ChannelPreference {
  final bool enabled;
  final List<String> types;

  ChannelPreference({required this.enabled, required this.types});

  factory ChannelPreference.fromJson(Map<String, dynamic> json) {
    return ChannelPreference(
      enabled: json['enabled'] ?? false,
      types:
          (json['types'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'enabled': enabled, 'types': types};
  }
}

class MarketingPreference {
  final bool enabled;

  MarketingPreference({required this.enabled});

  factory MarketingPreference.fromJson(Map<String, dynamic> json) {
    return MarketingPreference(enabled: json['enabled'] ?? false);
  }

  Map<String, dynamic> toJson() {
    return {'enabled': enabled};
  }
}

class RemindersPreference {
  final bool enabled;

  RemindersPreference({required this.enabled});

  factory RemindersPreference.fromJson(Map<String, dynamic> json) {
    return RemindersPreference(enabled: json['enabled'] ?? true);
  }

  Map<String, dynamic> toJson() {
    return {'enabled': enabled};
  }
}

class QuietHoursPreference {
  final bool enabled;
  final String start;
  final String end;

  QuietHoursPreference({
    required this.enabled,
    required this.start,
    required this.end,
  });

  factory QuietHoursPreference.fromJson(Map<String, dynamic> json) {
    return QuietHoursPreference(
      enabled: json['enabled'] ?? false,
      start: json['start'] ?? '22:00',
      end: json['end'] ?? '08:00',
    );
  }

  Map<String, dynamic> toJson() {
    return {'enabled': enabled, 'start': start, 'end': end};
  }
}
