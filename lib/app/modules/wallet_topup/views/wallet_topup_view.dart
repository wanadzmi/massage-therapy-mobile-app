import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/wallet_topup_controller.dart';

class WalletTopupView extends GetView<WalletTopupController> {
  const WalletTopupView({super.key});

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
          'Top Up Wallet',
          style: TextStyle(
            color: Color(0xFFE0E0E0),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAmountSection(),
                  const SizedBox(height: 32),
                  _buildPaymentMethodSection(),
                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
            _buildBottomButton(),
            if (controller.isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Amount',
          style: TextStyle(
            color: Color(0xFFE0E0E0),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: controller.predefinedAmounts
              .map((amount) => _buildAmountChip(amount))
              .toList(),
        ),
        const SizedBox(height: 20),
        const Text(
          'Or Enter Custom Amount',
          style: TextStyle(
            color: Color(0xFF808080),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        _buildCustomAmountField(),
      ],
    );
  }

  Widget _buildAmountChip(double amount) {
    return Obx(() {
      final isSelected = controller.selectedAmount == amount;
      return GestureDetector(
        onTap: () => controller.selectAmount(amount),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFF2A2A2A),
              width: 1.5,
            ),
          ),
          child: Text(
            'RM ${amount.toStringAsFixed(0)}',
            style: TextStyle(
              color: isSelected ? Colors.black : const Color(0xFFE0E0E0),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCustomAmountField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(color: Color(0xFFE0E0E0), fontSize: 16),
        decoration: const InputDecoration(
          hintText: 'Enter amount (Min. RM 10)',
          hintStyle: TextStyle(color: Color(0xFF666666)),
          prefixIcon: Icon(Icons.attach_money, color: Color(0xFF808080)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onChanged: (value) => controller.setCustomAmount(value),
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            color: Color(0xFFE0E0E0),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...controller.paymentMethods.map(
          (method) => _buildPaymentMethodCard(method['id']!, method['name']!),
        ),
        Obx(() {
          if (controller.selectedPaymentMethod == 'fpx') {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'Select Your Bank',
                  style: TextStyle(
                    color: Color(0xFF808080),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ...controller.banks.map(
                  (bank) => _buildBankCard(bank['code']!, bank['name']!),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildPaymentMethodCard(String id, String name) {
    return Obx(() {
      final isSelected = controller.selectedPaymentMethod == id;
      return GestureDetector(
        onTap: () => controller.selectPaymentMethod(id),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFF2A2A2A),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getPaymentIcon(id),
                  color: const Color(0xFFD4AF37),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFFD4AF37),
                  size: 20,
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBankCard(String code, String name) {
    return Obx(() {
      final isSelected = controller.selectedBank == code;
      return GestureDetector(
        onTap: () => controller.selectBank(code),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F0F0F),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFF1A1A1A),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFFD4AF37),
                  size: 18,
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildBottomButton() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          border: Border(top: BorderSide(color: Color(0xFF2A2A2A), width: 1)),
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: controller.isLoading
                ? null
                : () => controller.initiateTopUp(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.black,
              disabledBackgroundColor: const Color(0xFF2A2A2A),
              disabledForegroundColor: const Color(0xFF666666),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
            ),
            child: const Text(
              'Proceed to Payment',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getPaymentIcon(String methodId) {
    switch (methodId) {
      case 'fpx':
        return Icons.account_balance;
      case 'tng_ewallet':
        return Icons.account_balance_wallet;
      case 'grabpay':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }
}
