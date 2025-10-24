import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/review_model.dart';
import '../../../data/models/booking_model.dart' as booking_model;
import '../../../data/services/review_service.dart';

class ReviewController extends GetxController {
  final ReviewService _reviewService = ReviewService();

  // Observable variables
  final _isLoadingList = false.obs;
  final _isSubmitting = false.obs;
  final _myReviews = <Review>[].obs;
  final _currentPage = 1.obs;
  final _totalPages = 1.obs;
  final _hasMore = false.obs;

  // Getters
  bool get isLoadingList => _isLoadingList.value;
  bool get isSubmitting => _isSubmitting.value;
  List<Review> get myReviews => _myReviews;
  bool get hasMore => _hasMore.value;

  @override
  void onInit() {
    super.onInit();
    loadMyReviews();
  }

  Future<void> loadMyReviews({bool refresh = false}) async {
    if (refresh) {
      _currentPage.value = 1;
    }

    try {
      _isLoadingList.value = true;
      final response = await _reviewService.getMyReviews(
        page: _currentPage.value,
        limit: 10,
      );

      if (response.isSuccess && response.data != null) {
        final myReviewsResponse = response.data!;

        if (myReviewsResponse.reviews != null) {
          if (refresh) {
            _myReviews.value = myReviewsResponse.reviews!;
          } else {
            _myReviews.addAll(myReviewsResponse.reviews!);
          }
        }

        if (myReviewsResponse.pagination != null) {
          _totalPages.value = myReviewsResponse.pagination!.total ?? 1;
          _hasMore.value = myReviewsResponse.pagination!.hasNext ?? false;
        }
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to load reviews',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E1E1E),
          colorText: const Color(0xFFE53E3E),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFE53E3E),
      );
    } finally {
      _isLoadingList.value = false;
    }
  }

  Future<void> loadMore() async {
    if (_isLoadingList.value || !_hasMore.value) return;
    _currentPage.value++;
    await loadMyReviews();
  }

  Future<void> refresh() async {
    await loadMyReviews(refresh: true);
  }

  Future<void> submitReview({
    required booking_model.Booking booking,
    required Map<String, int> ratings,
    required String content,
    String? title,
    List<String>? pros,
    List<String>? cons,
    List<String>? tags,
  }) async {
    if (booking.id == null) {
      Get.snackbar(
        'Error',
        'Invalid booking',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFE53E3E),
      );
      return;
    }

    try {
      _isSubmitting.value = true;
      final response = await _reviewService.createReview(
        bookingId: booking.id!,
        ratings: ratings,
        content: content,
        title: title,
        pros: pros,
        cons: cons,
        tags: tags,
      );

      if (response.isSuccess) {
        // Show success dialog
        Get.dialog(
          Dialog(
            backgroundColor: const Color(0xFF1A1A1A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xFF4CAF50),
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Review Submitted!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Thank you for sharing your feedback',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF808080), fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // Close dialog
                        Get.back(
                          result: true,
                        ); // Close review form with success flag
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Color(0xFF0A0A0A),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
        await loadMyReviews(refresh: true); // Refresh list
      } else {
        // Extract error message with specific handling
        String errorMessage = 'Failed to submit review';
        String errorTitle = 'Error';

        if (response.error != null) {
          errorMessage = response.error!;

          // Handle specific error cases
          if (errorMessage.toLowerCase().contains('already reviewed') ||
              errorMessage.toLowerCase().contains('review already exists')) {
            errorTitle = 'Already Reviewed';
            errorMessage =
                'You have already submitted a review for this booking.';
          } else if (errorMessage.toLowerCase().contains('not completed')) {
            errorTitle = 'Booking Not Completed';
            errorMessage = 'You can only review completed bookings.';
          }
        }

        Get.snackbar(
          errorTitle,
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E1E1E),
          colorText: const Color(0xFFE53E3E),
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFE53E3E),
      );
    } finally {
      _isSubmitting.value = false;
    }
  }

  void viewReviewDetails(Review review) {
    // TODO: Navigate to review details page
    Get.snackbar(
      'Review Details',
      review.reviewId ?? 'Review',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E1E1E),
      colorText: const Color(0xFFE0E0E0),
    );
  }
}
