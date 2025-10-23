import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/find_store_controller.dart';
import '../../../services/location_service.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final controller = Get.find<FindStoreController>();
  final locationService = LocationService();

  // Local state for filter selections (before applying)
  double? selectedRating;
  RangeValues priceRange = const RangeValues(30, 200);

  String? sortBy;
  String? sortOrder;
  bool useLocation = false;
  double radius = 10;

  @override
  void initState() {
    super.initState();
    _loadCurrentFilters();
  }

  void _loadCurrentFilters() {
    // Load current filter states from controller
    final filters = controller.selectedFilters;
    setState(() {
      selectedRating = filters['rating'];
      if (filters['priceRange'] != null) {
        final parts = (filters['priceRange'] as String).split('-');
        if (parts.length == 2) {
          priceRange = RangeValues(
            double.tryParse(parts[0]) ?? 30,
            double.tryParse(parts[1]) ?? 200,
          );
        }
      }

      sortBy = filters['sortBy'];
      sortOrder = filters['sortOrder'];
      useLocation = filters['useLocation'] == true;
      radius = filters['radius'] ?? 10;
    });
  }

  void _applyFilters() {
    final filters = <String, dynamic>{};

    if (selectedRating != null) filters['rating'] = selectedRating;
    if (priceRange.start != 30 || priceRange.end != 200) {
      filters['priceRange'] =
          '${priceRange.start.toInt()}-${priceRange.end.toInt()}';
    }

    if (sortBy != null) {
      filters['sortBy'] = sortBy;
      filters['sortOrder'] = sortOrder;
    }
    if (useLocation) {
      filters['useLocation'] = true;
      filters['radius'] = radius;
    }

    controller.applyFilters(filters);
    Get.back();
  }

  void _clearAll() {
    setState(() {
      selectedRating = null;
      priceRange = const RangeValues(30, 200);

      sortBy = null;
      sortOrder = null;
      useLocation = false;
      radius = 10;
    });
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (selectedRating != null) count++;
    if (priceRange.start != 30 || priceRange.end != 200) count++;

    if (useLocation) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFF2A2A2A), width: 1),
                ),
              ),
              child: Row(
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
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location Section
                    _buildSectionTitle('Location'),
                    const SizedBox(height: 12),
                    _buildLocationSection(),
                    const SizedBox(height: 24),

                    // Price Range Section
                    _buildSectionTitle('Price Range'),
                    const SizedBox(height: 12),
                    _buildPriceRangeSection(),
                    const SizedBox(height: 24),

                    // Rating Section
                    _buildSectionTitle('Minimum Rating'),
                    const SizedBox(height: 12),
                    _buildRatingSection(),
                    const SizedBox(height: 24),

                    // Amenities Section
                    _buildSectionTitle('Amenities'),
                    const SizedBox(height: 12),

                    const SizedBox(height: 24),

                    // Sort Section
                    _buildSectionTitle('Sort By'),
                    const SizedBox(height: 12),
                    _buildSortSection(),
                    const SizedBox(height: 80), // Space for bottom buttons
                  ],
                ),
              ),
            ),

            // Bottom Action Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF0A0A0A),
                border: Border(
                  top: BorderSide(color: Color(0xFF2A2A2A), width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Clear All Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearAll,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xFF808080),
                        side: const BorderSide(color: Color(0xFF2A2A2A)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Clear All',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Apply Button
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _getActiveFilterCount() > 0
                            ? 'Apply (${_getActiveFilterCount()})'
                            : 'Apply',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFFE0E0E0),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      children: [
        // Use Current Location Toggle
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: useLocation
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFF2A2A2A),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.my_location,
                color: useLocation
                    ? const Color(0xFFD4AF37)
                    : const Color(0xFF606060),
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Use Current Location',
                  style: TextStyle(
                    fontSize: 14,
                    color: useLocation
                        ? const Color(0xFFE0E0E0)
                        : const Color(0xFF808080),
                  ),
                ),
              ),
              Switch(
                value: useLocation,
                onChanged: (value) {
                  setState(() {
                    useLocation = value;
                  });
                },
                activeColor: const Color(0xFFD4AF37),
              ),
            ],
          ),
        ),

        if (useLocation) ...[
          const SizedBox(height: 12),
          // Radius Selector
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0A0A),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Search Radius',
                      style: TextStyle(fontSize: 13, color: Color(0xFF808080)),
                    ),
                    Text(
                      '${radius.toInt()} km',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFFD4AF37),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildRadiusChip(5),
                    const SizedBox(width: 8),
                    _buildRadiusChip(10),
                    const SizedBox(width: 8),
                    _buildRadiusChip(20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildRadiusChip(double value) {
    final isSelected = radius == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => radius = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFD4AF37).withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFF2A2A2A),
            ),
          ),
          child: Text(
            '${value.toInt()} km',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFF606060),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRangeSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A0A0A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'RM ${priceRange.start.toInt()}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'RM ${priceRange.end.toInt()}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFD4AF37),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          RangeSlider(
            values: priceRange,
            min: 30,
            max: 200,
            divisions: 34,
            activeColor: const Color(0xFFD4AF37),
            inactiveColor: const Color(0xFF2A2A2A),
            onChanged: (values) {
              setState(() => priceRange = values);
            },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildPricePreset('Budget', 30, 70),
              const SizedBox(width: 8),
              _buildPricePreset('Standard', 70, 120),
              const SizedBox(width: 8),
              _buildPricePreset('Premium', 120, 200),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricePreset(String label, double min, double max) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => priceRange = RangeValues(min, max)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF2A2A2A)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Color(0xFF606060)),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Row(
      children: [
        _buildRatingChip('All', null),
        const SizedBox(width: 8),
        _buildRatingChip('3+', 3),
        const SizedBox(width: 8),
        _buildRatingChip('4+', 4),
        const SizedBox(width: 8),
        _buildRatingChip('4.5+', 4.5),
      ],
    );
  }

  Widget _buildRatingChip(String label, double? rating) {
    final isSelected = selectedRating == rating;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedRating = rating),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFD4AF37).withOpacity(0.15)
                : const Color(0xFF0A0A0A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFF2A2A2A),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (rating != null)
                const Icon(Icons.star, color: Color(0xFFD4AF37), size: 14),
              if (rating != null) const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFFD4AF37)
                      : const Color(0xFF606060),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortSection() {
    return Column(
      children: [
        _buildSortOption('Recommended', 'rating', 'desc'),
        const SizedBox(height: 8),
        _buildSortOption('Rating: High to Low', 'rating', 'desc'),
        const SizedBox(height: 8),
        _buildSortOption('Rating: Low to High', 'rating', 'asc'),
        const SizedBox(height: 8),
        _buildSortOption('Price: Low to High', 'price', 'asc'),
        const SizedBox(height: 8),
        _buildSortOption('Price: High to Low', 'price', 'desc'),
        if (useLocation) ...[
          const SizedBox(height: 8),
          _buildSortOption('Distance: Nearest First', 'distance', 'asc'),
        ],
      ],
    );
  }

  Widget _buildSortOption(String label, String sort, String order) {
    final isSelected = sortBy == sort && sortOrder == order;
    return GestureDetector(
      onTap: () {
        setState(() {
          sortBy = sort;
          sortOrder = order;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFD4AF37).withOpacity(0.15)
              : const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : const Color(0xFF2A2A2A),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? const Color(0xFFD4AF37)
                  : const Color(0xFF606060),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isSelected
                    ? const Color(0xFFE0E0E0)
                    : const Color(0xFF808080),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
