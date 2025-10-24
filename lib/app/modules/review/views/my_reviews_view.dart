import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/review_controller.dart';
import '../../../data/models/review_model.dart';
import '../../../../l10n/app_localizations.dart';

class MyReviewsView extends GetView<ReviewController> {
  const MyReviewsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE0E0E0)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          l10n.myReviews,
          style: TextStyle(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingList && controller.myReviews.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
          );
        }

        if (controller.myReviews.isEmpty) {
          return _buildEmptyState(context);
        }

        return RefreshIndicator(
          color: const Color(0xFFD4AF37),
          backgroundColor: const Color(0xFF1A1A1A),
          onRefresh: () => controller.refresh(),
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.myReviews.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.myReviews.length) {
                if (controller.hasMore) {
                  controller.loadMore();
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                  );
                }
                return const SizedBox(height: 20);
              }

              return _buildReviewCard(controller.myReviews[index], context);
            },
          ),
        );
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: const Icon(
              Icons.rate_review_outlined,
              size: 64,
              color: Color(0xFF808080),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noReviewsYet,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE0E0E0),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              l10n.reviewsWillAppearHere,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF808080)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Therapist & Service
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withOpacity(0.3),
                  ),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFFD4AF37),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.therapist?.name ?? 'Therapist',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      review.service?.name ?? 'Service',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF808080),
                      ),
                    ),
                  ],
                ),
              ),
              // Rating Stars
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < (review.ratings?.overall ?? 0)
                        ? Icons.star
                        : Icons.star_border,
                    color: const Color(0xFFD4AF37),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Review Title
          if (review.review?.title != null && review.review!.title!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                review.review!.title!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
            ),

          // Review Content
          if (review.review?.content != null &&
              review.review!.content!.isNotEmpty)
            Text(
              review.review!.content!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFB0B0B0),
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

          // Pros & Cons
          if ((review.review?.pros != null &&
                  review.review!.pros!.isNotEmpty) ||
              (review.review?.cons != null && review.review!.cons!.isNotEmpty))
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  if (review.review?.pros != null &&
                      review.review!.pros!.isNotEmpty)
                    Expanded(
                      child: _buildProConChip(
                        Icons.thumb_up,
                        review.review!.pros!.length.toString(),
                        true,
                        l10n,
                      ),
                    ),
                  if (review.review?.pros != null &&
                      review.review!.pros!.isNotEmpty &&
                      review.review?.cons != null &&
                      review.review!.cons!.isNotEmpty)
                    const SizedBox(width: 8),
                  if (review.review?.cons != null &&
                      review.review!.cons!.isNotEmpty)
                    Expanded(
                      child: _buildProConChip(
                        Icons.thumb_down,
                        review.review!.cons!.length.toString(),
                        false,
                        l10n,
                      ),
                    ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Footer: Date & Status
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 12,
                color: const Color(0xFF808080),
              ),
              const SizedBox(width: 4),
              Text(
                _formatDate(review.createdAt),
                style: const TextStyle(fontSize: 12, color: Color(0xFF808080)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(review.status).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _getStatusText(review.status, l10n),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(review.status),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProConChip(
    IconData icon,
    String count,
    bool isPositive,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isPositive
            ? const Color(0xFF4CAF50).withOpacity(0.15)
            : const Color(0xFFE53E3E).withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isPositive
                ? const Color(0xFF4CAF50)
                : const Color(0xFFE53E3E),
          ),
          const SizedBox(width: 4),
          Text(
            '$count ${isPositive ? l10n.pros : l10n.cons}',
            style: TextStyle(
              fontSize: 12,
              color: isPositive
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFE53E3E),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return const Color(0xFF4CAF50);
      case 'pending':
        return const Color(0xFFFFA500);
      case 'flagged':
      case 'rejected':
        return const Color(0xFFE53E3E);
      default:
        return const Color(0xFF808080);
    }
  }

  String _getStatusText(String? status, AppLocalizations l10n) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return l10n.approved;
      case 'pending':
        return l10n.pending;
      case 'flagged':
        return l10n.flagged;
      case 'rejected':
        return l10n.rejected;
      default:
        return status ?? l10n.pending;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
