import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/find_store_controller.dart';

class FindStoreView extends GetView<FindStoreController> {
  const FindStoreView({Key? key}) : super(key: key);

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
          l10n.findStore,
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
                Icons.filter_list,
                color: Color(0xFFD4AF37),
                size: 18,
              ),
            ),
            onPressed: () {
              // Show filter bottom sheet
              _showFilterSheet(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: TextField(
                style: const TextStyle(color: Color(0xFFE0E0E0)),
                decoration: InputDecoration(
                  hintText: 'Search stores...',
                  hintStyle: const TextStyle(color: Color(0xFF606060)),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF808080),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (value) {
                  // Debounce search
                  Future.delayed(const Duration(milliseconds: 500), () {
                    controller.onSearch(value);
                  });
                },
              ),
            ),
          ),

          // Results Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${controller.totalStores} ${controller.totalStores == 1 ? "store" : "stores"} found',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF808080),
                    ),
                  ),
                  if (controller.selectedFilters.isNotEmpty)
                    GestureDetector(
                      onTap: () => controller.clearFilters(),
                      child: const Text(
                        'Clear Filters',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Stores List
          Expanded(
            child: Obx(
              () => controller.isLoading && controller.stores.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD4AF37),
                      ),
                    )
                  : controller.stores.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF2A2A2A),
                              ),
                            ),
                            child: const Icon(
                              Icons.store_outlined,
                              size: 48,
                              color: Color(0xFF505050),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'No stores found',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF808080),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Try adjusting your filters',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF606060),
                            ),
                          ),
                        ],
                      ),
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            !controller.isLoading) {
                          controller.loadMore();
                        }
                        return false;
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        itemCount:
                            controller.stores.length +
                            (controller.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == controller.stores.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  color: Color(0xFFD4AF37),
                                ),
                              ),
                            );
                          }
                          final store = controller.stores[index];
                          return _buildStoreCard(store);
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(store) {
    return GestureDetector(
      onTap: () => controller.navigateToStoreDetail(store),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Image
            if (store.images != null && store.images!.isNotEmpty)
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Stack(
                  children: [
                    Container(
                      height: 160,
                      width: double.infinity,
                      color: const Color(0xFF2A2A2A),
                      child: const Icon(
                        Icons.store,
                        size: 48,
                        color: Color(0xFF505050),
                      ),
                    ),
                    // Status badges
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Row(
                        children: [
                          if (store.verification?.isVerified == true)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50).withOpacity(0.9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Verified',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (store.isCurrentlyOpen == true)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37).withOpacity(0.9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Open',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Store Info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store Name & Rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          store.name ?? 'Unknown Store',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFE0E0E0),
                          ),
                        ),
                      ),
                      if (store.rating != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color(0xFFD4AF37),
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                controller.formatRating(store.rating!.average),
                                style: const TextStyle(
                                  color: Color(0xFFD4AF37),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                ' (${store.rating!.count})',
                                style: const TextStyle(
                                  color: Color(0xFF808080),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Address
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Color(0xFF808080),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '${store.address?.street}, ${store.address?.city}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF808080),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Price Range & Services
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0A0A),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF2A2A2A)),
                        ),
                        child: Text(
                          controller.formatPrice(
                            store.pricing?.range?.min,
                            store.pricing?.range?.max,
                            store.pricing?.currency,
                          ),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFFD4AF37),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0A0A),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF2A2A2A)),
                        ),
                        child: Text(
                          '${store.serviceCount ?? 0} services',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Amenities
                  if (store.amenities?.available != null &&
                      store.amenities!.available!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: store.amenities!.available!
                            .take(3)
                            .map<Widget>(
                              (amenity) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A0A0A),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: const Color(0xFF2A2A2A),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _getAmenityIcon(amenity),
                                      size: 12,
                                      color: const Color(0xFF606060),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      amenity,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF606060),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
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

  IconData _getAmenityIcon(String amenity) {
    switch (amenity.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'parking':
        return Icons.local_parking;
      case 'air conditioning':
        return Icons.ac_unit;
      case 'shower facilities':
        return Icons.shower;
      case 'private rooms':
        return Icons.meeting_room;
      default:
        return Icons.check_circle_outline;
    }
  }

  void _showFilterSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE0E0E0),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF808080)),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Filter options coming soon!',
              style: TextStyle(fontSize: 14, color: Color(0xFF808080)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
