import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../l10n/app_localizations.dart';
import '../controllers/find_store_controller.dart';
import '../widgets/filter_bottom_sheet.dart';

class FindStoreView extends GetView<FindStoreController> {
  const FindStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final searchController = TextEditingController();

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
          Obx(
            () => IconButton(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
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
                  if (controller.getActiveFilterCount() > 0)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFD4AF37),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          '${controller.getActiveFilterCount()}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () {
                // Show filter bottom sheet
                _showFilterSheet(context);
              },
            ),
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
                controller: searchController,
                style: const TextStyle(color: Color(0xFFE0E0E0)),
                decoration: InputDecoration(
                  hintText: l10n.searchStoresByName,
                  hintStyle: const TextStyle(color: Color(0xFF606060)),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF808080),
                  ),
                  suffixIcon: Obx(
                    () => controller.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: Color(0xFF808080),
                              size: 20,
                            ),
                            onPressed: () {
                              searchController.clear();
                              controller.onSearch('');
                            },
                          )
                        : const SizedBox.shrink(),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (value) {
                  controller.onSearch(value);
                },
              ),
            ),
          ),

          // Results Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _getResultsText(context),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF808080),
                          ),
                        ),
                      ),
                      if (controller.selectedFilters.isNotEmpty)
                        GestureDetector(
                          onTap: () => controller.clearFilters(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.filter_alt_off,
                                size: 14,
                                color: Color(0xFFD4AF37),
                              ),
                              SizedBox(width: 4),
                              Text(
                                l10n.clearAll,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFD4AF37),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  if (controller.selectedFilters.isNotEmpty &&
                      controller.totalStores > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _getFilterSummary(context),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF606060),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Active Filter Chips
          Obx(
            () => controller.selectedFilters.isNotEmpty
                ? Container(
                    margin: const EdgeInsets.only(top: 16, bottom: 16),
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: _buildActiveFilterChips(context),
                    ),
                  )
                : const SizedBox(height: 16),
          ),

          // Stores List
          Expanded(
            child: Obx(
              () => controller.isLoading && controller.stores.isEmpty
                  ? _buildSkeletonLoader()
                  : controller.hasError && controller.stores.isEmpty
                  ? _buildErrorState()
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
                            child: Icon(
                              controller.selectedFilters.isNotEmpty
                                  ? Icons.filter_alt_off_outlined
                                  : Icons.store_outlined,
                              size: 48,
                              color: const Color(0xFF505050),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            controller.selectedFilters.isNotEmpty
                                ? l10n.noStoresMatchYourFilters
                                : l10n.noStoresFound,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF808080),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            controller.selectedFilters.isNotEmpty
                                ? l10n.tryAdjustingOrClearingFilters
                                : l10n.noStoresAvailableAtTheMoment,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF606060),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (controller.selectedFilters.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () => controller.clearFilters(),
                              icon: const Icon(Icons.filter_alt_off, size: 18),
                              label: Text(l10n.clearAllFilters),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1A1A1A),
                                foregroundColor: const Color(0xFFD4AF37),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    color: Color(0xFF2A2A2A),
                                  ),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ],
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      color: const Color(0xFFD4AF37),
                      backgroundColor: const Color(0xFF1A1A1A),
                      onRefresh: () async {
                        await controller.loadStores(refresh: true);
                      },
                      child: NotificationListener<ScrollNotification>(
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
                            return _buildStoreCard(store, context);
                          },
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                height: 160,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: _buildShimmer(),
              ),
              // Content placeholder
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & rating
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 16,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2A2A2A),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: _buildShimmer(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 60,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: _buildShimmer(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Address
                    Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: _buildShimmer(),
                    ),
                    const SizedBox(height: 12),
                    // Price & services
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: _buildShimmer(),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 90,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2A2A),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: _buildShimmer(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmer() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.transparent,
                  Colors.white.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        );
      },
      onEnd: () {
        // Loop the animation
      },
    );
  }

  Widget _buildStoreCard(store, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                                color: const Color(
                                  0xFF4CAF50,
                                ).withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    l10n.verified,
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
                                color: const Color(
                                  0xFFD4AF37,
                                ).withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                l10n.openNow,
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
                          store.name ?? l10n.unknownStore,
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
                            color: const Color(
                              0xFFD4AF37,
                            ).withValues(alpha: 0.15),
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

                  // Distance (if location filter is active)
                  if (controller.getDistanceToStore(store) != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.navigation,
                            size: 14,
                            color: Color(0xFFD4AF37),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${controller.getDistanceToStore(store)} away',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFD4AF37),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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
                          '${store.services?.length ?? 0} ${(store.services?.length ?? 0) == 1 ? l10n.serviceSingular : l10n.servicesPlural}',
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

                  // Navigation Button
                  if (store.location?.coordinates != null &&
                      store.location!.coordinates!.length >= 2)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              controller.showNavigationOptions(store),
                          icon: const Icon(Icons.directions, size: 18),
                          label: Text(l10n.getDirections),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2A2A2A),
                            foregroundColor: const Color(0xFFD4AF37),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Color(0xFF3A3A3A)),
                            ),
                            elevation: 0,
                          ),
                        ),
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

  String _getResultsText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final total = controller.totalStores;
    final showing = controller.stores.length;
    final currentPage = controller.currentPage;
    final totalPages = controller.totalPages;

    if (total == 0) {
      return l10n.noStoresFound;
    } else if (showing == total) {
      return '$total ${total == 1 ? l10n.storeFoundSingular : l10n.storesFoundPlural}';
    } else {
      return l10n.showingOfStores(showing, total, currentPage, totalPages);
    }
  }

  String _getFilterSummary(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filters = controller.selectedFilters;
    final List<String> summaries = [];

    if (filters['city'] != null) {
      summaries.add(l10n.filteredLocation(filters['city']));
    }
    if (filters['useLocation'] == true) {
      summaries.add(l10n.withinRadius(filters['radius']?.toInt() ?? 10));
    }
    if (filters['rating'] != null) {
      summaries.add(l10n.minRating(filters['rating'].toString()));
    }
    if (filters['priceRange'] != null) {
      summaries.add(
        _getPriceRangeLabel(filters['priceRange'], context).toLowerCase(),
      );
    }

    if (summaries.isEmpty) return '';
    return 'Filtered: ${summaries.join(' • ')}';
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

  List<Widget> _buildActiveFilterChips(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<Widget> chips = [];
    final filters = controller.selectedFilters;

    // City filter
    if (filters['city'] != null) {
      chips.add(
        _buildActiveChip(
          label: filters['city'],
          icon: Icons.location_city,
          onRemove: () {
            final newFilters = Map<String, dynamic>.from(filters);
            newFilters.remove('city');
            newFilters.remove('area'); // Also remove area
            controller.applyFilters(newFilters);
          },
        ),
      );
      chips.add(const SizedBox(width: 8));
    }

    // Area filter
    if (filters['area'] != null) {
      chips.add(
        _buildActiveChip(
          label: filters['area'],
          icon: Icons.place,
          onRemove: () {
            final newFilters = Map<String, dynamic>.from(filters);
            newFilters.remove('area');
            controller.applyFilters(newFilters);
          },
        ),
      );
      chips.add(const SizedBox(width: 8));
    }

    // GPS Location filter
    if (filters['useLocation'] == true) {
      chips.add(
        _buildActiveChip(
          label: l10n.nearbyKm(filters['radius']?.toInt() ?? 10),
          icon: Icons.my_location,
          onRemove: () {
            final newFilters = Map<String, dynamic>.from(filters);
            newFilters.remove('useLocation');
            newFilters.remove('radius');
            controller.applyFilters(newFilters);
          },
        ),
      );
      chips.add(const SizedBox(width: 8));
    }

    // Rating filter
    if (filters['rating'] != null) {
      chips.add(
        _buildActiveChip(
          label: l10n.minRating(filters['rating'].toString()),
          onRemove: () {
            final newFilters = Map<String, dynamic>.from(filters);
            newFilters.remove('rating');
            controller.applyFilters(newFilters);
          },
        ),
      );
      chips.add(const SizedBox(width: 8));
    }

    // Price Range filter
    if (filters['priceRange'] != null) {
      final priceLabel = _getPriceRangeLabel(filters['priceRange'], context);
      chips.add(
        _buildActiveChip(
          label: priceLabel,
          icon: Icons.attach_money,
          onRemove: () {
            final newFilters = Map<String, dynamic>.from(filters);
            newFilters.remove('priceRange');
            controller.applyFilters(newFilters);
          },
        ),
      );
      chips.add(const SizedBox(width: 8));
    }

    // Amenities filters
    if (filters['amenities'] != null &&
        (filters['amenities'] as List).isNotEmpty) {
      final amenities = filters['amenities'] as List<String>;
      for (final amenity in amenities) {
        chips.add(
          _buildActiveChip(
            label: amenity,
            onRemove: () {
              final newFilters = Map<String, dynamic>.from(filters);
              final newAmenities = List<String>.from(amenities);
              newAmenities.remove(amenity);
              if (newAmenities.isEmpty) {
                newFilters.remove('amenities');
              } else {
                newFilters['amenities'] = newAmenities;
              }
              controller.applyFilters(newFilters);
            },
          ),
        );
        chips.add(const SizedBox(width: 8));
      }
    }

    // Sort filter (only show if not default)
    if (filters['sortBy'] != null && filters['sortBy'] != 'rating') {
      final sortLabel = _getSortLabel(
        filters['sortBy'],
        filters['sortOrder'],
        context,
      );
      chips.add(
        _buildActiveChip(
          label: sortLabel,
          icon: Icons.sort,
          onRemove: () {
            final newFilters = Map<String, dynamic>.from(filters);
            newFilters.remove('sortBy');
            newFilters.remove('sortOrder');
            controller.applyFilters(newFilters);
          },
        ),
      );
      chips.add(const SizedBox(width: 8));
    }

    return chips;
  }

  String _getPriceRangeLabel(String priceRange, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (priceRange) {
      case '30-70':
        return l10n.budget;
      case '70-120':
        return l10n.standard;
      case '120-200':
        return l10n.premium;
      default:
        return 'RM$priceRange';
    }
  }

  String _getSortLabel(
    String? sortBy,
    String? sortOrder,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context)!;
    if (sortBy == 'price') {
      return sortOrder == 'asc' ? l10n.priceLowToHigh : l10n.priceHighToLow;
    } else if (sortBy == 'rating') {
      return sortOrder == 'asc' ? l10n.ratingLowToHigh : l10n.ratingHighToLow;
    } else if (sortBy == 'distance') {
      return l10n.distanceNearest;
    }
    return 'Sort: $sortBy';
  }

  Widget _buildActiveChip({
    required String label,
    IconData? icon,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 8, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF3A3A3A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: const Color(0xFFD4AF37)),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFFE0E0E0),
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 12,
                color: Color(0xFF808080),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    Get.bottomSheet(
      const FilterBottomSheet(),
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      ignoreSafeArea: false,
    );
  }

  Widget _buildErrorState() {
    return Builder(
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF2A2A2A)),
                  ),
                  child: const Icon(
                    Icons.wifi_off_outlined,
                    size: 48,
                    color: Color(0xFFE53E3E),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  controller.errorMessage,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFE0E0E0),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.pleasCheckInternetConnection,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF808080),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.retryLoadStores,
                  icon: const Icon(Icons.refresh, size: 20),
                  label: Text(l10n.retry),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: const Color(0xFF0A0A0A),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
