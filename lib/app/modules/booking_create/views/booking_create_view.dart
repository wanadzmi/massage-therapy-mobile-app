import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/booking_create_controller.dart';
import '../../../../l10n/app_localizations.dart';

class BookingCreateView extends GetView<BookingCreateController> {
  const BookingCreateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A0A0A),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFE0E0E0)),
            onPressed: () => Get.back(),
          ),
          title: Text(
            l10n.confirmBooking,
            style: TextStyle(
              color: Color(0xFFE0E0E0),
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
        body: Obx(
          () => controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Booking Summary
                      _buildSummaryCard(),
                      const SizedBox(height: 20),

                      // Preferences
                      _buildPreferencesSection(),
                      const SizedBox(height: 20),

                      // Notes
                      _buildNotesSection(),
                      const SizedBox(height: 20),

                      // Voucher Code
                      _buildVoucherSection(),
                      const SizedBox(height: 20),

                      // Payment Method
                      _buildPaymentMethodSection(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.bookingSummary,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 16),
              if (controller.service != null) ...[
                _buildSummaryRow(
                  l10n.service,
                  controller.service!.name ?? 'N/A',
                  Icons.spa,
                ),
                const SizedBox(height: 12),
              ],
              if (controller.selectedDate != null) ...[
                _buildSummaryRow(
                  l10n.date,
                  controller.selectedDate!,
                  Icons.calendar_today,
                ),
                const SizedBox(height: 12),
              ],
              if (controller.selectedTime != null) ...[
                _buildSummaryRow(
                  l10n.time,
                  controller.selectedTime!,
                  Icons.access_time,
                ),
                const SizedBox(height: 12),
              ],
              if (controller.therapistName != null) ...[
                _buildSummaryRow(
                  l10n.therapist,
                  controller.therapistName!,
                  Icons.person,
                ),
                const SizedBox(height: 12),
              ],
              if (controller.store != null) ...[
                _buildSummaryRow(
                  l10n.location,
                  controller.store!.name ?? 'N/A',
                  Icons.location_on,
                ),
                const SizedBox(height: 12),
              ],
              if (controller.service?.pricing?.finalPrice != null) ...[
                _buildSummaryRow(
                  l10n.price,
                  'RM ${controller.service!.pricing!.finalPrice.toStringAsFixed(2)}',
                  Icons.attach_money,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF808080)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF808080)),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFE0E0E0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.preferences,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.pressureLevel,
                style: TextStyle(fontSize: 13, color: Color(0xFF808080)),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Row(
                  children: [
                    _buildPressureButton(l10n.light, 'light'),
                    const SizedBox(width: 8),
                    _buildPressureButton(l10n.medium, 'medium'),
                    const SizedBox(width: 8),
                    _buildPressureButton(l10n.firm, 'firm'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.focusAreas,
                style: TextStyle(fontSize: 13, color: Color(0xFF808080)),
              ),
              const SizedBox(height: 8),
              Obx(() {
                // Access the observable to trigger rebuild
                final selectedAreas = controller.focusAreas;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.availableFocusAreas
                      .map(
                        (area) => _buildFocusAreaChip(
                          area,
                          selectedAreas.contains(area),
                        ),
                      )
                      .toList(),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPressureButton(String label, String value) {
    final isSelected = controller.pressure == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.setPressure(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFF2A2A2A),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.black : const Color(0xFF808080),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFocusAreaChip(String area, bool isSelected) {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        // Map area to localized text
        String localizedArea;
        switch (area.toLowerCase()) {
          case 'neck':
            localizedArea = l10n.neck;
            break;
          case 'shoulders':
            localizedArea = l10n.shoulders;
            break;
          case 'back':
            localizedArea = l10n.back;
            break;
          case 'lower back':
            localizedArea = l10n.lowerBack;
            break;
          case 'arms':
            localizedArea = l10n.arms;
            break;
          case 'legs':
            localizedArea = l10n.legs;
            break;
          case 'feet':
            localizedArea = l10n.feet;
            break;
          default:
            localizedArea = area;
        }
        return GestureDetector(
          onTap: () => controller.toggleFocusArea(area),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFF0A0A0A),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFD4AF37)
                    : const Color(0xFF2A2A2A),
              ),
            ),
            child: Text(
              localizedArea,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.black : const Color(0xFF808080),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotesSection() {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.specialInstructions,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.notesController,
                onChanged: controller.setNotes,
                maxLines: 3,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  // Dismiss keyboard when user presses "Done"
                  FocusScope.of(context).unfocus();
                },
                style: const TextStyle(color: Color(0xFFE0E0E0)),
                decoration: InputDecoration(
                  hintText: l10n.specialInstructionsHint,
                  hintStyle: TextStyle(color: Color(0xFF505050), fontSize: 13),
                  filled: true,
                  fillColor: Color(0xFF0A0A0A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Color(0xFFD4AF37)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentMethodSection() {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.paymentMethod,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 16),

              // Wallet Payment
              Obx(() {
                final isWalletSelected = controller.paymentMethod == 'wallet';
                final servicePrice = controller.service?.pricing?.price ?? 0.0;
                final hasInsufficientBalance =
                    controller.walletBalance < servicePrice;

                return GestureDetector(
                  onTap: () {
                    if (!hasInsufficientBalance) {
                      controller.setPaymentMethod('wallet');
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isWalletSelected
                          ? const Color(0xFFD4AF37).withValues(alpha: 0.1)
                          : const Color(0xFF0A0A0A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isWalletSelected
                            ? const Color(0xFFD4AF37)
                            : const Color(0xFF2A2A2A),
                        width: isWalletSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isWalletSelected
                                  ? const Color(0xFFD4AF37)
                                  : const Color(0xFF404040),
                              width: 2,
                            ),
                            color: isWalletSelected
                                ? const Color(0xFFD4AF37)
                                : const Color(0xFF1A1A1A),
                          ),
                          child: isWalletSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Color(0xFF0A0A0A),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.account_balance_wallet,
                                    size: 18,
                                    color: Color(0xFFD4AF37),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.wallet,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFE0E0E0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${l10n.balance}: RM ${controller.walletBalance.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: hasInsufficientBalance
                                      ? Colors.red
                                      : const Color(0xFF808080),
                                ),
                              ),
                              if (hasInsufficientBalance)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    l10n.insufficientBalanceTopUp,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red.shade300,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // Cash Payment
              Obx(() {
                final isCashSelected = controller.paymentMethod == 'cash';

                return GestureDetector(
                  onTap: () => controller.setPaymentMethod('cash'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isCashSelected
                          ? const Color(0xFFD4AF37).withValues(alpha: 0.1)
                          : const Color(0xFF0A0A0A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isCashSelected
                            ? const Color(0xFFD4AF37)
                            : const Color(0xFF2A2A2A),
                        width: isCashSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isCashSelected
                                  ? const Color(0xFFD4AF37)
                                  : const Color(0xFF404040),
                              width: 2,
                            ),
                            color: isCashSelected
                                ? const Color(0xFFD4AF37)
                                : const Color(0xFF1A1A1A),
                          ),
                          child: isCashSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Color(0xFF0A0A0A),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.money,
                                    size: 18,
                                    color: Color(0xFF4CAF50),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.cash,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFE0E0E0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.payAtTherapistLocation,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF808080),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              // Cash payment reminder
              Obx(() {
                if (controller.paymentMethod == 'cash') {
                  final servicePrice =
                      controller.service?.pricing?.price ?? 0.0;
                  return Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            l10n.pleaseBringCash(
                              servicePrice.toStringAsFixed(2),
                            ),
                            style: const TextStyle(
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
                return const SizedBox.shrink();
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVoucherSection() {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.voucherCode,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.voucherController,
                onChanged: controller.setVoucherCode,
                style: const TextStyle(color: Color(0xFFE0E0E0)),
                decoration: InputDecoration(
                  hintText: l10n.enterVoucherCodeOptional,
                  hintStyle: TextStyle(color: Color(0xFF505050), fontSize: 13),
                  filled: true,
                  fillColor: Color(0xFF0A0A0A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(color: Color(0xFFD4AF37)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Color(0xFF1A1A1A),
            border: Border(top: BorderSide(color: Color(0xFF2A2A2A))),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading
                      ? null
                      : controller.createBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    disabledBackgroundColor: const Color(0xFF2A2A2A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        )
                      : Text(
                          l10n.confirmBooking,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
