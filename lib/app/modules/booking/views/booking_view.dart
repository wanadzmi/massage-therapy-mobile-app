import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';

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
                        '${controller.appointments.length} ${controller.appointments.length == 1 ? "booking" : "bookings"}',
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
              () => controller.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD4AF37),
                      ),
                    )
                  : controller.appointments.isEmpty
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
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: controller.appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = controller.appointments[index];
                        return _buildAppointmentCard(appointment);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    final status = appointment['status'] as String;
    final date = appointment['date'] as DateTime;
    final dateString = _formatDate(date);
    Color statusColor;
    String statusLabel;

    switch (status) {
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
      default:
        statusColor = const Color(0xFF808080);
        statusLabel = 'Unknown';
    }

    return GestureDetector(
      onTap: () {
        final l10n = AppLocalizations.of(Get.context!)!;
        Get.snackbar(
          l10n.appointmentDetails,
          l10n.viewDetails,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E1E1E),
          colorText: const Color(0xFFE0E0E0),
        );
      },
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
                        appointment['service'],
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
                            appointment['time'],
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
                      Text(
                        appointment['therapist'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.w600,
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
                          appointment['location'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ),
                    ],
                  ),
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
