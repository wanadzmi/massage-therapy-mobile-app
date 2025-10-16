import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/booking_controller.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: Colors.orange.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected Service
            Obx(
              () => Card(
                child: ListTile(
                  title: const Text('Selected Service'),
                  subtitle: Text(
                    controller.selectedService.isEmpty
                        ? 'No service selected'
                        : controller.selectedService,
                  ),
                  trailing: const Icon(Icons.spa),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Date Selection
            const Text(
              'Select Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Obx(
              () => Card(
                child: ListTile(
                  title: Text(
                    'Date: ${controller.selectedDate.day}/${controller.selectedDate.month}/${controller.selectedDate.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Time Selection
            const Text(
              'Select Time',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Obx(
              () => Card(
                child: ListTile(
                  title: Text(
                    controller.selectedTime.isEmpty
                        ? 'No time selected'
                        : 'Time: ${controller.selectedTime}',
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: () => _selectTime(context),
                ),
              ),
            ),

            const Spacer(),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading
                      ? null
                      : () => controller.confirmBooking(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade600,
                  ),
                  child: controller.isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Confirm Booking',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      controller.selectDate(picked);
    }
  }

  void _selectTime(BuildContext context) {
    final times = [
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '02:00 PM',
      '03:00 PM',
      '04:00 PM',
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: times.length,
        itemBuilder: (context, index) {
          final time = times[index];
          return ListTile(
            title: Text(time),
            onTap: () {
              controller.selectTime(time);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
