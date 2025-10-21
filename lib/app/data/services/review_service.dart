import '../models/review_model.dart';
import 'base_services.dart';

class ReviewService extends BaseServices {
  final String _reviewsEndpoint = '/api/reviews';

  /// Create a new review
  Future<MyResponse<Review?, dynamic>> createReview({
    required String bookingId,
    required Map<String, int> ratings,
    required String content,
    String? title,
    List<String>? pros,
    List<String>? cons,
    List<String>? tags,
  }) async {
    final response = await callAPI(
      HttpRequestType.POST,
      _reviewsEndpoint,
      postBody: {
        'bookingId': bookingId,
        'ratings': ratings,
        'review': {
          'content': content,
          if (title != null) 'title': title,
          if (pros != null && pros.isNotEmpty) 'pros': pros,
          if (cons != null && cons.isNotEmpty) 'cons': cons,
        },
        if (tags != null && tags.isNotEmpty) 'tags': tags,
      },
    );

    if (response.isSuccess && response.data != null) {
      try {
        final reviewData = response.data['data'] ?? response.data;
        final review = Review.fromJson(reviewData);
        return MyResponse.complete(review);
      } catch (e) {
        return MyResponse.error('Failed to parse review data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get user's reviews
  Future<MyResponse<MyReviewsResponse?, dynamic>> getMyReviews({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_reviewsEndpoint/user?page=$page&limit=$limit',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final myReviewsResponse = MyReviewsResponse.fromJson(response.data);
        return MyResponse.complete(myReviewsResponse);
      } catch (e) {
        return MyResponse.error('Failed to parse reviews data: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get therapist reviews
  Future<MyResponse<TherapistReviewsResponse?, dynamic>> getTherapistReviews({
    required String therapistId,
    int? rating,
    String sortBy = 'recent',
    int page = 1,
    int limit = 10,
  }) async {
    String queryParams = 'page=$page&limit=$limit&sortBy=$sortBy';
    if (rating != null) {
      queryParams += '&rating=$rating';
    }

    final response = await callAPI(
      HttpRequestType.GET,
      '$_reviewsEndpoint/therapist/$therapistId?$queryParams',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final therapistReviewsResponse = TherapistReviewsResponse.fromJson(
          response.data,
        );
        return MyResponse.complete(therapistReviewsResponse);
      } catch (e) {
        return MyResponse.error('Failed to parse therapist reviews: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get review details
  Future<MyResponse<Review?, dynamic>> getReviewDetails(String reviewId) async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_reviewsEndpoint/$reviewId',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final reviewData = response.data['data'] ?? response.data;
        final review = Review.fromJson(reviewData);
        return MyResponse.complete(review);
      } catch (e) {
        return MyResponse.error('Failed to parse review details: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Update review
  Future<MyResponse<Review?, dynamic>> updateReview({
    required String reviewId,
    Map<String, int>? ratings,
    String? title,
    String? content,
    List<String>? pros,
    List<String>? cons,
    List<String>? tags,
  }) async {
    final Map<String, dynamic> updateData = {};

    if (ratings != null) {
      updateData['ratings'] = ratings;
    }

    if (title != null || content != null || pros != null || cons != null) {
      updateData['review'] = {};
      if (title != null) updateData['review']['title'] = title;
      if (content != null) updateData['review']['content'] = content;
      if (pros != null) updateData['review']['pros'] = pros;
      if (cons != null) updateData['review']['cons'] = cons;
    }

    if (tags != null) {
      updateData['tags'] = tags;
    }

    final response = await callAPI(
      HttpRequestType.PUT,
      '$_reviewsEndpoint/$reviewId',
      postBody: updateData,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final reviewData = response.data['data'] ?? response.data;
        final review = Review.fromJson(reviewData);
        return MyResponse.complete(review);
      } catch (e) {
        return MyResponse.error('Failed to parse updated review: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Mark review as helpful
  Future<MyResponse<Map<String, dynamic>?, dynamic>> markAsHelpful(
    String reviewId,
  ) async {
    final response = await callAPI(
      HttpRequestType.POST,
      '$_reviewsEndpoint/$reviewId/helpful',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        return MyResponse.complete(data);
      } catch (e) {
        return MyResponse.error('Failed to mark as helpful: $e');
      }
    }

    return MyResponse.error(response.error);
  }
}

/// Response model for my reviews
class MyReviewsResponse {
  final List<Review>? reviews;
  final ReviewPagination? pagination;

  MyReviewsResponse({this.reviews, this.pagination});

  factory MyReviewsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return MyReviewsResponse(
      reviews: data['reviews'] != null
          ? (data['reviews'] as List).map((r) => Review.fromJson(r)).toList()
          : null,
      pagination: data['pagination'] != null
          ? ReviewPagination.fromJson(data['pagination'])
          : null,
    );
  }
}

/// Response model for therapist reviews
class TherapistReviewsResponse {
  final List<Review>? reviews;
  final ReviewStatistics? statistics;
  final ReviewPagination? pagination;

  TherapistReviewsResponse({this.reviews, this.statistics, this.pagination});

  factory TherapistReviewsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;

    return TherapistReviewsResponse(
      reviews: data['reviews'] != null
          ? (data['reviews'] as List).map((r) => Review.fromJson(r)).toList()
          : null,
      statistics: data['statistics'] != null
          ? ReviewStatistics.fromJson(data['statistics'])
          : null,
      pagination: data['pagination'] != null
          ? ReviewPagination.fromJson(data['pagination'])
          : null,
    );
  }
}

class ReviewStatistics {
  final double? avgOverall;
  final double? avgTechnique;
  final double? avgProfessionalism;
  final double? avgCleanliness;
  final double? avgComfort;
  final double? avgValueForMoney;
  final int? totalReviews;
  final Map<String, int>? ratingDistribution;

  ReviewStatistics({
    this.avgOverall,
    this.avgTechnique,
    this.avgProfessionalism,
    this.avgCleanliness,
    this.avgComfort,
    this.avgValueForMoney,
    this.totalReviews,
    this.ratingDistribution,
  });

  factory ReviewStatistics.fromJson(Map<String, dynamic> json) {
    return ReviewStatistics(
      avgOverall: json['avgOverall']?.toDouble(),
      avgTechnique: json['avgTechnique']?.toDouble(),
      avgProfessionalism: json['avgProfessionalism']?.toDouble(),
      avgCleanliness: json['avgCleanliness']?.toDouble(),
      avgComfort: json['avgComfort']?.toDouble(),
      avgValueForMoney: json['avgValueForMoney']?.toDouble(),
      totalReviews: json['totalReviews'],
      ratingDistribution: json['ratingDistribution'] != null
          ? Map<String, int>.from(json['ratingDistribution'])
          : null,
    );
  }
}

class ReviewPagination {
  final int? current;
  final int? total;
  final int? limit;
  final int? totalReviews;
  final bool? hasNext;
  final bool? hasPrev;

  ReviewPagination({
    this.current,
    this.total,
    this.limit,
    this.totalReviews,
    this.hasNext,
    this.hasPrev,
  });

  factory ReviewPagination.fromJson(Map<String, dynamic> json) {
    return ReviewPagination(
      current: json['current'] ?? json['currentPage'],
      total: json['total'] ?? json['totalPages'],
      limit: json['limit'],
      totalReviews: json['totalReviews'],
      hasNext: json['hasNext'],
      hasPrev: json['hasPrev'],
    );
  }
}
