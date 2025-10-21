import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/booking_completion_service.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/repositories/auth_repository.dart';

class TherapistHomeController extends GetxController {
  final BookingCompletionService _bookingService = BookingCompletionService();
  final AuthRepository _authRepository = AuthRepository();

  final _isLoading = false.obs;
  final _bookings = <Booking>[].obs;
  final _therapistName = ''.obs;
  final _completingBookingId = ''.obs;

  bool get isLoading => _isLoading.value;
  List<Booking> get bookings => _bookings;
  String get therapistName => _therapistName.value;
  bool isCompletingBooking(String bookingId) =>
      _completingBookingId.value == bookingId;

  @override
  void onInit() {
    super.onInit();
    loadTherapistInfo();
    loadBookings();
  }

  Future<void> loadTherapistInfo() async {
    try {
      final response = await _authRepository.getUserProfile();
      if (response.isSuccess && response.data != null) {
        _therapistName.value = response.data!.name ?? 'Therapist';
      }
    } catch (e) {
      print('Error loading therapist info: $e');
    }
  }

  Future<void> loadBookings() async {
    try {
      _isLoading.value = true;
      final response = await _bookingService.getTherapistActiveBookings();

      if (response.isSuccess && response.data != null) {
        _bookings.value = response.data!;
        print('✅ Loaded ${_bookings.length} active bookings');
      } else {
        _bookings.value = [];
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to load bookings',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error loading bookings: $e');
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> completeBooking(String bookingId, int? satisfaction) async {
    try {
      _completingBookingId.value = bookingId;

      final response = await _bookingService.completeBooking(
        bookingId: bookingId,
        customerSatisfaction: satisfaction,
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data!.data;

        // Show success dialog
        Get.dialog(
          Dialog(
            backgroundColor: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF4CAF50).withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      size: 48,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Booking Completed!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (data?.loyaltyPointsAwarded != null)
                    Text(
                      '${data!.loyaltyPointsAwarded} loyalty points awarded to customer',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF808080),
                      ),
                    ),
                  if (data?.booking?.pricing?.cashback != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'RM ${data!.booking!.pricing!.cashback!.toStringAsFixed(2)} cashback credited',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        loadBookings(); // Refresh the list
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to complete booking',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      _completingBookingId.value = '';
    }
  }

  void showCompleteBookingDialog(Booking booking) {
    int? selectedRating;

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.task_alt,
                    size: 48,
                    color: Color(0xFF4CAF50),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Complete Booking?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    booking.bookingCode ?? 'Booking',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF808080),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'How was the customer?',
                    style: TextStyle(fontSize: 14, color: Color(0xFFE0E0E0)),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [1, 2, 3, 4, 5].map((rating) {
                      return IconButton(
                        icon: Icon(
                          rating <= (selectedRating ?? 0)
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color(0xFFFFB300),
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedRating = rating;
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'This will:',
                    style: TextStyle(fontSize: 12, color: Color(0xFF808080)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Award loyalty points to customer\n'
                    '• Credit cashback to customer wallet\n'
                    '• Allow customer to leave a review\n'
                    '\n'
                    'This action cannot be undone.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Color(0xFF808080)),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFE0E0E0),
                            side: const BorderSide(color: Color(0xFF2A2A2A)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                            completeBooking(booking.id!, selectedRating);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Complete'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}
