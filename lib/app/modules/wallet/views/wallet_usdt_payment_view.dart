import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../data/models/wallet_topup_model.dart';
import '../controllers/wallet_topup_controller.dart';

class WalletUsdtPaymentView extends GetView<WalletTopUpController> {
  const WalletUsdtPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final args = Get.arguments as Map<String, dynamic>;
    final topUpData = args['topUpData'] as TopUpData;
    final amount = args['amount'] as double;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: Text(
          l10n.usdtPayment,
          style: const TextStyle(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w500,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFD4AF37)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Amount Card
            _buildAmountCard(amount, l10n),

            const SizedBox(height: 24),

            // Instructions
            _buildInstructions(l10n),

            const SizedBox(height: 24),

            // QR Code Placeholder
            _buildQRCode(topUpData.walletAddress ?? '', l10n),

            const SizedBox(height: 24),

            // Wallet Address
            _buildWalletAddress(topUpData.walletAddress ?? '', l10n),

            const SizedBox(height: 16),

            // Network Info
            _buildNetworkInfo(topUpData.network ?? 'TRC20', l10n),

            const SizedBox(height: 24),

            // Warning
            _buildWarning(l10n),

            const SizedBox(height: 32),

            // Confirm Button
            _buildConfirmButton(topUpData.transactionId ?? '', l10n),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard(double amount, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFD4AF37).withValues(alpha: 0.2),
            const Color(0xFFD4AF37).withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            l10n.amountToPay,
            style: const TextStyle(
              color: Color(0xFF808080),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'RM ${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.inUsdtEquivalent,
            style: const TextStyle(color: Color(0xFF808080), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.howToPay,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFE0E0E0),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 12),
        _buildInstructionStep(1, l10n.scanQrOrCopy),
        _buildInstructionStep(2, l10n.openUsdtWallet),
        _buildInstructionStep(3, l10n.sendExactAmount),
        _buildInstructionStep(4, l10n.waitForConfirmation),
      ],
    );
  }

  Widget _buildInstructionStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFD4AF37),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number.toString(),
                style: const TextStyle(
                  color: Color(0xFF0A0A0A),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF808080),
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRCode(String address, AppLocalizations l10n) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        ),
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.qr_code_2, size: 80, color: Color(0xFF404040)),
              const SizedBox(height: 8),
              Text(
                l10n.qrCode,
                style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
              ),
              Text(
                l10n.copyAddressBelow,
                style: const TextStyle(fontSize: 12, color: Color(0xFF606060)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletAddress(String address, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.walletAddress,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE0E0E0),
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  address,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'monospace',
                    color: Color(0xFFE0E0E0),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => controller.copyToClipboard(address, 'Address'),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.copy,
                    size: 18,
                    color: Color(0xFFD4AF37),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkInfo(String network, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.orange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.network,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.onlySendUsdtVia(network),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarning(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.important,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            l10n.usdtWarnings,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFE0E0E0),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(String transactionId, AppLocalizations l10n) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              // Navigate to payment pending screen
              Get.offNamed(
                '/wallet-payment-pending',
                arguments: {'transactionId': transactionId},
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: Text(
              l10n.iHaveSentPayment,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0A0A0A),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {
            Get.back(); // Go back to payment selection
          },
          child: Text(
            l10n.cancel,
            style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
          ),
        ),
      ],
    );
  }
}
