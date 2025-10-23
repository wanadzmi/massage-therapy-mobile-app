import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/services/booking_service.dart' as service;
import '../data/models/booking_model.dart';

class CashCollectionDialog extends StatefulWidget {
  final Booking booking;
  final VoidCallback? onSuccess;

  const CashCollectionDialog({
    super.key,
    required this.booking,
    this.onSuccess,
  });

  @override
  State<CashCollectionDialog> createState() => _CashCollectionDialogState();
}

class _CashCollectionDialogState extends State<CashCollectionDialog> {
  final service.BookingService _bookingService = service.BookingService();
  bool _isProcessing = false;

  Future<void> _markCashReceived() async {
    if (_isProcessing) return;

    setState(() => _isProcessing = true);

    try {
      final response = await _bookingService.markCashReceived(
        widget.booking.id!,
      );

      if (response.isSuccess) {
        // Close the dialog
        Get.back();

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
                    'Cash Received!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Payment has been marked as received.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Color(0xFF808080)),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        widget.onSuccess?.call();
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
          response.error ?? 'Failed to mark cash as received',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
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
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final amount =
        widget.booking.pricing?.totalAmount ??
        widget.booking.paymentInfo?.amount ??
        0.0;

    return Dialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9800).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFFF9800).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.payments,
                size: 48,
                color: Color(0xFFFF9800),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Cash Collection',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE0E0E0),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.booking.bookingCode ?? 'Booking',
              style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
            ),
            const SizedBox(height: 24),
            // Amount Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFF9800).withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'Amount to Collect',
                    style: TextStyle(fontSize: 12, color: Color(0xFF808080)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'RM ${amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9800),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Customer Info
            if (widget.booking.userName != null) ...[
              Row(
                children: [
                  const Icon(Icons.person, size: 16, color: Color(0xFF808080)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.booking.userName!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            if (widget.booking.service?.name != null) ...[
              Row(
                children: [
                  const Icon(Icons.spa, size: 16, color: Color(0xFF808080)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.booking.service!.name!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
            const Text(
              'Confirm that you have received the cash payment from the customer.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF808080)),
            ),
            const SizedBox(height: 24),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isProcessing ? null : () => Get.back(),
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
                    onPressed: _isProcessing ? null : _markCashReceived,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFF2A2A2A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
