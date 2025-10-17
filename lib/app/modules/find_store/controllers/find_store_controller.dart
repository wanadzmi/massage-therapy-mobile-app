import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/store_model.dart';
import '../../../data/repositories/store_repository.dart';

class FindStoreController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();

  // Observable variables
  final _isLoading = false.obs;
  final _stores = <Store>[].obs;
  final _currentPage = 1.obs;
  final _totalPages = 1.obs;
  final _totalStores = 0.obs;
  final _searchQuery = ''.obs;
  final _selectedFilters = <String, dynamic>{}.obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<Store> get stores => _stores;
  int get currentPage => _currentPage.value;
  int get totalPages => _totalPages.value;
  int get totalStores => _totalStores.value;
  String get searchQuery => _searchQuery.value;
  Map<String, dynamic> get selectedFilters => _selectedFilters;

  final int itemsPerPage = 10;

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

      final response = await _storeRepository.getStores(
        limit: itemsPerPage,
        page: _currentPage.value,
        search: _searchQuery.value.isNotEmpty ? _searchQuery.value : null,
        city: _selectedFilters['city'],
        minPrice: _selectedFilters['minPrice'],
        maxPrice: _selectedFilters['maxPrice'],
        amenities: _selectedFilters['amenities'],
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
      } else {
        Get.snackbar(
          'Error',
          response.error ?? 'Failed to load stores',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF1E1E1E),
          colorText: const Color(0xFFE53E3E),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF1E1E1E),
        colorText: const Color(0xFFE53E3E),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (_currentPage.value < _totalPages.value && !_isLoading.value) {
      _currentPage.value++;
      await loadStores();
    }
  }

  void onSearch(String query) {
    _searchQuery.value = query;
    loadStores(refresh: true);
  }

  void applyFilters(Map<String, dynamic> filters) {
    _selectedFilters.value = filters;
    loadStores(refresh: true);
  }

  void clearFilters() {
    _selectedFilters.clear();
    loadStores(refresh: true);
  }

  void navigateToStoreDetail(Store store) {
    // Navigate to store detail page
    Get.snackbar(
      'Store Details',
      'Opening ${store.name}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF1E1E1E),
      colorText: const Color(0xFFD4AF37),
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
}
