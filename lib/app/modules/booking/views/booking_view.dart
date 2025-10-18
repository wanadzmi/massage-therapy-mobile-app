import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../data/models/booking_model.dart';

import '../controllers/booking_controller.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({Key? key}) : super(key: key);

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
              Get.snackbar(
                l10n.filter,
                l10n.filterOptions,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: const Color(0xFF1E1E1E),
                colorText: const Color(0xFFD4AF37),
              );
            },
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
                        '${controller.bookings.length} ${controller.bookings.length == 1 ? "booking" : "bookings"}',
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
                          return _buildBookingCard(booking);
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final status = booking.status ?? 'unknown';
    final date = booking.date;
    final dateString = date != null ? _formatDate(date) : 'N/A';
    Color statusColor;
    String statusLabel;

    switch (status.toLowerCase()) {
      case 'confirmed':
        statusColor = const Color(0xFF4CAF50);
        statusLabel = 'Confirmed';
        break;
      case 'pending':
        statusColor = const Color(0xFFFF9800);
        statusLabel = 'Pending';
        break;
      case 'cancelled':
        statusColor = const Color(0xFFE53E3E);
        statusLabel = 'Cancelled';
        break;
      case 'completed':
        statusColor = const Color(0xFF2196F3);
        statusLabel = 'Completed';
        break;
      case 'in_progress':
        statusColor = const Color(0xFFD4AF37);
        statusLabel = 'In Progress';
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
                    color: const Color(0xFFD4AF37).withOpacity(0.15),
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
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
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
                      const Text(
                        'Therapist',
                        style: TextStyle(
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
                        const Text(
                          'Total',
                          style: TextStyle(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == tomorrow) {
      return 'Tomorrow';
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
}
