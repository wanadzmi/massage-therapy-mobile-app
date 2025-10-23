import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: const TextStyle(
            color: Color(0xFFE0E0E0),
            fontWeight: FontWeight.w500,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: Color(0xFFD4AF37),
                size: 18,
              ),
            ),
            onPressed: () => controller.editProfile(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(
        () => controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFD4AF37)),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Profile Header Card
                    _buildProfileHeader(context),

                    const SizedBox(height: 16),

                    // Stats Row
                    _buildStatsRow(context),

                    const SizedBox(height: 16),

                    // Wallet & Loyalty Points
                    _buildWalletCard(context),
                    const SizedBox(height: 12),
                    _buildTierSubscriptionCard(context),
                    const SizedBox(height: 12),
                    _buildLoyaltyCard(context),
                    const SizedBox(height: 12),
                    _buildMyReviewsCard(context),

                    const SizedBox(height: 16),

                    // Referral Card
                    _buildReferralCard(context),

                    const SizedBox(height: 32),

                    Text(
                      AppLocalizations.of(context)!.preferences,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildMenuOption(
                      AppLocalizations.of(context)!.language,
                      _getLanguageName(controller.language),
                      Icons.language_outlined,
                      () => controller.changeLanguage(),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      AppLocalizations.of(context)!.support,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF808080),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    _buildMenuOption(
                      AppLocalizations.of(context)!.termsAndPrivacy,
                      AppLocalizations.of(context)!.readTermsAndPrivacy,
                      Icons.description_outlined,
                      () {
                        Get.snackbar(
                          AppLocalizations.of(context)!.termsAndPrivacy,
                          AppLocalizations.of(context)!.termsComingSoon,
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: const Color(0xFF1E1E1E),
                          colorText: const Color(0xFFE0E0E0),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Logout Button
                    GestureDetector(
                      onTap: () => controller.logout(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.logout,
                              color: Colors.red,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.logout,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: Text(
                        '${AppLocalizations.of(context)!.version} 1.0.0',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF606060),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code.toLowerCase()) {
      case 'zh':
        return '中文';
      case 'ms':
        return 'Bahasa Melayu';
      case 'en':
      default:
        return 'English';
    }
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD4AF37), width: 2),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFD4AF37).withOpacity(0.3),
                  const Color(0xFFD4AF37).withOpacity(0.1),
                ],
              ),
            ),
            child: const Icon(Icons.person, size: 40, color: Color(0xFFD4AF37)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => Text(
                  controller.userName.isNotEmpty ? controller.userName : 'User',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE0E0E0),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getTierColor(controller.memberTier),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    controller.memberTier.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF000000),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.userEmail.isNotEmpty
                      ? controller.userEmail
                      : 'No email',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF808080),
                    letterSpacing: 0.3,
                  ),
                ),
                if (controller.isEmailVerified)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.verified,
                      color: Color(0xFFD4AF37),
                      size: 14,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.userPhone.isNotEmpty
                      ? controller.userPhone
                      : 'No phone',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF606060),
                    letterSpacing: 0.3,
                  ),
                ),
                if (controller.isPhoneVerified)
                  const Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.verified,
                      color: Color(0xFFD4AF37),
                      size: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => _buildStatCard(
              context,
              controller.totalBookings.toString(),
              AppLocalizations.of(context)!.totalBookings,
              Icons.calendar_today_outlined,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(
            () => _buildStatCard(
              context,
              controller.completedBookings.toString(),
              AppLocalizations.of(context)!.completed,
              Icons.check_circle_outline,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(
            () => _buildStatCard(
              context,
              controller.averageRating > 0
                  ? controller.averageRating.toStringAsFixed(1)
                  : '-',
              AppLocalizations.of(context)!.rating,
              Icons.star_outline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWalletCard(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () async {
          // Navigate to wallet top-up and refresh on return
          await Get.toNamed('/wallet-topup');
          // Always refresh profile after returning from wallet screen
          controller.refresh();
        },
        child: Container(
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
                  color: const Color(0xFFD4AF37).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
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
                      AppLocalizations.of(context)!.walletBalance,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF808080),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${controller.currency} ${controller.walletBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD4AF37),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add, size: 14, color: Color(0xFF000000)),
                    const SizedBox(width: 4),
                    Text(
                      AppLocalizations.of(context)!.topUp,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoyaltyCard(BuildContext context) {
    return Obx(
      () => Container(
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
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4AF37).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.stars,
                    color: Color(0xFFD4AF37),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.loyaltyPoints,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF808080),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppLocalizations.of(context)!.earnRewards,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF606060),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0A0A),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF2A2A2A)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          controller.loyaltyBalance.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.balance,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0A0A),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF2A2A2A)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          controller.loyaltyEarned.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4CAF50),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.earned,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A0A0A),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF2A2A2A)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          controller.loyaltyRedeemed.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFF9800),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.redeemed,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ],
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

  Widget _buildTierSubscriptionCard(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () async {
          // Navigate to tier subscription and refresh on return
          await Get.toNamed('/tier-subscription');
          // Refresh profile data when coming back
          controller.refresh();
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getTierColor(controller.memberTier).withOpacity(0.2),
                const Color(0xFF1A1A1A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getTierColor(controller.memberTier).withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getTierColor(controller.memberTier).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.workspace_premium,
                  color: _getTierColor(controller.memberTier),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.membershipTier,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF808080),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          controller.memberTier.toUpperCase(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: _getTierColor(controller.memberTier),
                            letterSpacing: 0.5,
                          ),
                        ),
                        if (controller.memberTier.toLowerCase() !=
                            'normal') ...[
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.star,
                            color: Color(0xFFD4AF37),
                            size: 18,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _getTierColor(controller.memberTier),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.upgrade,
                      size: 14,
                      color: Color(0xFF000000),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      controller.memberTier.toLowerCase() == 'normal'
                          ? AppLocalizations.of(context)!.upgrade
                          : AppLocalizations.of(context)!.manage,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyReviewsCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.MY_REVIEWS),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.rate_review,
                color: Color(0xFFD4AF37),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.myReviews,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    AppLocalizations.of(context)!.viewYourPastReviews,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF808080),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF808080),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralCard(BuildContext context) {
    return Obx(
      () => Container(
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
              children: [
                const Icon(
                  Icons.card_giftcard,
                  color: Color(0xFFD4AF37),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.referralCode,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF808080),
                    letterSpacing: 0.3,
                  ),
                ),
                const Spacer(),
                Text(
                  '${controller.successfulReferrals}/${controller.totalReferrals} ${AppLocalizations.of(context)!.successful}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF606060),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // Copy to clipboard
                Get.snackbar(
                  AppLocalizations.of(context)!.copied,
                  AppLocalizations.of(context)!.referralCodeCopied,
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFFD4AF37),
                  colorText: Colors.black,
                  duration: const Duration(seconds: 2),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0A0A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFD4AF37).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      controller.referralCode.isNotEmpty
                          ? controller.referralCode
                          : 'N/A',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD4AF37),
                        letterSpacing: 2,
                      ),
                    ),
                    const Icon(Icons.copy, color: Color(0xFF808080), size: 16),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0A0A),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: Column(
                children: [
                  Text(
                    '${controller.currency} ${controller.referralEarnings.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!.referralEarnings,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF808080),
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
      default:
        return const Color(0xFFCD7F32);
    }
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF808080)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFFD4AF37),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF808080)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFFD4AF37), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF808080),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF606060),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}
