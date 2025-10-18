import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/wallet_service.dart';

class WalletTopupController extends GetxController {
  final WalletService _walletService = WalletService();

  final _isLoading = false.obs;
  final _selectedAmount = Rx<double?>(null);
  final _customAmount = ''.obs;
  final _selectedPaymentMethod = 'fpx'.obs;
  final _selectedBank = Rx<String?>(null);

  bool get isLoading => _isLoading.value;
  double? get selectedAmount => _selectedAmount.value;
  String get customAmount => _customAmount.value;
  String get selectedPaymentMethod => _selectedPaymentMethod.value;
  String? get selectedBank => _selectedBank.value;

  // Predefined amounts
  final List<double> predefinedAmounts = [50, 100, 200, 500, 1000, 2000];

  // Available payment methods
  final List<Map<String, String>> paymentMethods = [
    {'id': 'fpx', 'name': 'FPX Online Banking'},
    {'id': 'tng_ewallet', 'name': 'Touch \'n Go eWallet'},
    {'id': 'grabpay', 'name': 'GrabPay'},
  ];

  // Malaysian banks for FPX
  final List<Map<String, String>> banks = [
    {'code': 'MBB', 'name': 'Maybank'},
    {'code': 'CIMB', 'name': 'CIMB Bank'},
    {'code': 'PBB', 'name': 'Public Bank'},
    {'code': 'RHB', 'name': 'RHB Bank'},
    {'code': 'HLB', 'name': 'Hong Leong Bank'},
    {'code': 'AMBANK', 'name': 'AmBank'},
    {'code': 'BSN', 'name': 'Bank Simpanan Nasional'},
    {'code': 'AFFIN', 'name': 'Affin Bank'},
  ];

  void selectAmount(double amount) {
    _selectedAmount.value = amount;
    _customAmount.value = '';
  }

  void setCustomAmount(String amount) {
    _customAmount.value = amount;
    _selectedAmount.value = null;
  }

  void selectPaymentMethod(String method) {
    _selectedPaymentMethod.value = method;
    if (method != 'fpx') {
      _selectedBank.value = null;
    }
  }

  void selectBank(String bankCode) {
    _selectedBank.value = bankCode;
  }

  double? _getTopUpAmount() {
    if (_selectedAmount.value != null) {
      return _selectedAmount.value;
    }
    if (_customAmount.value.isNotEmpty) {
      return double.tryParse(_customAmount.value);
    }
    return null;
  }

  Future<void> initiateTopUp() async {
    final amount = _getTopUpAmount();

    if (amount == null || amount <= 0) {
      Get.snackbar(
        'Invalid Amount',
        'Please enter a valid top-up amount',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    if (amount < 10) {
      Get.snackbar(
        'Minimum Amount',
        'Minimum top-up amount is RM 10',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (_selectedPaymentMethod.value == 'fpx' && _selectedBank.value == null) {
      Get.snackbar(
        'Select Bank',
        'Please select your bank for FPX payment',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    _isLoading.value = true;

    try {
      // Step 1: Initiate top-up
      final initiateResponse = await _walletService.initiateTopUp(
        amount: amount,
        paymentMethod: _selectedPaymentMethod.value,
        bankCode: _selectedBank.value,
      );

      if (initiateResponse.isSuccess && initiateResponse.data != null) {
        final topUpData = initiateResponse.data!;

        print('✅ Top-up initiated');
        print('   Payment ID: ${topUpData.paymentId}');
        print('   Transaction ID: ${topUpData.transactionId}');
        print('   Amount: RM ${topUpData.amount}');

        // Step 2: Immediately confirm the payment
        final confirmResponse = await _walletService.confirmTopUp(
          paymentId: topUpData.paymentId!,
          gatewayTransactionId: topUpData.transactionId!,
          amount: topUpData.amount!,
          status: 'success',
        );

        if (confirmResponse.isSuccess &&
            confirmResponse.data?.processed == true) {
          print('✅ Payment confirmed successfully');
          _showSuccessDialog(topUpData.amount!);
        } else {
          _showError('Payment confirmation failed');
        }
      } else {
        _showError(initiateResponse.error);
      }
    } catch (e) {
      print('❌ Error: $e');
      _showError('An error occurred: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void _showSuccessDialog(double amount) {
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
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF4CAF50).withOpacity(0.3),
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
              const Text(
                'Top-Up Successful!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'RM ${amount.toStringAsFixed(2)} has been added to your wallet.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close success dialog

                    // Navigate back to home and refresh
                    Get.back(result: {'success': true, 'amount': amount});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showError(dynamic error) {
    String message = 'An error occurred';

    if (error is Map<String, dynamic>) {
      message = error['message'] ?? error['error'] ?? message;
    } else if (error is String) {
      message = error;
    }

    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}
