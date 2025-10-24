import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/store_model.dart' hide Duration;
import '../../../data/models/service_model.dart' as service_model;
import '../../../data/models/therapist_model.dart';
import '../../../data/services/booking_service.dart';
import '../../home/controllers/home_controller.dart';
import '../../main_navigation/main_navigation_view.dart';
import '../../main_navigation/main_navigation_binding.dart';
import '../../main_navigation/main_navigation_controller.dart';
import '../../../../l10n/app_localizations.dart';

class BookingCreateController extends GetxController {
  final BookingService _bookingService = BookingService();

  final _isLoading = false.obs;
  final _pressure = 'medium'.obs;
  final _focusAreas = <String>[].obs;
  final _notes = ''.obs;
  final _voucherCode = ''.obs;
  final _paymentMethod = 'wallet'.obs; // Default to wallet
  final _walletBalance = 0.0.obs;

  bool get isLoading => _isLoading.value;
  String get pressure => _pressure.value;
  List<String> get focusAreas => _focusAreas;
  String get notes => _notes.value;
  String get voucherCode => _voucherCode.value;
  String get paymentMethod => _paymentMethod.value;
  double get walletBalance => _walletBalance.value;

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

    // Load wallet balance
    _loadWalletBalance();
  }

  Future<void> _loadWalletBalance() async {
    try {
      final homeController = Get.find<HomeController>();
      _walletBalance.value = homeController.walletBalance;
    } catch (e) {
      print('⚠️ Could not load wallet balance: $e');
      _walletBalance.value = 0.0;
    }
  }

  void setPaymentMethod(String method) {
    _paymentMethod.value = method;
  }

  void _showInsufficientBalanceDialog() {
    final l10n = AppLocalizations.of(Get.context!)!;
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: Colors.red,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.insufficientWalletBalance,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE0E0E0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.insufficientWalletBalanceMessage,
                style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2A2A2A)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        l10n.cancel,
                        style: const TextStyle(color: Color(0xFFE0E0E0)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.toNamed('/wallet-topup');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        l10n.topUpWallet,
                        style: const TextStyle(color: Colors.black),
                      ),
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

  void _showBookingSuccessDialog() {
    final l10n = AppLocalizations.of(Get.context!)!;
    final servicePrice = service?.pricing?.price ?? 0.0;
    final isWalletPayment = paymentMethod == 'wallet';

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              Text(
                l10n.bookingConfirmedTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE0E0E0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                isWalletPayment
                    ? l10n.paymentSuccessful
                    : l10n.bookingConfirmedCash(
                        servicePrice.toStringAsFixed(2),
                      ),
                style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
                textAlign: TextAlign.center,
              ),
              if (!isWalletPayment) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.orange,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.paymentCollectedAtLocation,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // Close dialog
                    // Navigate back to MainNavigationView with bookings tab
                    Get.offAll(
                      () => const MainNavigationView(),
                      binding: MainNavigationBinding(),
                    );
                    // Switch to bookings tab (index 1)
                    Future.delayed(const Duration(milliseconds: 100), () {
                      try {
                        final navController =
                            Get.find<MainNavigationController>();
                        navController.changePage(1);
                      } catch (e) {
                        print('⚠️ Could not switch to bookings tab: $e');
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    l10n.ok,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
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
    if (service == null ||
        selectedDate == null ||
        selectedTime == null ||
        therapistId == null ||
        paymentMethod.isEmpty) {
      final l10n = AppLocalizations.of(Get.context!)!;

      print('❌ Missing booking information:');
      print('   service: ${service != null ? "✓" : "✗"}');
      print('   selectedDate: ${selectedDate != null ? "✓" : "✗"}');
      print('   selectedTime: ${selectedTime != null ? "✓" : "✗"}');
      print('   therapistId: ${therapistId != null ? "✓" : "✗"}');
      print('   paymentMethod: ${paymentMethod.isNotEmpty ? "✓" : "✗"}');

      Get.snackbar(
        l10n.error,
        l10n.missingBookingInfo,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    // Check wallet balance if wallet payment is selected
    if (_paymentMethod.value == 'wallet') {
      final servicePrice = service?.pricing?.price ?? 0.0;
      if (_walletBalance.value < servicePrice) {
        _showInsufficientBalanceDialog();
        return;
      }
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
      paymentMethod: _paymentMethod.value, // Use selected payment method
      voucherCode: _voucherCode.value.isNotEmpty ? _voucherCode.value : null,
      preferences: preferences,
      notes: _notes.value.isNotEmpty ? _notes.value : null,
    );

    _isLoading.value = false;

    if (response.isSuccess && response.data != null) {
      print('✅ Booking created successfully: ${response.data!.id}');

      _showBookingSuccessDialog();
    } else {
      print('❌ Booking failed: ${response.error}');
      _showBookingErrorDialog(response.error);
    }
  }

  void _showBookingErrorDialog(String errorType) {
    final l10n = AppLocalizations.of(Get.context!)!;
    String title;
    String message;
    String actionButtonText = l10n.ok;
    VoidCallback? onActionPressed;

    switch (errorType) {
      case 'insufficient_balance':
        title = l10n.insufficientWalletBalance;
        message = l10n.insufficientWalletBalanceMessage;
        actionButtonText = l10n.topUpWallet;
        onActionPressed = () {
          Get.back();
          Get.toNamed('/wallet-topup');
        };
        break;
      case 'invalid_payment_method':
        title = l10n.invalidPaymentMethod;
        message = l10n.invalidPaymentMethodMessage;
        break;
      case 'invalid_information':
        title = l10n.invalidInformation;
        message = l10n.invalidInformationMessage;
        break;
      default:
        title = l10n.bookingFailed;
        message = l10n.failedToCreateBooking;
    }

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE0E0E0),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  if (onActionPressed != null) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF2A2A2A)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          l10n.cancel,
                          style: const TextStyle(color: Color(0xFFE0E0E0)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onActionPressed ?? () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        actionButtonText,
                        style: const TextStyle(color: Colors.black),
                      ),
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
}
