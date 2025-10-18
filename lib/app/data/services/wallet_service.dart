import 'base_services.dart';

class WalletService extends BaseServices {
  static const String _walletEndpoint = '/api/wallet';

  /// Initiate wallet top-up
  Future<MyResponse<TopUpResponse?, dynamic>> initiateTopUp({
    required double amount,
    required String paymentMethod,
    String? bankCode,
  }) async {
    final postBody = <String, dynamic>{
      'amount': amount,
      'paymentMethod': paymentMethod,
    };

    if (bankCode != null) {
      postBody['bankCode'] = bankCode;
    }

    final response = await callAPI(
      HttpRequestType.POST,
      '$_walletEndpoint/top-up',
      postBody: postBody,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        final topUpResponse = TopUpResponse.fromJson(data);
        return MyResponse.complete(topUpResponse);
      } catch (e) {
        return MyResponse.error('Failed to parse top-up response: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Confirm wallet top-up payment
  Future<MyResponse<TopUpConfirmResponse?, dynamic>> confirmTopUp({
    required String paymentId,
    required String gatewayTransactionId,
    required double amount,
    required String status,
  }) async {
    final postBody = <String, dynamic>{
      'paymentId': paymentId,
      'gatewayTransactionId': gatewayTransactionId,
      'amount': amount,
      'status': status,
    };

    final response = await callAPI(
      HttpRequestType.POST,
      '$_walletEndpoint/top-up/confirm',
      postBody: postBody,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final confirmResponse = TopUpConfirmResponse.fromJson(response.data);
        return MyResponse.complete(confirmResponse);
      } catch (e) {
        return MyResponse.error('Failed to parse confirmation response: $e');
      }
    }

    return MyResponse.error(response.error);
  }
}

/// Response model for top-up initiation
class TopUpResponse {
  final String? transactionId;
  final String? paymentId;
  final double? amount;
  final String? method;
  final String? status;
  final bool? requiresRedirect;
  final String? paymentUrl;

  TopUpResponse({
    this.transactionId,
    this.paymentId,
    this.amount,
    this.method,
    this.status,
    this.requiresRedirect,
    this.paymentUrl,
  });

  factory TopUpResponse.fromJson(Map<String, dynamic> json) {
    return TopUpResponse(
      transactionId: json['transactionId'],
      paymentId: json['paymentId'],
      amount: json['amount']?.toDouble(),
      method: json['method'],
      status: json['status'],
      requiresRedirect: json['requiresRedirect'],
      paymentUrl: json['paymentUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'paymentId': paymentId,
      'amount': amount,
      'method': method,
      'status': status,
      'requiresRedirect': requiresRedirect,
      'paymentUrl': paymentUrl,
    };
  }
}

/// Response model for top-up confirmation
class TopUpConfirmResponse {
  final String? status;
  final bool? processed;

  TopUpConfirmResponse({this.status, this.processed});

  factory TopUpConfirmResponse.fromJson(Map<String, dynamic> json) {
    return TopUpConfirmResponse(
      status: json['status'],
      processed: json['processed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'processed': processed};
  }
}
