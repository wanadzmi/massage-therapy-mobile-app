import 'package:flutter/material.dart';
import '../models/wallet_topup_model.dart';
import 'base_services.dart';
import '../../../l10n/app_localizations.dart';

class WalletService extends BaseServices {
  static const String _walletEndpoint = '/api/wallet';
  static const String _transactionsEndpoint = '/api/wallet/transactions';

  /// Initiate wallet top-up
  Future<MyResponse<TopUpData?, dynamic>> initiateTopUp({
    required double amount,
    required String paymentMethod,
  }) async {
    final postBody = <String, dynamic>{
      'amount': amount,
      'paymentMethod': paymentMethod,
    };

    final response = await callAPI(
      HttpRequestType.POST,
      '$_walletEndpoint/top-up',
      postBody: postBody,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        final topUpData = TopUpData.fromJson(data);
        return MyResponse.complete(topUpData);
      } catch (e) {
        return MyResponse.error('Failed to parse top-up response: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get transaction status by ID
  Future<MyResponse<WalletTransaction?, dynamic>> getTransactionStatus(
    String transactionId,
  ) async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_transactionsEndpoint/$transactionId',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        final transaction = WalletTransaction.fromJson(data);
        return MyResponse.complete(transaction);
      } catch (e) {
        return MyResponse.error('Failed to parse transaction: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get wallet balance and details
  Future<MyResponse<Map<String, dynamic>?, dynamic>> getWalletDetails() async {
    final response = await callAPI(HttpRequestType.GET, _walletEndpoint);

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        return MyResponse.complete(data);
      } catch (e) {
        return MyResponse.error('Failed to parse wallet details: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get available payment methods
  List<PaymentMethod> getAvailablePaymentMethods(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return [
      PaymentMethod(
        id: 'test_payment',
        name: l10n.testPayment,
        description: l10n.testPaymentDesc,
        enabled: true,
        badge: l10n.instant,
        badgeColor: '4CAF50', // Green
      ),
      PaymentMethod(
        id: 'usdt_trc20',
        name: l10n.usdtTrc20,
        description: l10n.usdtTrc20Desc,
        enabled: true,
        badge: l10n.crypto,
        badgeColor: 'FF9800', // Orange
      ),
      PaymentMethod(
        id: 'fpx',
        name: l10n.onlineBanking,
        description: l10n.onlineBankingDesc,
        enabled: false,
        badge: l10n.comingSoon,
        badgeColor: '9E9E9E', // Grey
      ),
      PaymentMethod(
        id: 'tng_ewallet',
        name: l10n.touchNGo,
        description: l10n.touchNGoDesc,
        enabled: false,
        badge: l10n.comingSoon,
        badgeColor: '9E9E9E', // Grey
      ),
    ];
  }

  /// Validate top-up amount
  String? validateAmount(double? amount, AppLocalizations l10n) {
    if (amount == null || amount <= 0) {
      return l10n.pleaseEnterValidAmount;
    }
    if (amount < 10) {
      return l10n.minimumTopUpAmount;
    }
    if (amount > 5000) {
      return l10n.maximumTopUpAmount;
    }
    return null;
  }

  /// Get wallet balance (legacy method)
  Future<MyResponse<double?, dynamic>> getBalance() async {
    final response = await callAPI(HttpRequestType.GET, _walletEndpoint);

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        final balance = data['balance'] as num;
        return MyResponse.complete(balance.toDouble());
      } catch (e) {
        return MyResponse.error('Failed to parse balance: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get transaction history
  Future<MyResponse<List<WalletTransaction>?, dynamic>> getTransactions({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_walletEndpoint/transactions?page=$page&limit=$limit',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final data = response.data['data'] ?? response.data;
        final transactions = (data['transactions'] as List)
            .map((json) => WalletTransaction.fromJson(json))
            .toList();
        return MyResponse.complete(transactions);
      } catch (e) {
        return MyResponse.error('Failed to parse transactions: $e');
      }
    }

    return MyResponse.error(response.error);
  }
}
