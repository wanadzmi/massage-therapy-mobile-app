import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wallet_topup_controller.dart';

class WalletPaymentPendingView extends GetView<WalletTopUpController> {
  const WalletPaymentPendingView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>;
    final transactionId = args['transactionId'] as String;

    // Start polling when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startPolling(transactionId);
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // Show confirmation dialog before leaving
        await Get.dialog<bool>(
          AlertDialog(
            backgroundColor: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Leave this page?',
              style: TextStyle(
                color: Color(0xFFE0E0E0),
                fontWeight: FontWeight.w600,
              ),
            ),
            content: const Text(
              'Your payment is still being confirmed. You can check the status in your transaction history.',
              style: TextStyle(color: Color(0xFF808080)),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text(
                  'Stay',
                  style: TextStyle(color: Color(0xFFD4AF37)),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back(result: true);
                  Get.back(); // Actually pop the screen
                },
                child: const Text(
                  'Leave',
                  style: TextStyle(color: Color(0xFF808080)),
                ),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(
          title: const Text(
            'Payment Pending',
            style: TextStyle(
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
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Loading Animation
                _buildLoadingAnimation(),

                const SizedBox(height: 32),

                // Title
                const Text(
                  'Waiting for Confirmation',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE0E0E0),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Description
                const Text(
                  'We are waiting for your payment to be confirmed on the blockchain. This usually takes 5-10 minutes.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF808080),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // Status Steps
                _buildStatusSteps(),

                const SizedBox(height: 48),

                // Transaction ID
                _buildTransactionId(transactionId),

                const SizedBox(height: 24),

                // Info Box
                _buildInfoBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer circle
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
            border: Border.all(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        // Spinning indicator
        const SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
          ),
        ),
        // Center icon
        const Icon(Icons.access_time, size: 40, color: Color(0xFFD4AF37)),
      ],
    );
  }

  Widget _buildStatusSteps() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Column(
        children: [
          _buildStatusStep(
            icon: Icons.check_circle,
            title: 'Payment Sent',
            subtitle: 'Transaction initiated',
            isCompleted: true,
          ),
          _buildStatusDivider(),
          _buildStatusStep(
            icon: Icons.hourglass_empty,
            title: 'Blockchain Confirmation',
            subtitle: 'Waiting for network confirmation',
            isCompleted: false,
            isActive: true,
          ),
          _buildStatusDivider(),
          _buildStatusStep(
            icon: Icons.account_balance_wallet,
            title: 'Credit to Wallet',
            subtitle: 'Funds will be available',
            isCompleted: false,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusStep({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isCompleted,
    bool isActive = false,
  }) {
    final color = isCompleted
        ? Colors.green
        : isActive
        ? const Color(0xFFD4AF37)
        : const Color(0xFF404040);

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green.withValues(alpha: 0.1)
                : isActive
                ? const Color(0xFFD4AF37).withValues(alpha: 0.1)
                : const Color(0xFF1A1A1A),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isCompleted || isActive
                      ? const Color(0xFFE0E0E0)
                      : const Color(0xFF606060),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Color(0xFF808080)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Container(width: 2, height: 20, color: const Color(0xFF2A2A2A)),
        ],
      ),
    );
  }

  Widget _buildTransactionId(String transactionId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Transaction ID',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF808080),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  transactionId,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: Color(0xFFE0E0E0),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () =>
                    controller.copyToClipboard(transactionId, 'Transaction ID'),
                child: const Icon(
                  Icons.copy,
                  size: 16,
                  color: Color(0xFF808080),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[300], size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'You can safely close this page. We will notify you once the payment is confirmed.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFFE0E0E0),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
