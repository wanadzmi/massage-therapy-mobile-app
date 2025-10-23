import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  // Available cities and areas (can be populated from API)
  final List<String> availableCities = [
    'Kuala Lumpur',
    'Penang',
    'Johor Bahru',
    'Ipoh',
    'Kuching',
    'Kota Kinabalu',
    'Petaling Jaya',
    'Shah Alam',
    'Melaka',
    'Seremban',
  ];

  final Map<String, List<String>> cityAreas = {
    'Kuala Lumpur': [
      'Bukit Bintang',
      'KLCC',
      'Bangsar',
      'Mont Kiara',
      'Cheras',
      'Kepong',
      'Setapak',
    ],
    'Penang': [
      'Georgetown',
      'Bayan Lepas',
      'Tanjung Bungah',
      'Gurney Drive',
      'Batu Ferringhi',
    ],
    'Johor Bahru': [
      'City Centre',
      'Skudai',
      'Tampoi',
      'Taman Molek',
      'Nusajaya',
    ],
    'Ipoh': ['Old Town', 'New Town', 'Ipoh Garden', 'Bercham', 'Tambun'],
    'Kuching': ['City Centre', 'Petra Jaya', 'Matang', 'Samarahan', 'Pending'],
    'Kota Kinabalu': [
      'City Centre',
      'Likas',
      'Tanjung Aru',
      'Penampang',
      'Inanam',
    ],
    'Petaling Jaya': [
      'SS2',
      'Damansara',
      'Kelana Jaya',
      'Subang Jaya',
      'Ara Damansara',
    ],
    'Shah Alam': [
      'Section 7',
      'Section 13',
      'Section 18',
      'Bukit Jelutong',
      'Kota Kemuning',
    ],
    'Melaka': [
      'Bandar Melaka',
      'Ayer Keroh',
      'Batu Berendam',
      'Durian Tunggal',
    ],
    'Seremban': ['Seremban 2', 'Senawang', 'Rasah', 'Nilai', 'Port Dickson'],
  };

  List<String> getAreasForCity(String city) {
    return cityAreas[city] ?? [];
  }

  int getActiveFilterCount() {
    int count = 0;
    final filters = _selectedFilters;

    if (filters['city'] != null) count++;
    if (filters['area'] != null) count++;
    if (filters['useLocation'] == true) count++;
    if (filters['rating'] != null) count++;
    if (filters['priceRange'] != null) count++;
    if (filters['amenities'] != null &&
        (filters['amenities'] as List).isNotEmpty) {
      count += (filters['amenities'] as List).length;
    }
    if (filters['sortBy'] != null && filters['sortBy'] != 'rating') count++;

    return count;
  }

  @override
  void onInit() {
    super.onInit();
    _restoreFilters();
    loadStores();
  }

  Future<void> _saveFilters() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final filtersMap = Map<String, dynamic>.from(_selectedFilters);
      final filtersJson = json.encode(filtersMap);
      await prefs.setString('find_store_filters', filtersJson);

      // Save search query separately
      if (_searchQuery.value.isNotEmpty) {
        await prefs.setString('find_store_search', _searchQuery.value);
      } else {
        await prefs.remove('find_store_search');
      }
    } catch (e) {
      // Silent fail - not critical
      print('Error saving filters: $e');
    }
  }

  Future<void> _restoreFilters() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Restore filters
      final filtersJson = prefs.getString('find_store_filters');
      if (filtersJson != null) {
        final filters = json.decode(filtersJson) as Map<String, dynamic>;
        _selectedFilters.assignAll(filters);

        // Restore location if it was active
        if (filters['useLocation'] == true) {
          await getCurrentLocation();
        }
      }

      // Restore search query
      final savedSearch = prefs.getString('find_store_search');
      if (savedSearch != null) {
        _searchQuery.value = savedSearch;
      }
    } catch (e) {
      // Silent fail - not critical
      print('Error restoring filters: $e');
    }
  }

  Future<void> clearFilterPersistence() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('find_store_filters');
      await prefs.remove('find_store_search');
    } catch (e) {
      print('Error clearing filter persistence: $e');
    }
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
        amenities: _selectedFilters['amenities'],
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
      _saveFilters();
      loadStores(refresh: true);
    });
  }

  Future<void> getCurrentLocation() async {
    _isLoadingLocation.value = true;
    try {
      final location = await _locationService.getCurrentLatLng();
      if (location != null) {
        _currentLocation.value = location;
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
    await _saveFilters();
    loadStores(refresh: true);
  }

  void clearFilters() {
    _selectedFilters.clear();
    _currentLocation.value = null;
    clearFilterPersistence();
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
