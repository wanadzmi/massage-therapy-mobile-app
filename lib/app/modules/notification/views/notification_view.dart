import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/notification_controller.dart';
import '../widgets/notification_tile.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.notifications,
          style: const TextStyle(
            color: Color(0xFFE0E0E0),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          // Unread count badge
          Obx(() {
            if (controller.unreadCount > 0) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.unreadCount}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Mark all as read button
          Obx(() {
            if (controller.unreadCount > 0) {
              return IconButton(
                icon: const Icon(Icons.done_all, color: Color(0xFFD4AF37)),
                onPressed: controller.markAllAsRead,
                tooltip: AppLocalizations.of(context)!.markAllAsRead,
              );
            }
            return const SizedBox(width: 48);
          }),
        ],
      ),
      body: Column(
        children: [
          // Unread only toggle
          _buildUnreadToggle(context),

          // Notifications list
          Expanded(
            child: Obx(() {
              if (controller.isLoading && controller.notifications.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                );
              }

              if (controller.notifications.isEmpty) {
                return _buildEmptyState(context);
              }

              return RefreshIndicator(
                color: const Color(0xFFD4AF37),
                backgroundColor: const Color(0xFF1A1A1A),
                onRefresh: controller.refresh,
                child: ListView.builder(
                  itemCount:
                      controller.notifications.length +
                      (controller.hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == controller.notifications.length) {
                      // Load more indicator
                      if (controller.isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                        );
                      } else {
                        // Trigger load more
                        Future.microtask(() => controller.loadMore());
                        return const SizedBox(height: 60);
                      }
                    }

                    final notification = controller.notifications[index];
                    return NotificationTile(
                      notification: notification,
                      onTap: () =>
                          controller.handleNotificationClick(notification),
                      onDismiss: () => controller.deleteNotification(
                        notification.notificationId,
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildUnreadToggle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          border: Border(
            bottom: BorderSide(color: Color(0xFF2A2A2A), width: 1),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.filter_list, color: Color(0xFF808080), size: 18),
            const SizedBox(width: 8),
            Text(
              l10n.showUnreadOnly,
              style: const TextStyle(color: Color(0xFFE0E0E0), fontSize: 14),
            ),
            const Spacer(),
            Switch(
              value: controller.unreadOnly,
              onChanged: (_) => controller.toggleUnreadOnly(),
              activeColor: const Color(0xFFD4AF37),
              activeTrackColor: const Color(0xFFD4AF37).withValues(alpha: 0.3),
              inactiveThumbColor: const Color(0xFF404040),
              inactiveTrackColor: const Color(0xFF2A2A2A),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2A2A2A), width: 2),
            ),
            child: const Icon(
              Icons.notifications_none,
              size: 64,
              color: Color(0xFF404040),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noNotifications,
            style: const TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.allCaughtUp,
            style: const TextStyle(color: Color(0xFF808080), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
