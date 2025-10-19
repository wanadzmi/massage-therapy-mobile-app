import 'package:get/get.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/services/transaction_service.dart';

class TransactionHistoryController extends GetxController {
  final TransactionService _transactionService = TransactionService();

  final _isLoading = false.obs;
  final _transactions = <TransactionModel>[].obs;
  final _summary = Rxn<TransactionSummary>();
  final _pagination = Rxn<TransactionPagination>();
  final _selectedFilter = 'all'.obs;

  bool get isLoading => _isLoading.value;
  List<TransactionModel> get transactions => _transactions;
  TransactionSummary? get summary => _summary.value;
  TransactionPagination? get pagination => _pagination.value;
  String get selectedFilter => _selectedFilter.value;

  @override
  void onInit() {
    super.onInit();
    loadTransactions();
  }

  Future<void> loadTransactions({int page = 1}) async {
    try {
      _isLoading.value = true;

      String? typeFilter;
      if (_selectedFilter.value != 'all') {
        typeFilter = _selectedFilter.value;
      }

      final response = await _transactionService.getTransactionHistory(
        page: page,
        type: typeFilter,
      );

      if (response.isSuccess && response.data != null) {
        _transactions.value =
            response.data!['transactions'] as List<TransactionModel>;
        _summary.value = response.data!['summary'] as TransactionSummary;
        _pagination.value =
            response.data!['pagination'] as TransactionPagination;
      } else {
        Get.snackbar(
          'Error',
          response.error?.toString() ?? 'Failed to load transactions',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('❌ Error loading transactions: $e');
      Get.snackbar(
        'Error',
        'Failed to load transaction history',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshTransactions() async {
    await loadTransactions(page: 1);
  }

  void filterByType(String type) {
    _selectedFilter.value = type;
    loadTransactions();
  }

  String getTransactionIcon(TransactionModel transaction) {
    switch (transaction.category) {
      case 'topup':
        return '💰';
      case 'booking':
        return '💆';
      case 'reward':
        return '🎁';
      default:
        return '📝';
    }
  }

  String getPaymentMethodLabel(String? method) {
    if (method == null) return '';
    switch (method) {
      case 'fpx':
        return 'FPX';
      case 'tng_ewallet':
        return 'Touch n Go';
      case 'wallet':
        return 'Wallet';
      default:
        return method.toUpperCase();
    }
  }
}
