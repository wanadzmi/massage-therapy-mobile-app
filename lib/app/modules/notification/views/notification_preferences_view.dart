import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_preferences_controller.dart';

class NotificationPreferencesView
    extends GetView<NotificationPreferencesController> {
  const NotificationPreferencesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE0E0E0)),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Notification Preferences',
          style: TextStyle(
            color: Color(0xFFE0E0E0),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Obx(() {
            if (controller.isSaving) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFD4AF37),
                      ),
                    ),
                  ),
                ),
              );
            }

            return TextButton(
              onPressed: controller.savePreferences,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: Color(0xFFD4AF37),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
            ),
          );
        }

        if (controller.preferences == null) {
          return const Center(
            child: Text(
              'Failed to load preferences',
              style: TextStyle(color: Color(0xFFE0E0E0)),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('Notification Channels'),
            const SizedBox(height: 12),
            _buildChannelToggle(
              title: 'Push Notifications',
              subtitle: 'Receive notifications on this device',
              icon: Icons.notifications_active,
              isEnabled: controller.preferences!.push.enabled,
              onChanged: (_) => controller.togglePushEnabled(),
            ),
            const SizedBox(height: 12),
            _buildChannelToggle(
              title: 'Email Notifications',
              subtitle: 'Receive notifications via email',
              icon: Icons.email,
              isEnabled: controller.preferences!.email.enabled,
              onChanged: (_) => controller.toggleEmailEnabled(),
            ),
            const SizedBox(height: 12),
            _buildChannelToggle(
              title: 'SMS Notifications',
              subtitle: 'Receive notifications via SMS',
              icon: Icons.sms,
              isEnabled: controller.preferences!.sms.enabled,
              onChanged: (_) => controller.toggleSmsEnabled(),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Notification Types'),
            const SizedBox(height: 12),
            _buildChannelToggle(
              title: 'Marketing & Promotions',
              subtitle: 'Special offers, discounts, and promotions',
              icon: Icons.local_offer,
              isEnabled: controller.preferences!.marketing.enabled,
              onChanged: (_) => controller.toggleMarketingEnabled(),
            ),
            const SizedBox(height: 12),
            _buildChannelToggle(
              title: 'Reminders',
              subtitle: 'Booking reminders and appointments',
              icon: Icons.alarm,
              isEnabled: controller.preferences!.reminders.enabled,
              onChanged: (_) => controller.toggleRemindersEnabled(),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Quiet Hours'),
            const SizedBox(height: 12),
            _buildChannelToggle(
              title: 'Enable Quiet Hours',
              subtitle: 'Mute notifications during specific hours',
              icon: Icons.do_not_disturb,
              isEnabled: controller.preferences!.quietHours.enabled,
              onChanged: (_) => controller.toggleQuietHoursEnabled(),
            ),
            if (controller.preferences!.quietHours.enabled) ...[
              const SizedBox(height: 16),
              _buildQuietHoursInfo(),
            ],
            const SizedBox(height: 32),
            _buildInfoCard(),
          ],
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFFD4AF37),
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildChannelToggle({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isEnabled
                ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
                : const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: isEnabled
                ? const Color(0xFFD4AF37)
                : const Color(0xFF707070),
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFFE0E0E0),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Color(0xFF9A9A9A), fontSize: 13),
        ),
        trailing: Switch(
          value: isEnabled,
          onChanged: onChanged,
          activeColor: const Color(0xFFD4AF37),
          activeTrackColor: const Color(0xFFD4AF37).withValues(alpha: 0.3),
          inactiveThumbColor: const Color(0xFF707070),
          inactiveTrackColor: const Color(0xFF2A2A2A),
        ),
      ),
    );
  }

  Widget _buildQuietHoursInfo() {
    final start = controller.preferences!.quietHours.start;
    final end = controller.preferences!.quietHours.end;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.access_time, color: Color(0xFFD4AF37), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Active from $start to $end',
              style: const TextStyle(color: Color(0xFFE0E0E0), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: const Color(0xFFD4AF37).withValues(alpha: 0.8),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'About Notifications',
                  style: TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'You will always receive important transactional notifications related to your bookings and payments, regardless of these settings.',
                  style: TextStyle(
                    color: Color(0xFF9A9A9A),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
