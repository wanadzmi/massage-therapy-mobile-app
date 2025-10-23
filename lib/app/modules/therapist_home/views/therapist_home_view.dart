import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/therapist_home_controller.dart';
import '../../../global_widgets/cash_collection_dialog.dart';
import '../../../global_widgets/session_timer.dart';
import 'package:intl/intl.dart';

class TherapistHomeView extends GetView<TherapistHomeController> {
  const TherapistHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Therapist Portal',
                style: TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                controller.therapistName,
                style: const TextStyle(color: Color(0xFF808080), fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFFD4AF37)),
            onPressed: () => Get.toNamed('/therapist-profile'),
            tooltip: 'Profile',
          ),
          IconButton(
            icon: const Icon(Icons.dashboard, color: Color(0xFFD4AF37)),
            onPressed: () => Get.toNamed('/therapist-today-summary'),
            tooltip: 'Today\'s Summary',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFD4AF37)),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  backgroundColor: const Color(0xFF1A1A1A),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Color(0xFFE0E0E0)),
                  ),
                  content: const Text(
                    'Are you sure you want to logout?',
                    style: TextStyle(color: Color(0xFF808080)),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Color(0xFF808080)),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        controller.logout();
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Color(0xFFD4AF37)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
              )
            : RefreshIndicator(
                color: const Color(0xFFD4AF37),
                backgroundColor: const Color(0xFF1A1A1A),
                onRefresh: controller.loadBookings,
                child: controller.bookings.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: controller.bookings.length,
                        itemBuilder: (context, index) {
                          final booking = controller.bookings[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildBookingCard(booking),
                          );
                        },
                      ),
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      padding: const EdgeInsets.all(40),
      children: [
        const SizedBox(height: 80),
        Icon(
          Icons.event_available,
          size: 80,
          color: Colors.white.withOpacity(0.1),
        ),
        const SizedBox(height: 24),
        const Text(
          'No Active Bookings',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFE0E0E0),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'You have no confirmed or in-progress bookings at the moment.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Color(0xFF808080)),
        ),
        const SizedBox(height: 24),
        Center(
          child: TextButton.icon(
            onPressed: () => controller.loadBookings(),
            icon: const Icon(Icons.refresh, color: Color(0xFFD4AF37)),
            label: const Text(
              'Refresh',
              style: TextStyle(color: Color(0xFFD4AF37)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingCard(booking) {
    final isCompleting = controller.isCompletingBooking(booking.id ?? '');

    return GestureDetector(
      onTap: () {
        if (booking.id != null) {
          Get.toNamed('/therapist-booking-detail/${booking.id}');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booking Code & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking.bookingCode ?? 'Booking',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD4AF37),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(booking.status).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _getStatusColor(booking.status).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getStatusIcon(booking.status),
                        size: 14,
                        color: _getStatusColor(booking.status),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        booking.status?.toUpperCase() ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: _getStatusColor(booking.status),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Session Timer for in_progress bookings
            if (booking.status?.toLowerCase() == 'in_progress' &&
                booking.id != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SessionTimer(
                  startTime:
                      controller.getSessionStartTime(booking.id!) ??
                      DateTime.now(),
                ),
              ),
            const SizedBox(height: 16),

            // Customer Name with Member Tier
            if (booking.userName != null || booking.user != null)
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Color(0xFF808080)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Customer: ${booking.userName ?? booking.user ?? 'N/A'}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                  ),
                  if (booking.userMemberTier != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getTierColor(
                          booking.userMemberTier!,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: _getTierColor(
                            booking.userMemberTier!,
                          ).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.stars,
                            size: 12,
                            color: _getTierColor(booking.userMemberTier!),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            booking.userMemberTier!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getTierColor(booking.userMemberTier!),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 8),

            // Payment Info
            if (booking.paymentInfo != null) ...[
              Row(
                children: [
                  Icon(
                    booking.paymentInfo!.isCash == true
                        ? Icons.money
                        : Icons.account_balance,
                    size: 16,
                    color: booking.paymentInfo!.isCash == true
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF2196F3),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    booking.paymentInfo!.isCash == true ? 'Cash' : 'Transfer',
                    style: TextStyle(
                      fontSize: 14,
                      color: booking.paymentInfo!.isCash == true
                          ? const Color(0xFF4CAF50)
                          : const Color(0xFF2196F3),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (booking.paymentInfo!.isPaid == true)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color(0xFF4CAF50).withOpacity(0.3),
                        ),
                      ),
                      child: const Text(
                        'PAID',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Service
            if (booking.service != null)
              Row(
                children: [
                  const Icon(Icons.spa, size: 16, color: Color(0xFF808080)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      booking.service!.name ?? 'Service',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),

            // Date & Time
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Color(0xFF808080),
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(booking.date),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: Color(0xFF808080),
                ),
                const SizedBox(width: 8),
                Text(
                  '${booking.startTime} - ${booking.endTime}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cash Collection Button
            if (booking.actionItems?.requiresCashCollection == true &&
                booking.paymentInfo?.isPaid != true)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.dialog(
                        CashCollectionDialog(
                          booking: booking,
                          onSuccess: () => controller.loadBookings(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.payments, size: 20),
                    label: const Text(
                      'Collect Cash Payment',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
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
              ),

            // Action Buttons based on status
            _buildActionButtons(booking, isCompleting),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(booking, bool isCompleting) {
    final isProcessing = controller.isProcessingBooking(booking.id ?? '');
    final status = booking.status?.toLowerCase();

    // PENDING status - Show Accept/Reject buttons
    if (status == 'pending') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: isProcessing
                  ? null
                  : () => controller.showRejectDialog(booking.id!),
              icon: const Icon(Icons.close, size: 20),
              label: const Text('Reject'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFFF5252),
                side: const BorderSide(color: Color(0xFFFF5252)),
                disabledForegroundColor: const Color(0xFF2A2A2A),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isProcessing
                  ? null
                  : () => controller.acceptBooking(booking.id!),
              icon: const Icon(Icons.check, size: 20),
              label: isProcessing
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Accept'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF2A2A2A),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // CONFIRMED status - Show Start Session button
    if (status == 'confirmed') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: isProcessing
              ? null
              : () => controller.showStartSessionDialog(booking),
          icon: const Icon(Icons.play_arrow, size: 20),
          label: isProcessing
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Start Session',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2196F3),
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFF2A2A2A),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    // IN_PROGRESS status - Show Complete Session button
    if (status == 'in_progress') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: isCompleting
              ? null
              : () => controller.showCompleteBookingDialog(booking),
          icon: const Icon(Icons.check_circle, size: 20),
          label: isCompleting
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Complete Session',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            disabledBackgroundColor: const Color(0xFF2A2A2A),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      );
    }

    // COMPLETED or other status - Show View Details button
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          if (booking.id != null) {
            Get.toNamed('/therapist-booking-detail/${booking.id}');
          }
        },
        icon: const Icon(Icons.visibility, size: 20),
        label: const Text(
          'View Details',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFD4AF37),
          side: const BorderSide(color: Color(0xFFD4AF37)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'confirmed':
        return Icons.check_circle_outline;
      case 'in_progress':
        return Icons.play_circle_outline;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF9800);
      case 'confirmed':
        return const Color(0xFF2196F3);
      case 'in_progress':
        return const Color(0xFF4CAF50);
      case 'completed':
        return const Color(0xFF808080);
      case 'cancelled':
        return const Color(0xFFFF5252);
      default:
        return const Color(0xFF808080);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy').format(date);
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
