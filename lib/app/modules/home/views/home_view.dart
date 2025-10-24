import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';

import '../controllers/home_controller.dart';
import '../../chat/views/chat_list_view.dart';
import '../../chat/bindings/chat_list_binding.dart';
import '../../../global_widgets/banner_carousel.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,

        actions: [
          // Chat Button
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Color(0xFFD4AF37),
                size: 20,
              ),
            ),
            onPressed: () {
              // Navigate to chat list
              Get.to(() => const ChatListView(), binding: ChatListBinding());
            },
          ),
          const SizedBox(width: 8),
          // Notification Button
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: const Icon(
                Icons.notifications,
                color: Color(0xFFD4AF37),
                size: 20,
              ),
            ),
            onPressed: () {
              Get.toNamed('/notifications');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Obx(
        () => controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                color: const Color(0xFFD4AF37),
                backgroundColor: const Color(0xFF1A1A1A),
                onRefresh: () async {
                  await controller.refresh();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Header
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            color: Color(0xFFE0E0E0),
                            height: 1.2,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  '${AppLocalizations.of(context)!.discover}\n',
                            ),
                            TextSpan(
                              text:
                                  '${AppLocalizations.of(context)!.wellness} ',
                              style: const TextStyle(
                                color: Color(0xFFD4AF37),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: AppLocalizations.of(context)!.withUs,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Wallet Balance Card
                      Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF2A2A2A),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(
                                    context,
                                  )!.hello(controller.userName),
                                  style: const TextStyle(
                                    color: Color(0xFF808080),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFD4AF37,
                                    ).withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.account_balance_wallet,
                                        color: Color(0xFFD4AF37),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        AppLocalizations.of(context)!.wallet,
                                        style: const TextStyle(
                                          color: Color(0xFFD4AF37),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${controller.currency} ${controller.walletBalance.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Color(0xFFD4AF37),
                                fontSize: 32,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppLocalizations.of(context)!.availableBalance,
                              style: const TextStyle(
                                color: Color(0xFF606060),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildActionButton(
                                    AppLocalizations.of(context)!.topUp,
                                    Icons.add,
                                    true,
                                    () async {
                                      final result = await Get.toNamed(
                                        '/wallet-topup',
                                      );
                                      // Refresh wallet balance when returning from top-up
                                      if (result != null &&
                                          result['success'] == true) {
                                        controller.loadUserData();
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildActionButton(
                                    AppLocalizations.of(context)!.history,
                                    Icons.receipt_long,
                                    false,
                                    () async {
                                      final result = await Get.toNamed(
                                        '/transaction-history',
                                      );
                                      // Refresh if needed when returning
                                      if (result != null && result == true) {
                                        controller.loadUserData();
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Banner Carousel
                      if (controller.banners.isNotEmpty)
                        BannerCarousel(
                          banners: controller.banners,
                          onView: (bannerId) =>
                              controller.recordBannerView(bannerId),
                          onTap: (banner) =>
                              controller.handleBannerClick(banner),
                        ),
                      if (controller.banners.isNotEmpty)
                        const SizedBox(height: 32),

                      // Section Header
                      Text(
                        AppLocalizations.of(context)!.quickMenu,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFE0E0E0),
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildQuickActionCard(
                        AppLocalizations.of(context)!.findStore,
                        Icons.store,
                        Colors.blue,
                        AppLocalizations.of(context)!.discoverNearestStores,
                        () => controller.navigateToFindStore(),
                      ),
                      const SizedBox(height: 16),

                      // Commented out Find Therapist for now
                      // _buildQuickActionCard(
                      //   AppLocalizations.of(context)!.findTherapist,
                      //   Icons.home_work,
                      //   Colors.purple,
                      //   AppLocalizations.of(context)!.browseAvailableTherapists,
                      //   () => controller.navigateToFindTherapist(),
                      // ),
                      // const SizedBox(height: 16),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    String description,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Gradient overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD4AF37).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: const Color(0xFFD4AF37),
                        size: 24,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE0E0E0),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
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
              // Arrow indicator
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Color(0xFFD4AF37),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    bool isPrimary,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFFD4AF37) : const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isPrimary
                ? const Color(0xFFD4AF37)
                : const Color(0xFF2A2A2A),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary
                  ? const Color(0xFF000000)
                  : const Color(0xFF808080),
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isPrimary
                    ? const Color(0xFF000000)
                    : const Color(0xFF808080),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
