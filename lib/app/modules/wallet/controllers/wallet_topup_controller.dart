import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/wallet_topup_model.dart';
import '../../../data/services/wallet_service.dart';

class WalletTopUpController extends GetxController {
  final WalletService _walletService = WalletService();

  // Observable states
  final _isProcessing = false.obs;
  final _selectedPaymentMethod = Rx<PaymentMethod?>(null);
  final _amount = 0.0.obs;
  final _topUpData = Rx<TopUpData?>(null);
  final _currentBalance = 0.0.obs;
  final _pollingTimer = Rx<Timer?>(null);

  // Text editing controller
  final amountController = TextEditingController();

  // Getters
  bool get isProcessing => _isProcessing.value;
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod.value;
  double get amount => _amount.value;
  TopUpData? get topUpData => _topUpData.value;
  double get currentBalance => _currentBalance.value;

  // Available payment methods
  List<PaymentMethod> get paymentMethods =>
      _walletService.getAvailablePaymentMethods();

  @override
  void onInit() {
    super.onInit();
    loadWalletBalance();
  }

  @override
  void onClose() {
    amountController.dispose();
    _stopPolling();
    super.onClose();
  }

  /// Load current wallet balance
  Future<void> loadWalletBalance() async {
    try {
      final response = await _walletService.getWalletDetails();

      if (response.isSuccess && response.data != null) {
        final balance = response.data!['balance'];
        _currentBalance.value = (balance is int) ? balance.toDouble() : balance;
      }
    } catch (e) {
      debugPrint('Error loading wallet balance: $e');
    }
  }

  /// Select payment method
  void selectPaymentMethod(PaymentMethod method) {
    if (!method.enabled) {
      Get.snackbar(
        'Coming Soon',
        '${method.name} will be available soon',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    _selectedPaymentMethod.value = method;
  }

  /// Update amount from text field
  void updateAmount(String value) {
    final parsedAmount = double.tryParse(value) ?? 0.0;
    _amount.value = parsedAmount;
  }

  /// Validate and initiate top-up
  Future<void> initiateTopUp() async {
    // Validate amount
    final validation = _walletService.validateAmount(_amount.value);
    if (validation != null) {
      Get.snackbar(
        'Invalid Amount',
        validation,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    // Validate payment method
    if (_selectedPaymentMethod.value == null) {
      Get.snackbar(
        'Payment Method Required',
        'Please select a payment method',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    _isProcessing.value = true;

    try {
      final response = await _walletService.initiateTopUp(
        amount: _amount.value,
        paymentMethod: _selectedPaymentMethod.value!.id,
      );

      if (response.isSuccess && response.data != null) {
        _topUpData.value = response.data;

        // Handle based on payment method
        if (_selectedPaymentMethod.value!.id == 'test_payment') {
          _handleTestPayment(response.data!);
        } else if (_selectedPaymentMethod.value!.id == 'usdt_trc20') {
          _handleUsdtPayment(response.data!);
        }
      } else {
        Get.snackbar(
          'Top-Up Failed',
          response.error ?? 'Failed to initiate top-up',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      _isProcessing.value = false;
    }
  }

  /// Handle test payment (instant credit)
  void _handleTestPayment(TopUpData data) {
    if (data.instantCredit == true) {
      // Update balance
      if (data.newBalance != null) {
        _currentBalance.value = data.newBalance!;
      }

      // Show success dialog
      Get.dialog(
        WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Top-Up Successful!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'RM ${_amount.value.toStringAsFixed(2)} has been credited to your wallet',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'New Balance: RM ${data.newBalance?.toStringAsFixed(2) ?? '0.00'}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // Close dialog
                        Get.back(); // Close top-up screen
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );

      // Reset form
      _resetForm();
    }
  }

  /// Handle USDT payment (crypto)
  void _handleUsdtPayment(TopUpData data) {
    // Navigate to USDT payment screen
    Get.toNamed(
      '/wallet-usdt-payment',
      arguments: {'topUpData': data, 'amount': _amount.value},
    )?.then((result) {
      if (result == true) {
        // Payment confirmed, close top-up screen
        Get.back(); // Return to profile
      }
    });

    // Reset form
    _resetForm();
  }

  /// Start polling transaction status
  void startPolling(String transactionId) {
    _stopPolling(); // Stop any existing polling

    int pollCount = 0;
    const maxPolls = 60; // Poll for up to 5 minutes (60 * 5 seconds)

    _pollingTimer.value = Timer.periodic(const Duration(seconds: 5), (
      timer,
    ) async {
      pollCount++;

      try {
        final response = await _walletService.getTransactionStatus(
          transactionId,
        );

        if (response.isSuccess && response.data != null) {
          final transaction = response.data!;

          if (transaction.status == 'completed') {
            _stopPolling();
            _handlePaymentSuccess(transaction);
          } else if (transaction.status == 'failed') {
            _stopPolling();
            _handlePaymentFailed(transaction);
          }
        }

        // Stop polling after max attempts
        if (pollCount >= maxPolls) {
          _stopPolling();
          _handlePollingTimeout();
        }
      } catch (e) {
        debugPrint('Polling error: $e');
      }
    });
  }

  /// Stop polling
  void _stopPolling() {
    _pollingTimer.value?.cancel();
    _pollingTimer.value = null;
  }

  /// Handle payment success
  void _handlePaymentSuccess(WalletTransaction transaction) {
    Get.back(); // Close pending screen

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Payment Confirmed!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'RM ${transaction.amount?.toStringAsFixed(2) ?? '0.00'} has been credited to your wallet',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close dialog
                      // Navigate back through screens with success result
                      Get.until((route) => route.isFirst);
                      // Trigger profile refresh
                      loadWalletBalance();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Refresh balance
    loadWalletBalance();
  }

  /// Handle payment failed
  void _handlePaymentFailed(WalletTransaction transaction) {
    Get.back(); // Close pending screen

    Get.snackbar(
      'Payment Failed',
      'Your payment could not be processed. Please try again.',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
    );
  }

  /// Handle polling timeout
  void _handlePollingTimeout() {
    Get.back(); // Close pending screen

    Get.snackbar(
      'Payment Pending',
      'Payment confirmation is taking longer than expected. Please check your transaction history.',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 5),
    );
  }

  /// Copy to clipboard
  void copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    Get.snackbar(
      'Copied',
      '$label copied to clipboard',
      backgroundColor: AppColors.primary,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  /// Reset form
  void _resetForm() {
    amountController.clear();
    _amount.value = 0.0;
    _selectedPaymentMethod.value = null;
    _topUpData.value = null;
  }
}
