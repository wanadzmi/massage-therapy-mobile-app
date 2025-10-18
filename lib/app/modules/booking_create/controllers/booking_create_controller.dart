import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/store_model.dart' hide Duration;
import '../../../data/models/service_model.dart' as service_model;
import '../../../data/models/therapist_model.dart';
import '../../../data/services/booking_service.dart';

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
      );

      // Navigate to booking detail or back to home
      await Future.delayed(Duration(seconds: 1));

      // Navigate to booking detail if route exists, otherwise go home
      if (response.data!.id != null) {
        Get.offAllNamed('/home');
        Get.toNamed('/booking-detail', arguments: response.data!.id);
      } else {
        Get.offAllNamed('/home');
      }
    } else {
      print('❌ Booking failed: ${response.error}');

      Get.snackbar(
        'Booking Failed',
        response.error ?? 'Failed to create booking. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}
