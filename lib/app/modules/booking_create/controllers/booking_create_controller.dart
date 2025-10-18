import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/store_model.dart' hide Duration;
import '../../../data/models/service_model.dart' as service_model;
import '../../../data/models/therapist_model.dart';
import '../../../data/services/booking_service.dart';
import '../../home/controllers/home_controller.dart';

class BookingCreateController extends GetxController {
  final BookingService _bookingService = BookingService();

  final _isLoading = false.obs;
  final _pressure = 'medium'.obs;
  final _focusAreas = <String>[].obs;
  final _notes = ''.obs;
  final _voucherCode = ''.obs;

  bool get isLoading => _isLoading.value;
  String get pressure => _pressure.value;
  List<String> get focusAreas => _focusAreas;
  String get notes => _notes.value;
  String get voucherCode => _voucherCode.value;

  Store? store;
  service_model.Service? service;
  Therapist? therapist;
  String? selectedDate;
  String? selectedTime;
  String? therapistId;
  String? therapistName;
  String? therapistGender;

  final TextEditingController notesController = TextEditingController();
  final TextEditingController voucherController = TextEditingController();

  final availableFocusAreas = [
    'Neck',
    'Shoulders',
    'Back',
    'Lower Back',
    'Arms',
    'Legs',
    'Feet',
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      store = args['store'] as Store?;
      service = args['service'] as service_model.Service?;
      therapist = args['therapist'] as Therapist?;
      selectedDate = args['date'] as String?;
      selectedTime = args['time'] as String?;
      therapistId = args['therapistId'] as String?;
      therapistName = args['therapistName'] as String?;
      therapistGender = args['therapistGender'] as String?;
    }

    print('📋 Booking Create - Received:');
    print('   Date: $selectedDate');
    print('   Time: $selectedTime');
    print('   Therapist: $therapistName ($therapistId)');
    print('   Gender: $therapistGender');
    print('   Service: ${service?.name}');
  }

  @override
  void onClose() {
    notesController.dispose();
    voucherController.dispose();
    super.onClose();
  }

  void setPressure(String value) {
    _pressure.value = value;
  }

  void toggleFocusArea(String area) {
    if (_focusAreas.contains(area)) {
      _focusAreas.remove(area);
    } else {
      _focusAreas.add(area);
    }
  }

  void setNotes(String value) {
    _notes.value = value;
  }

  void setVoucherCode(String value) {
    _voucherCode.value = value;
  }

  Future<void> createBooking() async {
    if (therapistId == null ||
        service?.id == null ||
        selectedDate == null ||
        selectedTime == null) {
      Get.snackbar(
        'Error',
        'Missing required booking information',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    _isLoading.value = true;

    // Prepare preferences
    final preferences = <String, dynamic>{'pressure': _pressure.value};

    if (therapistGender != null) {
      preferences['gender'] = therapistGender;
    }

    if (_focusAreas.isNotEmpty) {
      preferences['focus'] = _focusAreas.toList();
    }

    print('🎯 Creating booking with:');
    print('   therapistId: $therapistId');
    print('   serviceId: ${service!.id}');
    print('   date: $selectedDate');
    print('   startTime: $selectedTime');
    print('   preferences: $preferences');

    final response = await _bookingService.createBooking(
      therapistId: therapistId!,
      serviceId: service!.id!,
      date: selectedDate!,
      startTime: selectedTime!,
      paymentMethod: 'wallet',
      voucherCode: _voucherCode.value.isNotEmpty ? _voucherCode.value : null,
      preferences: preferences,
      notes: _notes.value.isNotEmpty ? _notes.value : null,
    );

    _isLoading.value = false;

    if (response.isSuccess && response.data != null) {
      print('✅ Booking created successfully: ${response.data!.id}');

      Get.snackbar(
        'Success',
        'Booking created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD4AF37),
        colorText: Colors.black,
        duration: Duration(seconds: 2),
      );

      // Wait for snackbar to show
      await Future.delayed(Duration(seconds: 2));

      // Navigate back to main navigation (preserves bottom nav bar)
      Get.until((route) => route.isFirst);

      // Refresh home page data to update wallet balance
      try {
        final homeController = Get.find<HomeController>();
        homeController.loadUserData();
      } catch (e) {
        print('⚠️ HomeController not found: $e');
      }
    } else {
      print('❌ Booking failed: ${response.error}');
      _showBookingErrorDialog(response.error);
    }
  }

  void _showBookingErrorDialog(dynamic error) {
    String title = 'Booking Failed';
    String message = 'Failed to create booking. Please try again.';
    IconData icon = Icons.error_outline;
    Color iconColor = Colors.red;

    // Parse error response
    if (error is Map<String, dynamic>) {
      // Handle structured error response
      final errorType = error['error'] ?? '';
      final errorMessage = error['message'] ?? '';

      if (errorType == 'Insufficient Balance') {
        title = 'Insufficient Wallet Balance';
        message = errorMessage.isNotEmpty
            ? errorMessage
            : 'Your wallet balance is insufficient. Please top up your wallet to proceed.';
        icon = Icons.account_balance_wallet_outlined;
        iconColor = const Color(0xFFFF9800);
      } else if (errorType.toString().toLowerCase().contains('validation')) {
        title = 'Invalid Information';
        message = errorMessage.isNotEmpty
            ? errorMessage
            : 'Please check your booking information and try again.';
        icon = Icons.info_outline;
        iconColor = Colors.orange;
      } else {
        title = errorType.isNotEmpty ? errorType.toString() : 'Booking Failed';
        message = errorMessage.isNotEmpty
            ? errorMessage
            : 'An error occurred while creating your booking.';
      }
    } else if (error is String) {
      message = error;
    }

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: iconColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Icon(icon, size: 48, color: iconColor),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Message
              Text(
                message,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF808080),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Actions
              if (error is Map<String, dynamic> &&
                  error['error'] == 'Insufficient Balance') ...[
                // Show two buttons for insufficient balance
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF808080),
                          side: const BorderSide(color: Color(0xFF2A2A2A)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          // Navigate to wallet top-up page
                          Get.toNamed('/wallet-topup');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Top Up Wallet',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                // Single OK button for other errors
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD4AF37),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
