import '../models/review_model.dart';
import '../services/review_service.dart';
import '../services/base_services.dart';

class ReviewRepository {
  final ReviewService _reviewService = ReviewService();

  Future<MyResponse<Review?, dynamic>> createReview({
    required String bookingId,
    required Map<String, int> ratings,
    required String content,
    String? title,
    List<String>? pros,
    List<String>? cons,
    List<String>? tags,
  }) async {
    return await _reviewService.createReview(
      bookingId: bookingId,
      ratings: ratings,
      content: content,
      title: title,
      pros: pros,
      cons: cons,
      tags: tags,
    );
  }

  Future<MyResponse<MyReviewsResponse?, dynamic>> getMyReviews({
    int page = 1,
    int limit = 10,
  }) async {
    return await _reviewService.getMyReviews(page: page, limit: limit);
  }

  Future<MyResponse<TherapistReviewsResponse?, dynamic>> getTherapistReviews({
    required String therapistId,
    int? rating,
    String sortBy = 'recent',
    int page = 1,
    int limit = 10,
  }) async {
    return await _reviewService.getTherapistReviews(
      therapistId: therapistId,
      rating: rating,
      sortBy: sortBy,
      page: page,
      limit: limit,
    );
  }

  Future<MyResponse<Review?, dynamic>> getReviewDetails(String reviewId) async {
    return await _reviewService.getReviewDetails(reviewId);
  }

  Future<MyResponse<Review?, dynamic>> updateReview({
    required String reviewId,
    Map<String, int>? ratings,
    String? title,
    String? content,
    List<String>? pros,
    List<String>? cons,
    List<String>? tags,
  }) async {
    return await _reviewService.updateReview(
      reviewId: reviewId,
      ratings: ratings,
      title: title,
      content: content,
      pros: pros,
      cons: cons,
      tags: tags,
    );
  }

  Future<MyResponse<Map<String, dynamic>?, dynamic>> markAsHelpful(
    String reviewId,
  ) async {
    return await _reviewService.markAsHelpful(reviewId);
  }
}
