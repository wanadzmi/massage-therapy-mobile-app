import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/booking_completion_service.dart';
import '../../../data/services/booking_service.dart' as booking_svc;
import '../../../data/models/booking_model.dart';
import '../../../data/repositories/auth_repository.dart';

class TherapistHomeController extends GetxController {
  final BookingCompletionService _bookingService = BookingCompletionService();
  final booking_svc.BookingService _newBookingService =
      booking_svc.BookingService();
  final AuthRepository _authRepository = AuthRepository();

  final _isLoading = false.obs;
  final _bookings = <Booking>[].obs;
  final _therapistName = ''.obs;
  final _completingBookingId = ''.obs;
  final _processingBookingId = ''.obs;

  bool get isLoading => _isLoading.value;
  List<Booking> get bookings => _bookings;
  String get therapistName => _therapistName.value;
  bool isCompletingBooking(String bookingId) =>
      _completingBookingId.value == bookingId;
  bool isProcessingBooking(String bookingId) =>
      _processingBookingId.value == bookingId;

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

  Future<void> acceptBooking(String bookingId) async {
    try {
      _processingBookingId.value = bookingId;

      final response = await _newBookingService.acceptBooking(bookingId);

      if (response.isSuccess && response.data != null) {
        Get.snackbar(
          'Success',
          'Booking accepted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50).withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        loadBookings();
      } else {
        // Check for schedule conflict (409)
        if (response.error?.contains('409') == true ||
            response.error?.toLowerCase().contains('conflict') == true) {
          Get.dialog(
            AlertDialog(
              backgroundColor: const Color(0xFF1A1A1A),
              title: const Text(
                'Schedule Conflict',
                style: TextStyle(color: Color(0xFFE0E0E0)),
              ),
              content: const Text(
                'You already have a booking at this time. Please check your schedule.',
                style: TextStyle(color: Color(0xFF808080)),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Color(0xFFD4AF37)),
                  ),
                ),
              ],
            ),
          );
        } else {
          Get.snackbar(
            'Error',
            response.error ?? 'Failed to accept booking',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        }
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
      _processingBookingId.value = '';
    }
  }

  void showRejectDialog(String bookingId) {
    final reasonController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cancel_outlined,
                size: 48,
                color: Color(0xFFFF5252),
              ),
              const SizedBox(height: 16),
              const Text(
                'Reject Booking?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: reasonController,
                maxLines: 3,
                style: const TextStyle(color: Color(0xFFE0E0E0)),
                decoration: InputDecoration(
                  hintText: 'Enter reason for rejection...',
                  hintStyle: const TextStyle(color: Color(0xFF808080)),
                  filled: true,
                  fillColor: const Color(0xFF0A0A0A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFFD4AF37)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This will cancel the booking and refund the customer.',
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
                        if (reasonController.text.trim().isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please enter a reason for rejection',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.withOpacity(0.8),
                            colorText: Colors.white,
                          );
                          return;
                        }
                        Get.back();
                        rejectBooking(bookingId, reasonController.text.trim());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF5252),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Reject'),
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

  Future<void> rejectBooking(String bookingId, String reason) async {
    try {
      _processingBookingId.value = bookingId;

      final response = await _newBookingService.rejectBooking(
        bookingId,
        reason,
      );

      if (response.isSuccess && response.data != null) {
        Get.snackbar(
          'Success',
          'Booking rejected. Customer will be refunded.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50).withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        loadBookings();
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to reject booking',
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
      _processingBookingId.value = '';
    }
  }

  void showStartSessionDialog(Booking booking) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Text(
          'Start Session?',
          style: TextStyle(color: Color(0xFFE0E0E0)),
        ),
        content: Text(
          'Start session for ${booking.bookingCode ?? "this booking"}?',
          style: const TextStyle(color: Color(0xFF808080)),
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
              startSession(booking.id!);
            },
            child: const Text(
              'Start',
              style: TextStyle(color: Color(0xFFD4AF37)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> startSession(String bookingId) async {
    try {
      _processingBookingId.value = bookingId;

      final response = await _newBookingService.startSession(bookingId);

      if (response.isSuccess && response.data != null) {
        Get.snackbar(
          'Success',
          'Session started',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50).withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        loadBookings();
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to start session',
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
      _processingBookingId.value = '';
    }
  }

  Future<void> completeBooking(String bookingId, int? satisfaction) async {
    try {
      _completingBookingId.value = bookingId;

      // Use the new BookingService complete endpoint
      final response = await _newBookingService.completeBooking(
        bookingId,
        satisfaction ?? 3,
      );

      if (response.isSuccess && response.data != null) {
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
                  Text(
                    'Session completed successfully',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF808080),
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
