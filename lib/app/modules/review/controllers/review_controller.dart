import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/review_model.dart';
import '../../../data/models/booking_model.dart' as booking_model;
import '../../../data/services/review_service.dart';

class ReviewController extends GetxController {
  final ReviewService _reviewService = ReviewService();

  // Observable variables
  final _isLoading = false.obs;
  final _myReviews = <Review>[].obs;
  final _currentPage = 1.obs;
  final _totalPages = 1.obs;
  final _hasMore = false.obs;

  // Getters
  bool get isLoading => _isLoading.value;
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
      _isLoading.value = true;
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
      _isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (_isLoading.value || !_hasMore.value) return;
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
      _isLoading.value = true;
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
        Get.snackbar(
          'Success',
          'Review submitted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E1E1E),
          colorText: const Color(0xFF4CAF50),
        );
        Get.back(); // Close review form
        await loadMyReviews(refresh: true); // Refresh list
      } else {
        // Extract error message
        String errorMessage = 'Failed to submit review';
        if (response.error != null) {
          errorMessage = response.error!;
        }

        Get.snackbar(
          'Error',
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
      _isLoading.value = false;
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
