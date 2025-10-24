import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/services/notification_service.dart';

class NotificationPreferencesController extends GetxController {
  final NotificationService _notificationService = NotificationService();

  final _isLoading = false.obs;
  final _isSaving = false.obs;
  final _preferences = Rxn<NotificationPreferencesModel>();

  bool get isLoading => _isLoading.value;
  bool get isSaving => _isSaving.value;
  NotificationPreferencesModel? get preferences => _preferences.value;

  @override
  void onInit() {
    super.onInit();
    loadPreferences();
  }

  Future<void> loadPreferences() async {
    _isLoading.value = true;

    try {
      final response = await _notificationService.getPreferences();

      if (response.isSuccess && response.data != null) {
        _preferences.value = response.data;
      } else {
        _showError('Failed to load preferences');
      }
    } catch (e) {
      _showError('An error occurred');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> savePreferences() async {
    if (_preferences.value == null) return;

    _isSaving.value = true;

    try {
      final response = await _notificationService.updatePreferences(
        _preferences.value!,
      );

      if (response.isSuccess && response.data != null) {
        _preferences.value = response.data;

        Get.snackbar(
          'Success',
          'Preferences saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFD4AF37),
          colorText: Colors.black,
          duration: const Duration(seconds: 2),
        );
      } else {
        _showError('Failed to save preferences');
      }
    } catch (e) {
      _showError('An error occurred');
    } finally {
      _isSaving.value = false;
    }
  }

  void togglePushEnabled() {
    if (_preferences.value == null) return;

    final current = _preferences.value!;
    _preferences.value = NotificationPreferencesModel(
      push: ChannelPreference(
        enabled: !current.push.enabled,
        types: current.push.types,
      ),
      email: current.email,
      sms: current.sms,
      marketing: current.marketing,
      reminders: current.reminders,
      quietHours: current.quietHours,
    );
  }

  void toggleEmailEnabled() {
    if (_preferences.value == null) return;

    final current = _preferences.value!;
    _preferences.value = NotificationPreferencesModel(
      push: current.push,
      email: ChannelPreference(
        enabled: !current.email.enabled,
        types: current.email.types,
      ),
      sms: current.sms,
      marketing: current.marketing,
      reminders: current.reminders,
      quietHours: current.quietHours,
    );
  }

  void toggleSmsEnabled() {
    if (_preferences.value == null) return;

    final current = _preferences.value!;
    _preferences.value = NotificationPreferencesModel(
      push: current.push,
      email: current.email,
      sms: ChannelPreference(
        enabled: !current.sms.enabled,
        types: current.sms.types,
      ),
      marketing: current.marketing,
      reminders: current.reminders,
      quietHours: current.quietHours,
    );
  }

  void toggleMarketingEnabled() {
    if (_preferences.value == null) return;

    final current = _preferences.value!;
    _preferences.value = NotificationPreferencesModel(
      push: current.push,
      email: current.email,
      sms: current.sms,
      marketing: MarketingPreference(enabled: !current.marketing.enabled),
      reminders: current.reminders,
      quietHours: current.quietHours,
    );
  }

  void toggleRemindersEnabled() {
    if (_preferences.value == null) return;

    final current = _preferences.value!;
    _preferences.value = NotificationPreferencesModel(
      push: current.push,
      email: current.email,
      sms: current.sms,
      marketing: current.marketing,
      reminders: RemindersPreference(enabled: !current.reminders.enabled),
      quietHours: current.quietHours,
    );
  }

  void toggleQuietHoursEnabled() {
    if (_preferences.value == null) return;

    final current = _preferences.value!;
    _preferences.value = NotificationPreferencesModel(
      push: current.push,
      email: current.email,
      sms: current.sms,
      marketing: current.marketing,
      reminders: current.reminders,
      quietHours: QuietHoursPreference(
        enabled: !current.quietHours.enabled,
        start: current.quietHours.start,
        end: current.quietHours.end,
      ),
    );
  }

  void _showError(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
}
