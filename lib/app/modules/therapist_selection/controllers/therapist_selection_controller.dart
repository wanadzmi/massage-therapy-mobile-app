import 'package:get/get.dart';
import '../../../data/models/store_model.dart';
import '../../../data/models/service_model.dart' as service_model;
import '../../../data/services/booking_discovery_service.dart';
import '../../../data/services/store_service.dart';
import '../../../../l10n/app_localizations.dart';

class TherapistSelectionController extends GetxController {
  final BookingDiscoveryService _bookingDiscoveryService =
      BookingDiscoveryService();

  final _isLoading = false.obs;
  final _isLoadingTherapists = false.obs;
  final _availableTherapists = <StoreTherapist>[].obs;
  final _availabilityCalendar = <DayAvailability>[].obs;
  final _selectedTherapist = Rx<StoreTherapist?>(null);
  final _selectedDate = Rx<DayAvailability?>(null);
  final _selectedSlot = Rx<SlotDetail?>(null);

  bool get isLoading => _isLoading.value;
  bool get isLoadingTherapists => _isLoadingTherapists.value;
  List<StoreTherapist> get availableTherapists => _availableTherapists;
  List<DayAvailability> get availabilityCalendar =>
      _getFilteredAvailabilityCalendar();

  // Return filtered selected date with filtered slots
  DayAvailability? get selectedDate => _selectedDate.value;
  SlotDetail? get selectedSlot => _selectedSlot.value;
  StoreTherapist? get selectedTherapist => _selectedTherapist.value;

  Store? store;
  service_model.Service? service;
  ServiceAvailabilityCalendar? calendarData;

  /// Filter availability calendar to only show slots for selected therapist
  List<DayAvailability> _getFilteredAvailabilityCalendar() {
    if (_selectedTherapist.value == null) {
      // No therapist selected yet, return empty (force selection)
      return [];
    }

    final therapistId = _selectedTherapist.value!.id;

    // Filter days that have at least one slot with the selected therapist
    return _availabilityCalendar
        .where((day) {
          final filteredSlots = _filterSlotsByTherapist(
            day.slotDetails ?? [],
            therapistId,
          );
          return filteredSlots.isNotEmpty;
        })
        .map((day) {
          final filteredSlots = _filterSlotsByTherapist(
            day.slotDetails ?? [],
            therapistId,
          );
          return DayAvailability(
            date: day.date,
            dayOfWeek: day.dayOfWeek,
            displayDate: day.displayDate,
            availableSlots: filteredSlots.map((s) => s.time ?? '').toList(),
            totalAvailableSlots: filteredSlots.length,
            slotDetails: filteredSlots,
          );
        })
        .toList();
  }

  /// Filter slots to only include the selected therapist
  List<SlotDetail> _filterSlotsByTherapist(
    List<SlotDetail> slots,
    String therapistId,
  ) {
    return slots.where((slot) {
      return slot.therapists?.any((t) => t.id == therapistId) ?? false;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      store = args['store'] as Store?;
      service = args['service'] as service_model.Service?;

      // Get therapists from store
      final storeTherapists = args['storeTherapists'] as List<dynamic>?;
      if (storeTherapists != null) {
        _availableTherapists.value = storeTherapists.cast<StoreTherapist>();
      }
    }

    // Load calendar in background but don't show until therapist selected
    loadAvailabilityCalendar();
  }

  Future<void> loadAvailabilityCalendar() async {
    if (service?.id == null) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.errorTitle,
        l10n.serviceInfoMissing,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _isLoading.value = true;

    if (store != null) {}

    final response = await _bookingDiscoveryService
        .getServiceAvailabilityCalendar(serviceId: service!.id!);

    _isLoading.value = false;

    if (response.isSuccess && response.data != null) {
      calendarData = response.data;
      _availabilityCalendar.value = response.data!.availabilityCalendar ?? [];

      if (_availabilityCalendar.isEmpty) {
        final l10n = AppLocalizations.of(Get.context!)!;
        Get.snackbar(
          l10n.noAvailability,
          l10n.noAvailableDatesMessage,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.errorTitle,
        response.error ?? l10n.failedToLoadAvailability,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void selectTherapist(StoreTherapist therapist) {
    _selectedTherapist.value = therapist;
    _selectedDate.value = null;
    _selectedSlot.value = null;
  }

  void selectDate(DayAvailability day) {
    _selectedDate.value = day;
    _selectedSlot.value = null;
  }

  void selectSlot(SlotDetail slot) {
    _selectedSlot.value = slot;
  }

  void proceedToBooking() {
    if (_selectedTherapist.value == null) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.errorTitle,
        l10n.pleaseSelectTherapist,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_selectedDate.value == null) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.errorTitle,
        l10n.pleaseSelectDate,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (_selectedSlot.value == null) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.errorTitle,
        l10n.pleaseSelectTimeSlot,
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
        'therapistId': _selectedTherapist.value!.id,
        'therapistName': _selectedTherapist.value!.name,
        'date': _selectedDate.value!.date,
        'time': _selectedSlot.value!.time,
      },
    );
  }

  void goBack() {
    if (_selectedSlot.value != null) {
      // If time slot selected, go back to date selection
      _selectedSlot.value = null;
    } else if (_selectedDate.value != null) {
      // If date selected, go back to therapist selection
      _selectedDate.value = null;
    } else if (_selectedTherapist.value != null) {
      // If therapist selected, go back to therapist list
      _selectedTherapist.value = null;
    } else {
      // Otherwise, go back to previous page
      Get.back();
    }
  }
}
