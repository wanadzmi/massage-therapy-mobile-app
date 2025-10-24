import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../data/models/store_model.dart' hide Duration;
import '../../../data/repositories/store_repository.dart';
import '../../../services/location_service.dart';

class FindStoreController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();
  final LocationService _locationService = LocationService();

  // Observable variables
  final _isLoading = false.obs;
  final _hasError = false.obs;
  final _errorMessage = ''.obs;
  final _stores = <Store>[].obs;
  final _currentPage = 1.obs;
  final _totalPages = 1.obs;
  final _totalStores = 0.obs;
  final _searchQuery = ''.obs;
  final _selectedFilters = <String, dynamic>{}.obs;
  final _currentLocation = Rxn<Map<String, double>>();
  final _isLoadingLocation = false.obs;

  // Debounce timer for search
  Timer? _debounceTimer;

  // Getters
  bool get isLoading => _isLoading.value;
  bool get hasError => _hasError.value;
  String get errorMessage => _errorMessage.value;
  List<Store> get stores => _stores;
  int get currentPage => _currentPage.value;
  int get totalPages => _totalPages.value;
  int get totalStores => _totalStores.value;
  String get searchQuery => _searchQuery.value;
  Map<String, dynamic> get selectedFilters => _selectedFilters;
  Map<String, double>? get currentLocation => _currentLocation.value;
  bool get isLoadingLocation => _isLoadingLocation.value;

  final int itemsPerPage = 10;

  int getActiveFilterCount() {
    int count = 0;
    final filters = _selectedFilters;

    if (filters['city'] != null) count++;
    if (filters['area'] != null) count++;
    if (filters['useLocation'] == true) count++;
    if (filters['rating'] != null) count++;
    if (filters['priceRange'] != null) count++;

    if (filters['sortBy'] != null && filters['sortBy'] != 'rating') count++;

    return count;
  }

  @override
  void onInit() {
    super.onInit();
    loadStores();
  }

  Future<void> loadStores({bool refresh = false}) async {
    try {
      if (refresh) {
        _currentPage.value = 1;
      }

      _isLoading.value = true;
      _hasError.value = false;
      _errorMessage.value = '';

      // Get location coordinates if location filter is active
      double? lat;
      double? lng;
      if (_selectedFilters['useLocation'] == true &&
          _currentLocation.value != null) {
        lat = _currentLocation.value!['latitude'];
        lng = _currentLocation.value!['longitude'];
      }

      final response = await _storeRepository.getStores(
        limit: itemsPerPage,
        page: _currentPage.value,
        search: _searchQuery.value.isNotEmpty ? _searchQuery.value : null,
        city: _selectedFilters['city'],
        area: _selectedFilters['area'],
        lat: lat,
        lng: lng,
        radius: _selectedFilters['radius'],
        rating: _selectedFilters['rating'],
        priceRange: _selectedFilters['priceRange'],
        minPrice: _selectedFilters['minPrice'],
        maxPrice: _selectedFilters['maxPrice'],

        sortBy: _selectedFilters['sortBy'],
        sortOrder: _selectedFilters['sortOrder'],
        isVerified: _selectedFilters['isVerified'],
        isOpen: _selectedFilters['isOpen'],
      );

      if (response.isSuccess && response.data != null) {
        if (refresh) {
          _stores.value = response.data!.stores ?? [];
        } else {
          _stores.addAll(response.data!.stores ?? []);
        }

        _totalPages.value = response.data!.pagination?.total ?? 1;
        _totalStores.value = response.data!.pagination?.totalStores ?? 0;
        _hasError.value = false;
      } else {
        _hasError.value = true;
        _errorMessage.value = response.error ?? 'Failed to load stores';
        Get.snackbar(
          'Error',
          _errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withAlpha(200),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
          isDismissible: true,
        );
      }
    } catch (e) {
      _hasError.value = true;
      _errorMessage.value = 'Network error. Please check your connection.';
      Get.snackbar(
        'Connection Error',
        _errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(200),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
        isDismissible: true,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> retryLoadStores() async {
    await loadStores(refresh: true);
  }

  Future<void> loadMore() async {
    if (_currentPage.value < _totalPages.value && !_isLoading.value) {
      _currentPage.value++;
      await loadStores();
    }
  }

  void onSearch(String query) {
    // Cancel previous timer if exists
    _debounceTimer?.cancel();

    // Update search query immediately
    _searchQuery.value = query;

    // Debounce the API call
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      loadStores(refresh: true);
    });
  }

  Future<void> getCurrentLocation() async {
    _isLoadingLocation.value = true;
    try {
      final location = await _locationService.getCurrentLatLng();
      if (location != null) {
        _currentLocation.value = location;
        // Print coordinates for backend setup
        print('📍 YOUR CURRENT LOCATION:');
        print('Latitude: ${location['latitude']}');
        print('Longitude: ${location['longitude']}');
        print('');
        print('💡 To set stores within 10km of your location:');
        print('Use these coordinates in your backend when creating stores.');
        print('');
      }
    } finally {
      _isLoadingLocation.value = false;
    }
  }

  Future<void> applyFilters(Map<String, dynamic> filters) async {
    // If location filter is enabled, get current location
    if (filters['useLocation'] == true && _currentLocation.value == null) {
      await getCurrentLocation();
    }

    _selectedFilters.value = filters;
    loadStores(refresh: true);
  }

  void clearFilters() {
    _selectedFilters.clear();
    _currentLocation.value = null;
    loadStores(refresh: true);
  }

  Future<void> applyNearbyFilter() async {
    await getCurrentLocation();
    if (_currentLocation.value != null) {
      _selectedFilters.value = {
        'useLocation': true,
        'radius': 10.0,
        'sortBy': 'distance',
        'sortOrder': 'asc',
      };
      loadStores(refresh: true);
    }
  }

  String? getDistanceToStore(Store store) {
    if (_currentLocation.value == null ||
        store.location?.coordinates == null ||
        store.location!.coordinates!.length < 2) {
      return null;
    }

    final storeLat = store.location!.coordinates![1];
    final storeLng = store.location!.coordinates![0];
    final userLat = _currentLocation.value!['latitude']!;
    final userLng = _currentLocation.value!['longitude']!;

    final distance = _locationService.calculateDistance(
      userLat,
      userLng,
      storeLat,
      storeLng,
    );

    return _locationService.formatDistance(distance);
  }

  void navigateToStoreDetail(Store store) {
    // Navigate to store detail page with store ID
    Get.toNamed('/store-detail', arguments: store.id);
  }

  Future<void> openGoogleMaps(Store store) async {
    if (store.location?.coordinates == null ||
        store.location!.coordinates!.length < 2) {
      Get.snackbar(
        'Location Error',
        'Store location not available',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(200),
        colorText: Colors.white,
      );
      return;
    }

    final lat = store.location!.coordinates![1];
    final lng = store.location!.coordinates![0];

    // Try Google Maps app first, then web
    final googleMapsUrl = Uri.parse('google.navigation:q=$lat,$lng');
    final googleMapsWebUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl);
      } else {
        await launchUrl(googleMapsWebUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.errorTitle,
        l10n.couldNotOpenGoogleMaps,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(200),
        colorText: Colors.white,
      );
    }
  }

  Future<void> openWaze(Store store) async {
    if (store.location?.coordinates == null ||
        store.location!.coordinates!.length < 2) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.locationError,
        l10n.storeLocationNotAvailable,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(200),
        colorText: Colors.white,
      );
      return;
    }

    final lat = store.location!.coordinates![1];
    final lng = store.location!.coordinates![0];

    final wazeUrl = Uri.parse('https://waze.com/ul?ll=$lat,$lng&navigate=yes');

    try {
      if (await canLaunchUrl(wazeUrl)) {
        await launchUrl(wazeUrl, mode: LaunchMode.externalApplication);
      } else {
        final l10n = AppLocalizations.of(Get.context!)!;
        Get.snackbar(
          l10n.wazeNotAvailable,
          l10n.pleaseInstallWaze,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withAlpha(200),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      final l10n = AppLocalizations.of(Get.context!)!;
      Get.snackbar(
        l10n.errorTitle,
        l10n.couldNotOpenWaze,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withAlpha(200),
        colorText: Colors.white,
      );
    }
  }

  void showNavigationOptions(Store store) {
    Get.bottomSheet(
      Container(
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
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF505050),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Navigate with',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFE0E0E0),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.map, color: Color(0xFFD4AF37)),
                ),
                title: const Text(
                  'Google Maps',
                  style: TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  AppLocalizations.of(Get.context!)!.navigateUsingGoogleMaps,
                  style: TextStyle(color: Color(0xFF808080), fontSize: 12),
                ),
                onTap: () {
                  Get.back();
                  openGoogleMaps(store);
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.navigation, color: Color(0xFF00D9FF)),
                ),
                title: const Text(
                  'Waze',
                  style: TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  AppLocalizations.of(Get.context!)!.navigateUsingWaze,
                  style: TextStyle(color: Color(0xFF808080), fontSize: 12),
                ),
                onTap: () {
                  Get.back();
                  openWaze(store);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String formatPrice(double? min, double? max, String? currency) {
    if (min == null || max == null) return 'N/A';
    return '${currency ?? 'MYR'} $min - $max';
  }

  String formatRating(double? rating) {
    if (rating == null) return 'N/A';
    return rating.toStringAsFixed(1);
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }
}
