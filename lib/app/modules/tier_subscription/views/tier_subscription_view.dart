import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/tier_subscription_controller.dart';
import '../../../data/services/tier_service.dart';

class TierSubscriptionView extends GetView<TierSubscriptionController> {
  const TierSubscriptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFE0E0E0)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppLocalizations.of(context)!.membershipTiers,
          style: const TextStyle(
            color: Color(0xFFE0E0E0),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (controller.currentTier != null &&
              controller.currentTier != 'normal')
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0xFFD4AF37),
                  size: 18,
                ),
              ),
              onPressed: () => controller.viewCurrentTier(),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(
        () => controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
              )
            : RefreshIndicator(
                color: const Color(0xFFD4AF37),
                backgroundColor: const Color(0xFF1A1A1A),
                onRefresh: controller.loadTiers,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Info
                      _buildHeaderInfo(context),
                      const SizedBox(height: 24),

                      // Tier Cards
                      ...controller.tiers.map(
                        (tier) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildTierCard(context, tier),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildHeaderInfo(BuildContext context) {
    return Obx(
      () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.workspace_premium,
                color: Color(0xFFD4AF37),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.currentTier,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF808080),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.currentTier?.toUpperCase() ?? 'NORMAL',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${AppLocalizations.of(context)!.wallet}: RM ${controller.currentBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF606060),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierCard(BuildContext context, TierInfo tier) {
    final bool isCurrent = tier.isCurrent;
    final Color tierColor = _getTierColor(tier.tier);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrent
              ? tierColor.withValues(alpha: 0.5)
              : const Color(0xFF2A2A2A),
          width: isCurrent ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: tierColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              tier.name,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: tierColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isCurrent) ...[
                            if (isCurrent) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: tierColor,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.current,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tier.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF808080),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (tier.price > 0) ...[
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'RM ${tier.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: tierColor,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.perMonth,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF808080),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // Benefits
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: tierColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.card_giftcard, size: 16, color: tierColor),
                          const SizedBox(width: 6),
                          Text(
                            '${tier.benefits?.cashbackPercentage ?? 0}% ${AppLocalizations.of(context)!.cashback}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: tierColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (tier.benefits?.features != null &&
                    tier.benefits!.features!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ...tier.benefits!.features!.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, size: 16, color: tierColor),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              feature,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFFE0E0E0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                // Subscribe Button
                if (tier.tier != 'normal') ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: _buildActionButton(context, tier, tierColor),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    TierInfo tier,
    Color tierColor,
  ) {
    if (tier.isCurrent) {
      return ElevatedButton(
        onPressed: () => controller.viewCurrentTier(),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2A2A2A),
          foregroundColor: const Color(0xFFE0E0E0),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          AppLocalizations.of(context)!.viewTierDetails,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );
    }

    if (!tier.canSubscribe) {
      return ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2A2A2A),
          foregroundColor: const Color(0xFF606060),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          tier.tier == 'diamond'
              ? AppLocalizations.of(context)!.inviteOnly
              : AppLocalizations.of(context)!.notAvailable,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      );
    }

    if (!tier.hasSufficientBalance) {
      return ElevatedButton(
        onPressed: () => controller.subscribeTier(tier),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.withValues(alpha: 0.2),
          foregroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Colors.orange),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance_wallet_outlined, size: 18),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!.topUpAndSubscribe,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return ElevatedButton(
      onPressed: () => controller.subscribeTier(tier),
      style: ElevatedButton.styleFrom(
        backgroundColor: tierColor,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        tier.canUpgrade
            ? AppLocalizations.of(context)!.upgradeNow
            : AppLocalizations.of(context)!.subscribe,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }

  Color _getTierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'diamond':
        return const Color(0xFFB9F2FF);
      case 'platinum':
        return const Color(0xFFE5E4E2);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'bronze':
      case 'normal':
      default:
        return const Color(0xFFCD7F32);
    }
  }
}
