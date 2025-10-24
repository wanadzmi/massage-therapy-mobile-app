import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/services/tier_service.dart';
import '../../../../l10n/app_localizations.dart';

class TierDetailController extends GetxController {
  final TierService _tierService = TierService();

  final _isLoading = false.obs;
  final _currentTierData = Rx<CurrentTierData?>(null);
  final _transactions = <TierTransaction>[].obs;
  final _currentPage = 1.obs;
  final _totalPages = 1.obs;
  final _isLoadingMore = false.obs;

  bool get isLoading => _isLoading.value;
  CurrentTierData? get currentTierData => _currentTierData.value;
  List<TierTransaction> get transactions => _transactions;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get hasMorePages => _currentPage.value < _totalPages.value;

  @override
  void onInit() {
    super.onInit();
    loadCurrentTier();
    loadHistory();
  }

  /// Load current tier details
  Future<void> loadCurrentTier() async {
    try {
      _isLoading.value = true;
      final response = await _tierService.getCurrentTier();
      if (response.isSuccess && response.data?.data != null) {
        _currentTierData.value = response.data!.data;
      }
    } catch (e) {
      final l10n = AppLocalizations.of(Get.context!)!;
      _handleError(e, l10n.failedToLoadSubscription);
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load transaction history
  Future<void> loadHistory({bool loadMore = false}) async {
    try {
      if (loadMore) {
        _isLoadingMore.value = true;
      } else {
        _currentPage.value = 1;
        _transactions.clear();
      }

      // TODO: Implement getTierHistory in TierService
      // final response = await _tierService.getTierHistory(
      //   page: loadMore ? _currentPage.value + 1 : 1,
      // );

      // if (loadMore) {
      //   _transactions.addAll(response.data);
      //   _currentPage.value++;
      // } else {
      //   _transactions.assignAll(response.data);
      // }

      // _totalPages.value = response.pagination.totalPages;
    } catch (e) {
      final l10n = AppLocalizations.of(Get.context!)!;
      _handleError(e, l10n.failedToLoadHistory);
    } finally {
      if (loadMore) {
        _isLoadingMore.value = false;
      }
    }
  }

  /// Renew subscription
  Future<void> renewSubscription() async {
    final confirm = await _showRenewConfirmDialog();
    if (confirm != true) return;

    try {
      _isLoading.value = true;
      final response = await _tierService.renewSubscription();
      final l10n = AppLocalizations.of(Get.context!)!;

      if (response.isSuccess && response.data != null) {
        await _showSuccessDialog(
          l10n.renewalSuccessful,
          response.data!.message ?? l10n.subscriptionCancelledMessage,
        );
        await loadCurrentTier();
        await loadHistory();
      } else {
        _handleError(response.error, l10n.failedToRenewSubscription);
      }
    } catch (e) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.error,
        '${l10n.anErrorOccurred}: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Cancel subscription
  Future<void> cancelSubscription() async {
    final confirm = await _showCancelConfirmDialog();
    if (confirm != true) return;

    try {
      _isLoading.value = true;
      final response = await _tierService.cancelSubscription();
      final l10n = AppLocalizations.of(Get.context!)!;

      if (response.isSuccess && response.data != null) {
        await _showInfoDialog(
          l10n.subscriptionCancelled,
          response.data!.data?.note ?? l10n.subscriptionCancelledMessage,
        );
        await loadCurrentTier();
      } else {
        _handleError(response.error, l10n.failedToCancelSubscription);
      }
    } catch (e) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.error,
        '${l10n.anErrorOccurred}: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Toggle auto-renewal
  Future<void> toggleAutoRenew(bool value) async {
    try {
      final response = await _tierService.toggleAutoRenew(autoRenew: value);
      final l10n = AppLocalizations.of(Get.context!)!;

      if (response.isSuccess && response.data != null) {
        Get.snackbar(
          l10n.success,
          value ? l10n.autoRenewalEnabled : l10n.autoRenewalDisabled,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        await loadCurrentTier();
      } else {
        _handleError(response.error, l10n.failedToUpdateAutoRenewal);
        // Reload to revert UI state
        await loadCurrentTier();
      }
    } catch (e) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.error,
        '${l10n.anErrorOccurred}: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      await loadCurrentTier();
    }
  }

  Future<bool?> _showRenewConfirmDialog() {
    final tier = _currentTierData.value;
    if (tier == null) return Future.value(false);

    final l10n = AppLocalizations.of(Get.context!)!;

    return Get.dialog<bool>(
      Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.autorenew,
                  size: 48,
                  color: Color(0xFFD4AF37),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.renewSubscription,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.renewChargeMessage(
                  'RM ${tier.price.toStringAsFixed(2)}',
                  tier.name,
                ),
                style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
                textAlign: TextAlign.center,
              ),
              if (tier.currentBalance != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.newBalanceLabel(
                      'RM ${(tier.currentBalance! - tier.price).toStringAsFixed(2)}',
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFD4AF37),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE0E0E0),
                        side: const BorderSide(color: Color(0xFF2A2A2A)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(l10n.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(l10n.renew),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<bool?> _showCancelConfirmDialog() {
    final l10n = AppLocalizations.of(Get.context!)!;
    final tier = _currentTierData.value;

    return Get.dialog<bool>(
      Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.cancel_outlined,
                  size: 48,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.cancelSubscriptionConfirm,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                tier?.subscription?.expiresAt != null
                    ? l10n.cancelSubscriptionWarning(
                        formatDate(tier!.subscription!.expiresAt),
                      )
                    : l10n.subscriptionCancelledMessage,
                style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFE0E0E0),
                        side: const BorderSide(color: Color(0xFF2A2A2A)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(l10n.keepIt),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(l10n.cancelIt),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _showSuccessDialog(String title, String message) async {
    await Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 48,
                  color: Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _showInfoDialog(String title, String message) async {
    final l10n = AppLocalizations.of(Get.context!)!;

    await Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.info_outline,
                  size: 48,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(l10n.ok),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _handleError(dynamic error, String defaultMessage) {
    String message = defaultMessage;
    if (error is Map) {
      message = error['message'] ?? error['error'] ?? message;
    } else if (error is String) {
      message = error;
    }

    final l10n = AppLocalizations.of(Get.context!)!;
    Get.snackbar(
      l10n.error,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  String formatDateTime(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy HH:mm').format(date);
    } catch (e) {
      return dateStr;
    }
  }
}
