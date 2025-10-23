import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/wallet_topup_controller.dart';

class WalletTopUpView extends GetView<WalletTopUpController> {
  const WalletTopUpView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Load payment methods when the view is built
    controller.loadPaymentMethods(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: Text(
          l10n.topUpWallet,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Balance Card
            _buildBalanceCard(),

            const SizedBox(height: 24),

            // Amount Input Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    final isUsdt = controller.isUsdtPayment;
                    final l10n = AppLocalizations.of(context)!;
                    return Text(
                      isUsdt ? l10n.enterAmountUsd : l10n.enterAmount,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE0E0E0),
                        letterSpacing: 0.3,
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  _buildAmountInput(),
                  const SizedBox(height: 8),
                  Obx(() {
                    final isUsdt = controller.isUsdtPayment;
                    final l10n = AppLocalizations.of(context)!;
                    if (isUsdt) {
                      // Show MYR equivalent for USDT
                      if (controller.isLoadingRate) {
                        return Row(
                          children: [
                            const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF808080),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.loadingExchangeRate,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF808080),
                              ),
                            ),
                          ],
                        );
                      } else if (controller.myrEquivalent > 0) {
                        return Text(
                          '≈ RM ${controller.myrEquivalent.toStringAsFixed(2)} | ${l10n.exchangeRate}: 1 USD = RM ${controller.usdToMyrRate.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      } else if (controller.usdToMyrRate > 0) {
                        return Text(
                          '${l10n.exchangeRate}: 1 USD = RM ${controller.usdToMyrRate.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF808080),
                          ),
                        );
                      }
                    }
                    // Show MYR limits for bank payments
                    return Text(
                      l10n.minimumMaximum,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF808080),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Quick Amount Buttons
            _buildQuickAmounts(),

            const SizedBox(height: 24),

            // Payment Method Selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.selectPaymentMethod,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE0E0E0),
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildPaymentMethods(),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Continue Button
            _buildContinueButton(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.currentBalance,
                style: const TextStyle(
                  color: Color(0xFF808080),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Text(
                  'RM ${controller.currentBalance.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAmountInput() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() {
            final isUsdt = controller.isUsdtPayment;
            return Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                isUsdt ? 'USD' : 'RM',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF808080),
                  height: 1.0,
                ),
              ),
            );
          }),
          Expanded(
            child: TextField(
              controller: controller.amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE0E0E0),
                height: 1.0,
              ),
              decoration: const InputDecoration(
                hintText: '0.00',
                hintStyle: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF404040),
                  height: 1.0,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                isDense: true,
              ),
              onChanged: controller.updateAmount,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAmounts() {
    final quickAmounts = [50.0, 100.0, 200.0, 500.0];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: quickAmounts.map((amount) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: OutlinedButton(
              onPressed: () {
                controller.amountController.text = amount.toStringAsFixed(0);
                controller.updateAmount(amount.toStringAsFixed(0));
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFD4AF37), width: 1.5),
                backgroundColor: const Color(0xFF1A1A1A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: Text(
                'RM ${amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD4AF37),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Builder(
      builder: (context) {
        return Obx(() {
          final methods = controller.paymentMethods;

          return Column(
            children: methods.map((method) {
              final isSelected =
                  controller.selectedPaymentMethod?.id == method.id;

              return GestureDetector(
                onTap: () => controller.selectPaymentMethod(method, context),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFD4AF37).withValues(alpha: 0.1)
                        : const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFD4AF37)
                          : (method.enabled
                                ? const Color(0xFF2A2A2A)
                                : const Color(0xFF1A1A1A)),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Selection Radio
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFD4AF37)
                                : const Color(0xFF404040),
                            width: 2,
                          ),
                          color: isSelected
                              ? const Color(0xFFD4AF37)
                              : const Color(0xFF1A1A1A),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Color(0xFF0A0A0A),
                              )
                            : null,
                      ),

                      const SizedBox(width: 16),

                      // Payment Method Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  method.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: method.enabled
                                        ? const Color(0xFFE0E0E0)
                                        : const Color(0xFF404040),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (method.badge != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getBadgeColor(
                                        method.badgeColor,
                                      ).withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      method.badge!,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: _getBadgeColor(
                                          method.badgeColor,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              method.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: method.enabled
                                    ? const Color(0xFF808080)
                                    : const Color(0xFF404040),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        });
      },
    );
  }

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return Obx(() {
            final isProcessing = controller.isProcessing;
            // For USDT payments, validate against MYR equivalent
            final amountToValidate = controller.isUsdtPayment
                ? controller.myrEquivalent
                : controller.amount;
            final canProceed =
                amountToValidate >= 10 &&
                amountToValidate <= 5000 &&
                controller.selectedPaymentMethod != null;

            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (isProcessing || !canProceed)
                    ? null
                    : () => controller.initiateTopUp(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  disabledBackgroundColor: const Color(0xFF2A2A2A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF0A0A0A),
                          ),
                        ),
                      )
                    : Text(
                        l10n.continueButton,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0A0A0A),
                          letterSpacing: 0.5,
                        ),
                      ),
              ),
            );
          });
        },
      ),
    );
  }

  Color _getBadgeColor(String? colorHex) {
    if (colorHex == null) return const Color(0xFF808080);
    try {
      return Color(int.parse('0xFF$colorHex'));
    } catch (e) {
      return const Color(0xFF808080);
    }
  }
}
