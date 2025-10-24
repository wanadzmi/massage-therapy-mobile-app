import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/store_detail_controller.dart';
import '../../../data/services/store_service.dart';

class StoreDetailView extends GetView<StoreDetailController> {
  const StoreDetailView({super.key});

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
        title: Obx(
          () => Text(
            controller.store?.name ?? l10n.storeDetails,
            style: const TextStyle(
              color: Color(0xFFE0E0E0),
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: Obx(
        () => controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store Header
                    if (controller.store != null) _buildStoreHeader(context),

                    const SizedBox(height: 24),

                    // Services Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        l10n.availableServices,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Services List
                    Obx(
                      () => controller.isLoadingServices
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.all(32.0),
                                child: CircularProgressIndicator(
                                  color: Color(0xFFD4AF37),
                                ),
                              ),
                            )
                          : controller.services.isEmpty
                          ? _buildEmptyState()
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: controller.services.length,
                              itemBuilder: (context, index) {
                                final service = controller.services[index];
                                return _buildServiceCard(service, context);
                              },
                            ),
                    ),

                    const SizedBox(height: 32),

                    // Reviews Section
                    _buildReviewsSection(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildStoreHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final store = controller.store!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        border: Border(bottom: BorderSide(color: Color(0xFF2A2A2A))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  store.name ?? l10n.storeName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
              ),
              if (store.rating != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFD4AF37),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        store.rating!.average?.toStringAsFixed(1) ?? '0.0',
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (store.description != null) ...[
            const SizedBox(height: 12),
            Text(
              store.description!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF808080),
                height: 1.5,
              ),
            ),
          ],
          if (store.address != null) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 18,
                  color: Color(0xFF808080),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${store.address!.street}, ${store.address!.city}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF808080),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildServiceCard(service, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () => controller.navigateToServiceBooking(service),
      child: Container(
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name ?? l10n.serviceName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                      if (service.category != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          service.category!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (service.pricing?.discountPrice != null)
                      Text(
                        controller.formatPrice(
                          service.pricing!.price,
                          service.pricing!.currency,
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF606060),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    Text(
                      controller.formatPrice(
                        service.pricing?.finalPrice,
                        service.pricing?.currency,
                      ),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (service.description != null) ...[
              const SizedBox(height: 12),
              Text(
                service.description!,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF808080),
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                if (service.duration?.minutes != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0A0A),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF2A2A2A)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Color(0xFF808080),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          controller.formatDuration(service.duration!.minutes),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    l10n.bookNow,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
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

  Widget _buildEmptyState() {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF2A2A2A)),
                  ),
                  child: const Icon(
                    Icons.spa_outlined,
                    size: 48,
                    color: Color(0xFF505050),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.noServicesAvailable,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF808080),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewsSection() {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Obx(() {
          final stats = controller.reviewStats;
          final reviews = controller.recentReviews;

          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.reviewsAndRatings,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                    if (stats != null &&
                        stats.totalReviews != null &&
                        stats.totalReviews! > 0)
                      Text(
                        l10n.reviewsCount(stats.totalReviews!),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF808080),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Rating Summary
                if (stats != null) _buildRatingSummary(stats, context),

                const SizedBox(height: 24),

                // Recent Reviews
                if (controller.isLoadingReviews)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator(
                        color: Color(0xFFD4AF37),
                      ),
                    ),
                  )
                else if (reviews.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.rate_review_outlined,
                            size: 48,
                            color: Color(0xFF505050),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noReviewsYetStore,
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF808080),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      Text(
                        l10n.recentReviews,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...reviews
                          .take(10)
                          .map((review) => _buildReviewCard(review, context)),
                    ],
                  ),
              ],
            ),
          );
        });
      },
    );
  }

  Widget _buildRatingSummary(ReviewStatistics stats, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Row(
        children: [
          // Overall Rating
          Column(
            children: [
              Text(
                stats.averageRating?.toStringAsFixed(1) ?? '0.0',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFD4AF37),
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < (stats.averageRating ?? 0).floor()
                        ? Icons.star
                        : Icons.star_border,
                    color: const Color(0xFFD4AF37),
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(
                  context,
                )!.reviewsCount(stats.totalReviews ?? 0),
                style: const TextStyle(fontSize: 12, color: Color(0xFF808080)),
              ),
            ],
          ),

          const SizedBox(width: 32),

          // Rating Breakdown
          Expanded(
            child: Column(
              children: [
                _buildRatingBar(
                  5,
                  stats.ratingDistribution?['5'] ?? 0,
                  stats.totalReviews ?? 1,
                ),
                _buildRatingBar(
                  4,
                  stats.ratingDistribution?['4'] ?? 0,
                  stats.totalReviews ?? 1,
                ),
                _buildRatingBar(
                  3,
                  stats.ratingDistribution?['3'] ?? 0,
                  stats.totalReviews ?? 1,
                ),
                _buildRatingBar(
                  2,
                  stats.ratingDistribution?['2'] ?? 0,
                  stats.totalReviews ?? 1,
                ),
                _buildRatingBar(
                  1,
                  stats.ratingDistribution?['1'] ?? 0,
                  stats.totalReviews ?? 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int stars, int count, int total) {
    final percentage = total > 0 ? (count / total) : 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$stars',
            style: const TextStyle(fontSize: 12, color: Color(0xFF808080)),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.star, size: 12, color: Color(0xFFD4AF37)),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percentage,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 30,
            child: Text(
              '$count',
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 12, color: Color(0xFF808080)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(review, BuildContext context) {
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
          // User Info
          Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF808080),
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              // Name and Tier
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.user?.name ?? 'Anonymous',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                        if (review.user?.memberTier != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFD4AF37,
                              ).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              review.user!.memberTier!,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFD4AF37),
                              ),
                            ),
                          ),
                        ],
                        if (review.isVerified == true) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            size: 14,
                            color: Color(0xFF4CAF50),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      controller.formatTimeAgo(review.createdAt),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF606060),
                      ),
                    ),
                  ],
                ),
              ),

              // Rating
              Row(
                children: [
                  const Icon(Icons.star, color: Color(0xFFD4AF37), size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${review.ratings?.overall ?? 0}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Review Title
          if (review.review?.title != null) ...[
            Text(
              review.review!.title!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE0E0E0),
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Review Content
          if (review.review?.content != null)
            Text(
              review.review!.content!,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF808080),
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

          // Pros
          if (review.review?.pros != null &&
              review.review!.pros!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: review.review!.pros!.map<Widget>((pro) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 12,
                        color: Color(0xFF4CAF50),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        pro,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],

          // Cons
          if (review.review?.cons != null &&
              review.review!.cons!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: review.review!.cons!.map<Widget>((con) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9800).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: const Color(0xFFFF9800).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_amber,
                        size: 12,
                        color: Color(0xFFFF9800),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        con,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFFF9800),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],

          // Helpful Count
          if (review.helpful?.count != null && review.helpful!.count! > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.thumb_up_outlined,
                  size: 14,
                  color: Color(0xFF606060),
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.foundThisHelpful(review.helpful!.count!),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF606060),
                  ),
                ),
              ],
            ),
          ],

          // Store Response
          if (review.response != null && review.response!.content != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.store,
                        size: 14,
                        color: Color(0xFFD4AF37),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.storeResponse,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFD4AF37),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        controller.formatTimeAgo(review.response!.respondedAt),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF606060),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    review.response!.content!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF808080),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
