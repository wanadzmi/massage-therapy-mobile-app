import 'package:flutter/material.dart';
import '../../../data/models/notification_model.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.notificationId),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      onDismissed: (_) => onDismiss(),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead
                ? const Color(0xFF0A0A0A)
                : const Color(0xFF1A1A1A),
            border: const Border(
              bottom: BorderSide(color: Color(0xFF2A2A2A), width: 1),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getIconColor().withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(_getIcon(), color: _getIconColor(), size: 24),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with unread indicator
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              color: const Color(0xFFE0E0E0),
                              fontSize: 15,
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notification.isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFD4AF37),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Body
                    Text(
                      notification.body,
                      style: const TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Time ago
                    Text(
                      _timeAgo(notification.createdAt),
                      style: const TextStyle(
                        color: Color(0xFF606060),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon() {
    switch (notification.data.iconType) {
      case 'calendar':
        return Icons.calendar_today;
      case 'wallet':
        return Icons.account_balance_wallet;
      case 'star':
        return Icons.star;
      case 'gift':
        return Icons.card_giftcard;
      case 'info':
        return Icons.info_outline;
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'check':
        return Icons.check_circle_outline;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor() {
    // Use backgroundColor from notification data if available
    if (notification.data.backgroundColor != null) {
      try {
        final hexColor = notification.data.backgroundColor!;
        if (hexColor.startsWith('#') && hexColor.length == 7) {
          return Color(
            int.parse(hexColor.substring(1), radix: 16) + 0xFF000000,
          );
        }
      } catch (e) {
        // Fall through to category-based color
      }
    }

    // Fallback to category-based colors
    switch (notification.category) {
      case 'transactional':
        return const Color(0xFF2196F3); // Blue
      case 'promotional':
        return const Color(0xFFFF9800); // Orange
      case 'reminder':
        return const Color(0xFF9C27B0); // Purple
      case 'social':
        return const Color(0xFF4CAF50); // Green
      case 'system':
        return const Color(0xFF607D8B); // Blue Grey
      default:
        return const Color(0xFFD4AF37); // Gold
    }
  }

  String _timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months${months == 1 ? ' month' : ' months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}${difference.inDays == 1 ? ' day' : ' days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}${difference.inHours == 1 ? ' hour' : ' hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}${difference.inMinutes == 1 ? ' minute' : ' minutes'} ago';
    } else {
      return 'Just now';
    }
  }
}
