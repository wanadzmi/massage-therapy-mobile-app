import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/therapist_booking_detail_controller.dart';
import '../../../global_widgets/cash_collection_dialog.dart';

class TherapistBookingDetailView
    extends GetView<TherapistBookingDetailController> {
  const TherapistBookingDetailView({super.key});

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
        title: Obx(
          () => Text(
            controller.booking?.bookingCode ?? 'Booking Details',
            style: const TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Obx(
        () => controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
              )
            : controller.booking == null
            ? _buildErrorState()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status & Action Items Card
                    _buildStatusCard(),
                    const SizedBox(height: 16),

                    // Customer Information Card
                    _buildCustomerInfoCard(),
                    const SizedBox(height: 16),

                    // Customer Preferences Card (NEW)
                    if (controller.booking?.preferences?.hasData == true ||
                        controller
                                .booking
                                ?.customerDetails
                                ?.preferences
                                ?.hasData ==
                            true)
                      _buildPreferencesCard(),
                    if (controller.booking?.preferences?.hasData == true ||
                        controller
                                .booking
                                ?.customerDetails
                                ?.preferences
                                ?.hasData ==
                            true)
                      const SizedBox(height: 16),

                    // Service Information Card
                    _buildServiceInfoCard(),
                    const SizedBox(height: 16),

                    // Payment Information Card
                    _buildPaymentInfoCard(),
                    const SizedBox(height: 16),

                    // Special Requests & Notes
                    if (controller.booking?.customerDetails != null)
                      _buildNotesCard(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load booking details',
            style: TextStyle(fontSize: 16, color: Color(0xFF808080)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.black,
            ),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    final booking = controller.booking!;
    final actionItems = booking.actionItems;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    booking.status,
                  ).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(
                      booking.status,
                    ).withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  booking.status?.toUpperCase() ?? 'N/A',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(booking.status),
                  ),
                ),
              ),
            ],
          ),
          if (actionItems != null) ...[
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF2A2A2A)),
            const SizedBox(height: 16),
            const Text(
              'Action Items',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF808080),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (actionItems.requiresCashCollection == true)
                  _buildActionChip(
                    'Cash Collection Required',
                    Icons.payments,
                    const Color(0xFFFF9800),
                  ),
                if (actionItems.needsPaymentCollection == true)
                  _buildActionChip(
                    'Payment Collection',
                    Icons.account_balance_wallet,
                    const Color(0xFFFF5722),
                  ),
                if (actionItems.canStartSession == true)
                  _buildActionChip(
                    'Can Start Session',
                    Icons.play_circle,
                    const Color(0xFF4CAF50),
                  ),
                if (actionItems.canComplete == true)
                  _buildActionChip(
                    'Can Complete',
                    Icons.check_circle,
                    const Color(0xFF2196F3),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Cash Collection Button
            if (actionItems.requiresCashCollection == true &&
                booking.paymentInfo?.isPaid != true)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Get.dialog(
                      CashCollectionDialog(
                        booking: booking,
                        onSuccess: () {
                          controller.loadBookingDetails(booking.id!);
                        },
                      ),
                    );
                  },
                  icon: const Icon(Icons.payments, size: 20),
                  label: const Text(
                    'Collect Cash Payment',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9800),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoCard() {
    final booking = controller.booking!;
    final customerDetails = booking.customerDetails;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFFD4AF37),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Customer Information',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
              ),
              if (booking.userMemberTier != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getTierColor(
                      booking.userMemberTier!,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getTierColor(
                        booking.userMemberTier!,
                      ).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.stars,
                        size: 14,
                        color: _getTierColor(booking.userMemberTier!),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        booking.userMemberTier!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _getTierColor(booking.userMemberTier!),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            Icons.person_outline,
            'Name',
            booking.userName ?? 'N/A',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.phone,
            'Phone',
            customerDetails?.contactInfo?.phone ?? booking.userPhone ?? 'N/A',
          ),
          if (customerDetails?.contactInfo?.email != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.email,
              'Email',
              customerDetails!.contactInfo!.email!,
            ),
          ],
          if (booking.userGender != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(Icons.wc, 'Gender', booking.userGender!),
          ],
          if (booking.userDateOfBirth != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.cake,
              'Date of Birth',
              controller.formatDate(booking.userDateOfBirth),
            ),
          ],
          if (booking.userAddress != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(Icons.location_on, 'Address', booking.userAddress!),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceInfoCard() {
    final booking = controller.booking!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.spa,
                  color: Color(0xFF9C27B0),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Service Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            Icons.medical_services,
            'Service',
            booking.service?.name ?? 'N/A',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.store, 'Store', booking.store?.name ?? 'N/A'),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.calendar_today,
            'Date',
            controller.formatDate(booking.date),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.access_time,
            'Time',
            '${booking.startTime} - ${booking.endTime}',
          ),
          if (booking.duration?.display != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(Icons.timer, 'Duration', booking.duration!.display!),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentInfoCard() {
    final booking = controller.booking!;
    final paymentInfo = booking.paymentInfo;
    final pricing = booking.pricing;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.payment,
                  color: Color(0xFF4CAF50),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Payment Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (paymentInfo != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      paymentInfo.isCash == true
                          ? Icons.money
                          : Icons.account_balance,
                      size: 18,
                      color: paymentInfo.isCash == true
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF2196F3),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Method: ${paymentInfo.isCash == true ? "Cash" : "Transfer"}',
                      style: TextStyle(
                        fontSize: 14,
                        color: paymentInfo.isCash == true
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFF2196F3),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (paymentInfo.isPaid == true)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Text(
                      'PAID',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF2A2A2A)),
            const SizedBox(height: 16),
          ],
          if (pricing != null) ...[
            _buildPricingRow(
              'Service Price',
              controller.formatCurrency(pricing.servicePrice),
            ),
            if (pricing.discountAmount != null &&
                pricing.discountAmount! > 0) ...[
              const SizedBox(height: 8),
              _buildPricingRow(
                'Discount',
                '- ${controller.formatCurrency(pricing.discountAmount)}',
                color: const Color(0xFF4CAF50),
              ),
            ],
            if (pricing.voucherDiscount != null &&
                pricing.voucherDiscount! > 0) ...[
              const SizedBox(height: 8),
              _buildPricingRow(
                'Voucher',
                '- ${controller.formatCurrency(pricing.voucherDiscount)}',
                color: const Color(0xFF4CAF50),
              ),
            ],
            const SizedBox(height: 12),
            const Divider(color: Color(0xFF2A2A2A)),
            const SizedBox(height: 12),
            _buildPricingRow(
              'Total Amount',
              controller.formatCurrency(pricing.totalAmount),
              isBold: true,
              color: const Color(0xFFD4AF37),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreferencesCard() {
    // Get preferences from either root level or customerDetails
    final preferences =
        controller.booking!.preferences ??
        controller.booking!.customerDetails?.preferences;

    if (preferences == null || !preferences.hasData) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.spa,
                  color: Color(0xFFD4AF37),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Customer Preferences',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Pressure Preference
          if (preferences.pressure != null) ...[
            _buildPreferenceRow(
              Icons.touch_app,
              'Pressure',
              preferences.pressure!.toUpperCase(),
            ),
            const SizedBox(height: 12),
          ],

          // Focus Areas
          if (preferences.focus != null && preferences.focus!.isNotEmpty) ...[
            _buildPreferenceRow(
              Icons.my_location,
              'Focus Areas',
              preferences.focus!.join(', '),
            ),
            const SizedBox(height: 12),
          ],

          // Temperature
          if (preferences.temperature != null) ...[
            _buildPreferenceRow(
              Icons.thermostat,
              'Temperature',
              preferences.temperature!,
            ),
            const SizedBox(height: 12),
          ],

          // Medical Information (Highlighted)
          if (preferences.hasMedicalInfo) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFFF9800),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'IMPORTANT MEDICAL INFORMATION',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF9800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (preferences.allergies != null) ...[
                    Text(
                      'Allergies: ${preferences.allergies}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFE0E0E0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (preferences.medicalConditions != null)
                      const SizedBox(height: 8),
                  ],
                  if (preferences.medicalConditions != null) ...[
                    Text(
                      'Medical Conditions: ${preferences.medicalConditions}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFE0E0E0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Other Preferences
          if (preferences.other != null) ...[
            _buildPreferenceRow(
              Icons.info_outline,
              'Other',
              preferences.other!,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreferenceRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF808080)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF808080),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(fontSize: 14, color: Color(0xFFE0E0E0)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesCard() {
    final customerDetails = controller.booking!.customerDetails!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.note,
                  color: Color(0xFF2196F3),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Notes & Requests',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (customerDetails.specialRequests != null) ...[
            const Text(
              'Special Requests',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF808080),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              customerDetails.specialRequests!,
              style: const TextStyle(fontSize: 14, color: Color(0xFFE0E0E0)),
            ),
            if (customerDetails.therapistNotes != null)
              const SizedBox(height: 16),
          ],
          if (customerDetails.therapistNotes != null) ...[
            const Text(
              'Therapist Notes',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF808080),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              customerDetails.therapistNotes!,
              style: const TextStyle(fontSize: 14, color: Color(0xFFE0E0E0)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF808080)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF808080)),
              ),
              const SizedBox(height: 4),
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

  Widget _buildPricingRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: color ?? const Color(0xFF808080),
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 18 : 14,
            color: color ?? const Color(0xFFE0E0E0),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF4CAF50);
      case 'in_progress':
        return const Color(0xFF2196F3);
      case 'completed':
        return const Color(0xFF9C27B0);
      case 'cancelled':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF808080);
    }
  }

  Color _getTierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'platinum':
        return const Color(0xFFB9F2FF);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'bronze':
        return const Color(0xFFCD7F32);
      default:
        return const Color(0xFF808080);
    }
  }
}
