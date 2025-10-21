import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/therapist_home_controller.dart';
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

    return Container(
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
                child: Text(
                  booking.status?.toUpperCase() ?? '',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(booking.status),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Customer Name
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
              ],
            ),
          const SizedBox(height: 8),

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
                style: const TextStyle(fontSize: 14, color: Color(0xFFE0E0E0)),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16, color: Color(0xFF808080)),
              const SizedBox(width: 8),
              Text(
                '${booking.startTime} - ${booking.endTime}',
                style: const TextStyle(fontSize: 14, color: Color(0xFFE0E0E0)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Complete Button
          if (booking.status == 'confirmed' || booking.status == 'in_progress')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isCompleting
                    ? null
                    : () => controller.showCompleteBookingDialog(booking),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF2A2A2A),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isCompleting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Complete Booking',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF4CAF50);
      case 'in_progress':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFF808080);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('MMM dd, yyyy').format(date);
  }
}
