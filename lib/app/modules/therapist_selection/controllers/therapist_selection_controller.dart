import 'package:get/get.dart';
import '../../../data/models/store_model.dart';
import '../../../data/models/service_model.dart' as service_model;
import '../../../data/services/booking_discovery_service.dart';

class TherapistSelectionController extends GetxController {
  final BookingDiscoveryService _bookingDiscoveryService =
      BookingDiscoveryService();

  final _isLoading = false.obs;
  final _availabilityCalendar = <DayAvailability>[].obs;
  final _selectedDate = Rx<DayAvailability?>(null);
  final _selectedSlot = Rx<SlotDetail?>(null);
  final _selectedTherapist = Rx<SlotTherapist?>(null);

  bool get isLoading => _isLoading.value;
  List<DayAvailability> get availabilityCalendar => _availabilityCalendar;
  DayAvailability? get selectedDate => _selectedDate.value;
  SlotDetail? get selectedSlot => _selectedSlot.value;
  SlotTherapist? get selectedTherapist => _selectedTherapist.value;

  Store? store;
  service_model.Service? service;
  ServiceAvailabilityCalendar? calendarData;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      store = args['store'] as Store?;
      service = args['service'] as service_model.Service?;
    }
    loadAvailabilityCalendar();
  }

  Future<void> loadAvailabilityCalendar() async {
    if (service?.id == null) {
      Get.snackbar(
        'Error',
        'Service information is missing',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _isLoading.value = true;

    print('🗓️ Loading availability calendar for service: ${service!.id}');

    final response = await _bookingDiscoveryService
        .getServiceAvailabilityCalendar(serviceId: service!.id!);

    _isLoading.value = false;

    if (response.isSuccess && response.data != null) {
      calendarData = response.data;
      _availabilityCalendar.value = response.data!.availabilityCalendar ?? [];

      print('✅ Loaded ${_availabilityCalendar.length} days with availability');
      print(
        '📊 Total days with availability: ${response.data!.totalDaysWithAvailability}',
      );

      if (_availabilityCalendar.isEmpty) {
        Get.snackbar(
          'No Availability',
          'No available dates for this service in the next 30 days.',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      print('❌ Error: ${response.error}');
      Get.snackbar(
        'Error',
        response.error ?? 'Failed to load availability calendar',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void selectDate(DayAvailability day) {
    _selectedDate.value = day;
    _selectedSlot.value = null;
    _selectedTherapist.value = null;
    print(
      '📅 Selected date: ${day.displayDate} with ${day.totalAvailableSlots} slots',
    );
  }

  void selectSlot(SlotDetail slot) {
    _selectedSlot.value = slot;
    _selectedTherapist.value = null;
    print(
      '⏰ Selected time: ${slot.time} with ${slot.availableTherapists} therapists',
    );
  }

  void selectTherapist(SlotTherapist therapist) {
    _selectedTherapist.value = therapist;
    print('👤 Selected therapist: ${therapist.name}');
  }

  void proceedToBooking() {
    if (_selectedDate.value == null) {
      Get.snackbar(
        'Error',
        'Please select a date',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_selectedSlot.value == null) {
      Get.snackbar(
        'Error',
        'Please select a time slot',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_selectedTherapist.value == null) {
      Get.snackbar(
        'Error',
        'Please select a therapist',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Navigate to booking creation with all details
    Get.toNamed(
      '/booking-create',
      arguments: {
        'service': service,
        'store': store,
        'therapist': _selectedTherapist.value,
        'date': _selectedDate.value!.date,
        'time': _selectedSlot.value!.time,
      },
    );
  }

  void goBack() {
    if (_selectedTherapist.value != null) {
      // If therapist selected, go back to slot selection
      _selectedTherapist.value = null;
    } else if (_selectedSlot.value != null) {
      // If slot selected, go back to date selection
      _selectedSlot.value = null;
    } else if (_selectedDate.value != null) {
      // If date selected, go back to date list
      _selectedDate.value = null;
    } else {
      // Otherwise, go back to previous page
      Get.back();
    }
  }
}
