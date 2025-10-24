import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../data/services/tier_service.dart';
import '../../home/controllers/home_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class TierSubscriptionController extends GetxController {
  final TierService _tierService = TierService();

  final _isLoading = false.obs;
  final _tiers = <TierInfo>[].obs;
  final _currentTier = Rx<String?>(null);
  final _currentBalance = 0.0.obs;

  bool get isLoading => _isLoading.value;
  List<TierInfo> get tiers => _tiers;
  String? get currentTier => _currentTier.value;
  double get currentBalance => _currentBalance.value;

  @override
  void onInit() {
    super.onInit();
    loadTiers();
  }

  @override
  void onReady() {
    super.onReady();
    // Refresh data when returning from other screens
    ever(_isLoading, (_) {
      // React to loading state changes if needed
    });
  }

  /// Refresh tiers data (callable from other controllers)
  Future<void> refresh() async {
    await loadTiers();
  }

  /// Load all available tiers
  Future<void> loadTiers() async {
    try {
      _isLoading.value = true;
      final response = await _tierService.getAllTiers();

      if (response.isSuccess && response.data != null) {
        _tiers.value = response.data!.data?.tiers ?? [];
        _currentTier.value = response.data!.data?.currentTier;
        _currentBalance.value = response.data!.data?.currentBalance ?? 0.0;
      } else {
        final l10n = AppLocalizations.of(Get.context!)!;
        Get.snackbar(
          l10n.error,
          response.error ?? l10n.failedToLoadTiers,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
        );
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

  /// Subscribe to a tier
  Future<void> subscribeTier(TierInfo tier) async {
    if (!tier.hasSufficientBalance) {
      _showInsufficientBalanceDialog(tier);
      return;
    }

    if (!tier.canSubscribe) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.cannotSubscribe,
        tier.isCurrent ? l10n.alreadyMember(tier.name) : l10n.tierNotAvailable,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
      return;
    }

    // Show confirmation dialog
    final confirm = await Get.dialog<bool>(
      _buildSubscribeConfirmDialog(tier),
      barrierDismissible: false,
    );

    if (confirm != true) return;

    try {
      _isLoading.value = true;
      final response = await _tierService.subscribeTier(tier: tier.tier);

      if (response.isSuccess && response.data != null) {
        await _showSuccessDialog(response.data!);
        // Reload tiers to get updated info
        await loadTiers();
      } else {
        _handleSubscribeError(response.error);
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

  void _showInsufficientBalanceDialog(TierInfo tier) {
    final l10n = AppLocalizations.of(Get.context!)!;
    Get.dialog(
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
                  Icons.account_balance_wallet_outlined,
                  size: 48,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.insufficientBalance,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.needToSubscribe(
                  'RM ${tier.price.toStringAsFixed(2)}',
                  tier.name,
                ),
                style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.currentBalanceLabel(
                  'RM ${_currentBalance.value.toStringAsFixed(2)}',
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFD4AF37),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
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
                      onPressed: () async {
                        Get.back(); // Close insufficient balance dialog

                        // Navigate to wallet top-up and wait for result
                        final result = await Get.toNamed('/wallet-topup');

                        // If top-up was successful, refresh the tiers data
                        if (result != null && result['success'] == true) {
                          await loadTiers();
                          _refreshOtherControllers();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(l10n.topUp),
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

  Widget _buildSubscribeConfirmDialog(TierInfo tier) {
    final l10n = AppLocalizations.of(Get.context!)!;
    return Dialog(
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
                Icons.workspace_premium,
                size: 48,
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.subscribeTo(tier.name),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE0E0E0),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.subscriptionChargeMessage(
                'RM ${tier.price.toStringAsFixed(2)}',
              ),
              style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.newBalanceLabel(
                'RM ${(_currentBalance.value - tier.price).toStringAsFixed(2)}',
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFD4AF37),
              ),
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
                    child: Text(l10n.confirm),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showSuccessDialog(SubscribeResponse response) async {
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
                response.message ?? l10n.subscriptionSuccessful,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              if (response.data?.expiresAt != null)
                Text(
                  l10n.validUntil(_formatDate(response.data!.expiresAt!)),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF808080),
                  ),
                  textAlign: TextAlign.center,
                ),
              if (response.data?.transaction?.newBalance != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    l10n.newBalanceLabel(
                      'RM ${response.data!.transaction!.newBalance!.toStringAsFixed(2)}',
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
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Get.back(); // Close success dialog

                    // Refresh tiers data
                    await loadTiers();

                    // Refresh profile and home controllers
                    _refreshOtherControllers();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(l10n.great),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _handleSubscribeError(dynamic error) {
    final l10n = AppLocalizations.of(Get.context!)!;
    String message = l10n.failedToLoadTiers;
    if (error is Map) {
      message = error['message'] ?? error['error'] ?? message;
    } else if (error is String) {
      message = error;
    }

    Get.snackbar(
      l10n.subscriptionFailed,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  /// Refresh other controllers after balance/tier changes
  void _refreshOtherControllers() {
    // Refresh profile controller
    try {
      final profileController = Get.find<ProfileController>();
      profileController.refresh();
    } catch (e) {}

    // Refresh home controller
    try {
      final homeController = Get.find<HomeController>();
      homeController.refresh();
    } catch (e) {}
  }

  /// Navigate to current tier details
  void viewCurrentTier() {
    Get.toNamed('/tier-detail');
  }
}
