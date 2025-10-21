import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/tier_detail_controller.dart';
import '../../../data/services/tier_service.dart';

class TierDetailView extends GetView<TierDetailController> {
  const TierDetailView({super.key});

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
        title: const Text(
          'My Subscription',
          style: TextStyle(
            color: Color(0xFFE0E0E0),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
        () => controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
              )
            : controller.currentTierData == null
            ? _buildEmptyState()
            : RefreshIndicator(
                color: const Color(0xFFD4AF37),
                backgroundColor: const Color(0xFF1A1A1A),
                onRefresh: () async {
                  await controller.loadCurrentTier();
                  await controller.loadHistory();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTierInfoCard(),
                      const SizedBox(height: 16),
                      _buildSubscriptionCard(),
                      const SizedBox(height: 16),
                      _buildBenefitsCard(),
                      const SizedBox(height: 16),
                      _buildActionsCard(),
                      const SizedBox(height: 24),
                      _buildHistorySection(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.workspace_premium_outlined,
            size: 80,
            color: Colors.grey.shade700,
          ),
          const SizedBox(height: 16),
          const Text(
            'No Active Subscription',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF808080),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Subscribe to a tier to unlock exclusive benefits',
            style: TextStyle(fontSize: 14, color: Color(0xFF606060)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Browse Tiers'),
          ),
        ],
      ),
    );
  }

  Widget _buildTierInfoCard() {
    final tier = controller.currentTierData!;
    final tierColor = _getTierColor(tier.tier);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tierColor.withOpacity(0.3), width: 2),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: tierColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.workspace_premium, size: 48, color: tierColor),
          ),
          const SizedBox(height: 16),
          Text(
            tier.name,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: tierColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            tier.description,
            style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
            textAlign: TextAlign.center,
          ),
          if (tier.memberSince != null) ...[
            const SizedBox(height: 12),
            Text(
              'Member since ${controller.formatDate(tier.memberSince!)}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF606060)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard() {
    final tier = controller.currentTierData!;
    final subscription = tier.subscription;

    if (subscription == null) {
      return const SizedBox.shrink();
    }

    final isActive = subscription.status == 'active';
    final isCancelled = subscription.status == 'cancelled';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subscription Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF4CAF50).withOpacity(0.2)
                      : isCancelled
                      ? Colors.orange.withOpacity(0.2)
                      : Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subscription.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isActive
                        ? const Color(0xFF4CAF50)
                        : isCancelled
                        ? Colors.orange
                        : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Started',
            controller.formatDate(subscription.subscribedAt),
            Icons.calendar_today,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            'Expires',
            controller.formatDate(subscription.expiresAt),
            Icons.event,
          ),
          if (subscription.lastRenewedAt != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              'Last Renewed',
              controller.formatDate(subscription.lastRenewedAt!),
              Icons.autorenew,
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Auto-Renewal',
                style: TextStyle(fontSize: 14, color: Color(0xFF808080)),
              ),
              Obx(
                () => Switch(
                  value:
                      controller.currentTierData?.subscription?.autoRenew ??
                      false,
                  onChanged: (value) => controller.toggleAutoRenew(value),
                  activeColor: const Color(0xFFD4AF37),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF606060)),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF808080)),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFFE0E0E0),
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitsCard() {
    final tier = controller.currentTierData!;
    final benefits = tier.benefits;

    if (benefits == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Benefits',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE0E0E0),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFD4AF37).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.card_giftcard,
                  color: Color(0xFFD4AF37),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  '${benefits.cashbackPercentage}% Cashback on All Bookings',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFD4AF37),
                  ),
                ),
              ],
            ),
          ),
          if (benefits.features != null && benefits.features!.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...benefits.features!.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 18,
                      color: Color(0xFF4CAF50),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFE0E0E0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionsCard() {
    final subscription = controller.currentTierData?.subscription;
    if (subscription == null) return const SizedBox.shrink();

    final isActive = subscription.status == 'active';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE0E0E0),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => controller.renewSubscription(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.autorenew, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Renew Now',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          if (isActive) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => controller.cancelSubscription(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cancel_outlined, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Cancel Subscription',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Transaction History',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFFE0E0E0),
            ),
          ),
          const SizedBox(height: 12),
          if (controller.transactions.isEmpty)
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long_outlined,
                      size: 48,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'No transactions yet',
                      style: TextStyle(fontSize: 14, color: Color(0xFF808080)),
                    ),
                  ],
                ),
              ),
            )
          else
            ...controller.transactions.map(
              (tx) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildTransactionCard(tx),
              ),
            ),
          if (controller.hasMorePages) ...[
            const SizedBox(height: 12),
            Center(
              child: OutlinedButton(
                onPressed: controller.isLoadingMore
                    ? null
                    : () => controller.loadHistory(loadMore: true),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD4AF37),
                  side: const BorderSide(color: Color(0xFF2A2A2A)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: controller.isLoadingMore
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFFD4AF37),
                        ),
                      )
                    : const Text('Load More'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionCard(TierTransaction tx) {
    final isDebit = tx.direction == 'debit';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  tx.description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
              ),
              Text(
                '${isDebit ? '-' : '+'}RM ${tx.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDebit ? Colors.red : const Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.formatDateTime(tx.createdAt),
                style: const TextStyle(fontSize: 12, color: Color(0xFF606060)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: tx.status == 'completed'
                      ? const Color(0xFF4CAF50).withOpacity(0.2)
                      : Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tx.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: tx.status == 'completed'
                        ? const Color(0xFF4CAF50)
                        : Colors.orange,
                  ),
                ),
              ),
            ],
          ),
        ],
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
