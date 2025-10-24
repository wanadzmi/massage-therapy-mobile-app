import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../data/models/booking_model.dart';
import '../../../routes/app_pages.dart';

import '../controllers/booking_controller.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        title: Text(
          l10n.activity,
          style: const TextStyle(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w500,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          Obx(
            () => Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF2A2A2A)),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      color: Color(0xFFD4AF37),
                      size: 18,
                    ),
                  ),
                  onPressed: () {
                    _showFilterBottomSheet(context);
                  },
                ),
                if (controller.selectedFilter != 'all')
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF0A0A0A),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Appointments Section Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.yourAppointments,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE0E0E0),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        '${controller.bookings.length} ${controller.bookings.length == 1 ? l10n.booking : l10n.bookings}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF808080),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Active Filter Indicator
          Obx(
            () => controller.selectedFilter != 'all'
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.filter_alt,
                            color: Color(0xFFD4AF37),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${l10n.filtered}: ${_getFilterLabel(context, controller.selectedFilter)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => controller.setFilter('all'),
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Color(0xFFD4AF37),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Color(0xFF0A0A0A),
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Appointments List
          Expanded(
            child: Obx(
              () => controller.isLoading && controller.bookings.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD4AF37),
                      ),
                    )
                  : controller.bookings.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF2A2A2A),
                              ),
                            ),
                            child: const Icon(
                              Icons.event_available_outlined,
                              size: 48,
                              color: Color(0xFF505050),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            l10n.noAppointments,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF808080),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Book a massage session today',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF606060),
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      color: const Color(0xFFD4AF37),
                      backgroundColor: const Color(0xFF1A1A1A),
                      onRefresh: controller.refresh,
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount: controller.bookings.length,
                        itemBuilder: (context, index) {
                          final booking = controller.bookings[index];
                          return _buildBookingCard(context, booking);
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    final l10n = AppLocalizations.of(context)!;
    final status = booking.status ?? 'unknown';
    final date = booking.date;
    final dateString = date != null ? _formatDate(context, date) : 'N/A';
    Color statusColor;
    String statusLabel;

    switch (status.toLowerCase()) {
      case 'confirmed':
        statusColor = const Color(0xFF4CAF50);
        statusLabel = l10n.confirmed;
        break;
      case 'pending':
        statusColor = const Color(0xFFFF9800);
        statusLabel = l10n.pending;
        break;
      case 'cancelled':
        statusColor = const Color(0xFFE53E3E);
        statusLabel = l10n.cancelled;
        break;
      case 'completed':
        statusColor = const Color(0xFF2196F3);
        statusLabel = l10n.completed;
        break;
      case 'in_progress':
        statusColor = const Color(0xFFD4AF37);
        statusLabel = l10n.inProgress;
        break;
      default:
        statusColor = const Color(0xFF808080);
        statusLabel = 'Unknown';
    }

    return GestureDetector(
      onTap: () => controller.viewBookingDetails(booking),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.spa_outlined,
                    color: Color(0xFFD4AF37),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.service?.name ?? 'Unknown Service',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 13,
                            color: Color(0xFF808080),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            dateString,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF808080),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.access_time,
                            size: 13,
                            color: Color(0xFF808080),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            booking.startTime ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF808080),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.person_outline,
                        size: 16,
                        color: Color(0xFF808080),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.therapist,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF606060),
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Text(
                          booking.therapist?.name ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Color(0xFF808080),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          booking.store?.name ?? 'N/A',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF808080),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (booking.pricing?.totalAmount != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.payments_outlined,
                          size: 16,
                          color: Color(0xFF808080),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.total,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF606060),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'RM ${booking.pricing!.totalAmount!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (booking.payment?.method != null) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          booking.payment!.method == 'wallet'
                              ? Icons.account_balance_wallet_outlined
                              : booking.payment!.method == 'cash'
                              ? Icons.money
                              : Icons.credit_card_outlined,
                          size: 16,
                          color: Color(0xFF808080),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.paymentMethod,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF606060),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: booking.payment!.method == 'wallet'
                                ? const Color(
                                    0xFFD4AF37,
                                  ).withValues(alpha: 0.15)
                                : booking.payment!.method == 'cash'
                                ? const Color(
                                    0xFF4CAF50,
                                  ).withValues(alpha: 0.15)
                                : const Color(
                                    0xFF2196F3,
                                  ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: booking.payment!.method == 'wallet'
                                  ? const Color(
                                      0xFFD4AF37,
                                    ).withValues(alpha: 0.3)
                                  : booking.payment!.method == 'cash'
                                  ? const Color(
                                      0xFF4CAF50,
                                    ).withValues(alpha: 0.3)
                                  : const Color(
                                      0xFF2196F3,
                                    ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            booking.payment!.method == 'wallet'
                                ? l10n.wallet
                                : booking.payment!.method == 'cash'
                                ? l10n.cash
                                : booking.payment!.method!.toUpperCase(),
                            style: TextStyle(
                              fontSize: 11,
                              color: booking.payment!.method == 'wallet'
                                  ? const Color(0xFFD4AF37)
                                  : booking.payment!.method == 'cash'
                                  ? const Color(0xFF4CAF50)
                                  : const Color(0xFF2196F3),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            // Write Review button for completed bookings (only if not reviewed)
            if (booking.status == 'completed') ...[
              const SizedBox(height: 12),
              if (booking.hasReview == true)
                // Already reviewed indicator
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF2A2A2A)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Color(0xFF4CAF50),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.reviewSubmitted,
                        style: const TextStyle(
                          color: Color(0xFF808080),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              else
                // Write review button
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Get.toNamed(
                        Routes.WRITE_REVIEW,
                        arguments: booking,
                      );
                      // Refresh bookings if review was submitted
                      if (result == true) {
                        controller.loadBookings(refresh: true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(
                      Icons.rate_review,
                      size: 16,
                      color: Color(0xFF0A0A0A),
                    ),
                    label: Text(
                      l10n.writeReview,
                      style: const TextStyle(
                        color: Color(0xFF0A0A0A),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
            // Cancel button for cancellable bookings
            if (_canCancelBooking(booking)) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: OutlinedButton(
                  onPressed: () => _showCancelDialog(context, booking),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE53E3E)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    l10n.cancelBooking,
                    style: const TextStyle(
                      color: Color(0xFFE53E3E),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _canCancelBooking(Booking booking) {
    // Cannot cancel if already cancelled, completed, or in progress
    if (booking.status == 'cancelled' ||
        booking.status == 'completed' ||
        booking.status == 'in_progress') {
      return false;
    }

    // For confirmed bookings, check if it's less than 1 hour before start time
    if (booking.status == 'confirmed' &&
        booking.date != null &&
        booking.startTime != null) {
      try {
        final date = booking.date!;
        final timeStr = booking.startTime!;
        final timeParts = timeStr.split(':');
        if (timeParts.length >= 2) {
          final hour = int.tryParse(timeParts[0]) ?? 0;
          final minute = int.tryParse(timeParts[1]) ?? 0;
          final bookingDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            hour,
            minute,
          );
          final now = DateTime.now();
          final hoursUntilBooking = bookingDateTime.difference(now).inHours;

          // Cannot cancel if less than 1 hour before booking
          if (hoursUntilBooking < 1) {
            return false;
          }
        }
      } catch (e) {
        // If parsing fails, allow cancellation
        return true;
      }
    }

    return true;
  }

  void _showCancelDialog(BuildContext context, Booking booking) {
    final l10n = AppLocalizations.of(context)!;
    // Check if booking can be cancelled
    if (!_canCancelBooking(booking)) {
      Get.snackbar(
        l10n.cannotCancel,
        l10n.cannotCancelMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFE53E3E),
        duration: const Duration(seconds: 4),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) => _CancelBookingDialog(
        booking: booking,
        onCancel: (reason, details) {
          controller.cancelBooking(booking, reason, details: details);
        },
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return l10n.today;
    } else if (dateOnly == tomorrow) {
      return l10n.tomorrow;
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  String _getFilterLabel(BuildContext context, String filter) {
    final l10n = AppLocalizations.of(context)!;
    switch (filter) {
      case 'confirmed':
        return l10n.confirmed;
      case 'pending':
        return l10n.pending;
      case 'completed':
        return l10n.completed;
      case 'cancelled':
        return l10n.cancelled;
      case 'in_progress':
        return l10n.inProgress;
      default:
        return l10n.all;
    }
  }

  void _showFilterBottomSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filters = [
      {'value': 'all', 'label': l10n.allBookings, 'icon': Icons.list},
      {
        'value': 'confirmed',
        'label': l10n.confirmed,
        'icon': Icons.check_circle,
      },
      {'value': 'pending', 'label': l10n.pending, 'icon': Icons.pending},
      {'value': 'completed', 'label': l10n.completed, 'icon': Icons.task_alt},
      {'value': 'cancelled', 'label': l10n.cancelled, 'icon': Icons.cancel},
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.filter_list,
                    color: Color(0xFFD4AF37),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n.filterBookings,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...filters.map(
              (filter) => Obx(
                () => InkWell(
                  onTap: () {
                    controller.setFilter(filter['value'] as String);
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: controller.selectedFilter == filter['value']
                          ? const Color(0xFFD4AF37).withValues(alpha: 0.15)
                          : const Color(0xFF0A0A0A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.selectedFilter == filter['value']
                            ? const Color(0xFFD4AF37)
                            : const Color(0xFF2A2A2A),
                        width: controller.selectedFilter == filter['value']
                            ? 2
                            : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          filter['icon'] as IconData,
                          color: controller.selectedFilter == filter['value']
                              ? const Color(0xFFD4AF37)
                              : const Color(0xFF808080),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          filter['label'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight:
                                controller.selectedFilter == filter['value']
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: controller.selectedFilter == filter['value']
                                ? const Color(0xFFD4AF37)
                                : const Color(0xFFE0E0E0),
                          ),
                        ),
                        const Spacer(),
                        if (controller.selectedFilter == filter['value'])
                          const Icon(
                            Icons.check,
                            color: Color(0xFFD4AF37),
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _CancelBookingDialog extends StatefulWidget {
  final Booking booking;
  final Function(String reason, String? details) onCancel;

  const _CancelBookingDialog({required this.booking, required this.onCancel});

  @override
  State<_CancelBookingDialog> createState() => _CancelBookingDialogState();
}

class _CancelBookingDialogState extends State<_CancelBookingDialog> {
  late final TextEditingController _reasonController;
  late final TextEditingController _detailsController;

  @override
  void initState() {
    super.initState();
    _reasonController = TextEditingController();
    _detailsController = TextEditingController();
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFF2A2A2A)),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53E3E).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: Color(0xFFE53E3E),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Cancel Booking',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Please provide a reason for cancellation',
                style: TextStyle(fontSize: 14, color: Color(0xFF808080)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _reasonController,
                style: const TextStyle(color: Color(0xFFE0E0E0)),
                decoration: InputDecoration(
                  labelText: 'Reason',
                  hintText: 'e.g., Schedule conflict',
                  labelStyle: const TextStyle(color: Color(0xFF808080)),
                  hintStyle: const TextStyle(color: Color(0xFF606060)),
                  filled: true,
                  fillColor: const Color(0xFF0A0A0A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFD4AF37),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _detailsController,
                style: const TextStyle(color: Color(0xFFE0E0E0)),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Details (Optional)',
                  hintText: 'e.g., Need to reschedule due to work meeting',
                  labelStyle: const TextStyle(color: Color(0xFF808080)),
                  hintStyle: const TextStyle(color: Color(0xFF606060)),
                  filled: true,
                  fillColor: const Color(0xFF0A0A0A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFD4AF37),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2A2A2A)),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Keep Booking',
                        style: TextStyle(
                          color: Color(0xFFE0E0E0),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final reason = _reasonController.text.trim();
                        if (reason.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please provide a reason for cancellation',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: const Color(0xFF1E1E1E),
                            colorText: const Color(0xFFE53E3E),
                          );
                          return;
                        }
                        final details = _detailsController.text.trim();
                        Navigator.of(context).pop();
                        widget.onCancel(
                          reason,
                          details.isEmpty ? null : details,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53E3E),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel Booking',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
