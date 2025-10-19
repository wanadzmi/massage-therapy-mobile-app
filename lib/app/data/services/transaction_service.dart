import '../models/transaction_model.dart';
import 'base_services.dart';

class TransactionService extends BaseServices {
  Future<MyResponse<Map<String, dynamic>?, dynamic>> getTransactionHistory({
    int page = 1,
    int limit = 20,
    String? type,
    String? status,
    String? category,
  }) async {
    try {
      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (type != null) queryParams['type'] = type;
      if (status != null) queryParams['status'] = status;
      if (category != null) queryParams['category'] = category;

      // Build query string
      final queryString = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');

      final response = await callAPI(
        HttpRequestType.GET,
        '/api/wallet/transactions?$queryString',
      );

      if (response.isSuccess && response.data != null) {
        final data = response.data['data'];

        final transactions = (data['transactions'] as List)
            .map((json) => TransactionModel.fromJson(json))
            .toList();

        final summary = TransactionSummary.fromJson(data['summary']);
        final pagination = TransactionPagination.fromJson(data['pagination']);

        return MyResponse.complete({
          'transactions': transactions,
          'summary': summary,
          'pagination': pagination,
        });
      } else {
        return MyResponse.error(
          response.error ?? 'Failed to fetch transactions',
        );
      }
    } catch (e) {
      print('❌ Error fetching transactions: $e');
      return MyResponse.error(e.toString());
    }
  }
}
