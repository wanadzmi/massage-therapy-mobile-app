import 'base_services.dart';

class TierService extends BaseServices {
  static const String _tierEndpoint = '/api/tiers';

  /// Get all available tiers
  Future<MyResponse<TiersResponse?, dynamic>> getAllTiers() async {
    print('🎯 TierService: Calling GET $_tierEndpoint');
    final response = await callAPI(HttpRequestType.GET, _tierEndpoint);
    print('📥 TierService: Response success=${response.isSuccess}');

    if (response.isSuccess && response.data != null) {
      try {
        print('🔄 TierService: Parsing response data...');
        final tiersResponse = TiersResponse.fromJson(response.data);
        print('✅ TierService: Successfully parsed tier data');
        return MyResponse.complete(tiersResponse);
      } catch (e) {
        print('❌ TierService: Parse error: $e');
        return MyResponse.error('Failed to parse tiers response: $e');
      }
    }

    print('❌ TierService: API error: ${response.error}');
    return MyResponse.error(response.error);
  }

  /// Get current tier details
  Future<MyResponse<CurrentTierResponse?, dynamic>> getCurrentTier() async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_tierEndpoint/current',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final currentTierResponse = CurrentTierResponse.fromJson(response.data);
        return MyResponse.complete(currentTierResponse);
      } catch (e) {
        return MyResponse.error('Failed to parse current tier response: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Subscribe to a tier
  Future<MyResponse<SubscribeResponse?, dynamic>> subscribeTier({
    required String tier,
  }) async {
    final postBody = <String, dynamic>{'tier': tier};

    final response = await callAPI(
      HttpRequestType.POST,
      '$_tierEndpoint/subscribe',
      postBody: postBody,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final subscribeResponse = SubscribeResponse.fromJson(response.data);
        return MyResponse.complete(subscribeResponse);
      } catch (e) {
        return MyResponse.error('Failed to parse subscribe response: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Renew current tier subscription
  Future<MyResponse<RenewResponse?, dynamic>> renewSubscription() async {
    final response = await callAPI(
      HttpRequestType.POST,
      '$_tierEndpoint/renew',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final renewResponse = RenewResponse.fromJson(response.data);
        return MyResponse.complete(renewResponse);
      } catch (e) {
        return MyResponse.error('Failed to parse renew response: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Cancel tier subscription
  Future<MyResponse<CancelResponse?, dynamic>> cancelSubscription() async {
    final response = await callAPI(
      HttpRequestType.POST,
      '$_tierEndpoint/cancel',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final cancelResponse = CancelResponse.fromJson(response.data);
        return MyResponse.complete(cancelResponse);
      } catch (e) {
        return MyResponse.error('Failed to parse cancel response: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Toggle auto-renewal
  Future<MyResponse<AutoRenewResponse?, dynamic>> toggleAutoRenew({
    required bool autoRenew,
  }) async {
    final postBody = <String, dynamic>{'autoRenew': autoRenew};

    final response = await callAPI(
      HttpRequestType.PUT,
      '$_tierEndpoint/auto-renew',
      postBody: postBody,
    );

    if (response.isSuccess && response.data != null) {
      try {
        final autoRenewResponse = AutoRenewResponse.fromJson(response.data);
        return MyResponse.complete(autoRenewResponse);
      } catch (e) {
        return MyResponse.error('Failed to parse auto-renew response: $e');
      }
    }

    return MyResponse.error(response.error);
  }

  /// Get tier subscription history
  Future<MyResponse<HistoryResponse?, dynamic>> getSubscriptionHistory({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await callAPI(
      HttpRequestType.GET,
      '$_tierEndpoint/history?page=$page&limit=$limit',
    );

    if (response.isSuccess && response.data != null) {
      try {
        final historyResponse = HistoryResponse.fromJson(response.data);
        return MyResponse.complete(historyResponse);
      } catch (e) {
        return MyResponse.error('Failed to parse history response: $e');
      }
    }

    return MyResponse.error(response.error);
  }
}

/// Response model for all tiers
class TiersResponse {
  final String? message;
  final TiersData? data;

  TiersResponse({this.message, this.data});

  factory TiersResponse.fromJson(Map<String, dynamic> json) {
    return TiersResponse(
      message: json['message'],
      data: json['data'] != null ? TiersData.fromJson(json['data']) : null,
    );
  }
}

class TiersData {
  final String? currentTier;
  final double? currentBalance;
  final List<TierInfo>? tiers;

  TiersData({this.currentTier, this.currentBalance, this.tiers});

  factory TiersData.fromJson(Map<String, dynamic> json) {
    return TiersData(
      currentTier: json['currentTier'],
      currentBalance: json['currentBalance']?.toDouble(),
      tiers: (json['tiers'] as List?)
          ?.map((tier) => TierInfo.fromJson(tier))
          .toList(),
    );
  }
}

class TierInfo {
  final String tier;
  final String name;
  final double price;
  final int monthlySpendRequired;
  final String description;
  final TierBenefits? benefits;
  final bool canSubscribe;
  final bool isCurrent;
  final bool canUpgrade;
  final bool hasSufficientBalance;

  TierInfo({
    required this.tier,
    required this.name,
    required this.price,
    required this.monthlySpendRequired,
    required this.description,
    this.benefits,
    required this.canSubscribe,
    required this.isCurrent,
    required this.canUpgrade,
    required this.hasSufficientBalance,
  });

  factory TierInfo.fromJson(Map<String, dynamic> json) {
    return TierInfo(
      tier: json['tier'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      monthlySpendRequired: json['monthlySpendRequired'] ?? 0,
      description: json['description'] ?? '',
      benefits: json['benefits'] != null
          ? TierBenefits.fromJson(json['benefits'])
          : null,
      canSubscribe: json['canSubscribe'] ?? false,
      isCurrent: json['isCurrent'] ?? false,
      canUpgrade: json['canUpgrade'] ?? false,
      hasSufficientBalance: json['hasSufficientBalance'] ?? false,
    );
  }
}

class TierBenefits {
  final int cashbackPercentage;
  final bool? weeklyVouchers;
  final bool? priorityBooking;
  final bool? birthdayVoucher;
  final bool? monthlyFreeSession;
  final bool? vipHotline;
  final bool? privateTherapists;
  final bool? secretLocations;
  final List<String>? features;

  TierBenefits({
    required this.cashbackPercentage,
    this.weeklyVouchers,
    this.priorityBooking,
    this.birthdayVoucher,
    this.monthlyFreeSession,
    this.vipHotline,
    this.privateTherapists,
    this.secretLocations,
    this.features,
  });

  factory TierBenefits.fromJson(Map<String, dynamic> json) {
    return TierBenefits(
      cashbackPercentage: json['cashbackPercentage'] ?? 0,
      weeklyVouchers: json['weeklyVouchers'],
      priorityBooking: json['priorityBooking'],
      birthdayVoucher: json['birthdayVoucher'],
      monthlyFreeSession: json['monthlyFreeSession'],
      vipHotline: json['vipHotline'],
      privateTherapists: json['privateTherapists'],
      secretLocations: json['secretLocations'],
      features: (json['features'] as List?)?.map((f) => f.toString()).toList(),
    );
  }
}

/// Response model for current tier
class CurrentTierResponse {
  final String? message;
  final CurrentTierData? data;

  CurrentTierResponse({this.message, this.data});

  factory CurrentTierResponse.fromJson(Map<String, dynamic> json) {
    return CurrentTierResponse(
      message: json['message'],
      data: json['data'] != null
          ? CurrentTierData.fromJson(json['data'])
          : null,
    );
  }
}

class CurrentTierData {
  final String tier;
  final String? memberSince;
  final String name;
  final double price;
  final int monthlySpendRequired;
  final String description;
  final TierBenefits? benefits;
  final TierSubscription? subscription;
  final double? currentBalance;
  final int? loyaltyPoints;

  CurrentTierData({
    required this.tier,
    this.memberSince,
    required this.name,
    required this.price,
    required this.monthlySpendRequired,
    required this.description,
    this.benefits,
    this.subscription,
    this.currentBalance,
    this.loyaltyPoints,
  });

  factory CurrentTierData.fromJson(Map<String, dynamic> json) {
    return CurrentTierData(
      tier: json['tier'] ?? '',
      memberSince: json['memberSince'],
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      monthlySpendRequired: json['monthlySpendRequired'] ?? 0,
      description: json['description'] ?? '',
      benefits: json['benefits'] != null
          ? TierBenefits.fromJson(json['benefits'])
          : null,
      subscription: json['subscription'] != null
          ? TierSubscription.fromJson(json['subscription'])
          : null,
      currentBalance: json['currentBalance']?.toDouble(),
      loyaltyPoints: json['loyaltyPoints'],
    );
  }
}

class TierSubscription {
  final String tier;
  final String subscribedAt;
  final String expiresAt;
  final bool autoRenew;
  final double price;
  final String status;
  final String? cancelledAt;
  final String? lastRenewedAt;

  TierSubscription({
    required this.tier,
    required this.subscribedAt,
    required this.expiresAt,
    required this.autoRenew,
    required this.price,
    required this.status,
    this.cancelledAt,
    this.lastRenewedAt,
  });

  factory TierSubscription.fromJson(Map<String, dynamic> json) {
    return TierSubscription(
      tier: json['tier'] ?? '',
      subscribedAt: json['subscribedAt'] ?? '',
      expiresAt: json['expiresAt'] ?? '',
      autoRenew: json['autoRenew'] ?? false,
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      cancelledAt: json['cancelledAt'],
      lastRenewedAt: json['lastRenewedAt'],
    );
  }
}

/// Response model for subscribe
class SubscribeResponse {
  final String? message;
  final SubscribeData? data;

  SubscribeResponse({this.message, this.data});

  factory SubscribeResponse.fromJson(Map<String, dynamic> json) {
    return SubscribeResponse(
      message: json['message'],
      data: json['data'] != null ? SubscribeData.fromJson(json['data']) : null,
    );
  }
}

class SubscribeData {
  final String tier;
  final String? previousTier;
  final TierSubscription? subscription;
  final TransactionInfo? transaction;
  final TierBenefits? benefits;
  final String? expiresAt;

  SubscribeData({
    required this.tier,
    this.previousTier,
    this.subscription,
    this.transaction,
    this.benefits,
    this.expiresAt,
  });

  factory SubscribeData.fromJson(Map<String, dynamic> json) {
    return SubscribeData(
      tier: json['tier'] ?? '',
      previousTier: json['previousTier'],
      subscription: json['subscription'] != null
          ? TierSubscription.fromJson(json['subscription'])
          : null,
      transaction: json['transaction'] != null
          ? TransactionInfo.fromJson(json['transaction'])
          : null,
      benefits: json['benefits'] != null
          ? TierBenefits.fromJson(json['benefits'])
          : null,
      expiresAt: json['expiresAt'],
    );
  }
}

class TransactionInfo {
  final String? transactionId;
  final double? amount;
  final double? newBalance;

  TransactionInfo({this.transactionId, this.amount, this.newBalance});

  factory TransactionInfo.fromJson(Map<String, dynamic> json) {
    return TransactionInfo(
      transactionId: json['transactionId'],
      amount: json['amount']?.toDouble(),
      newBalance: json['newBalance']?.toDouble(),
    );
  }
}

/// Response model for renew
class RenewResponse {
  final String? message;
  final RenewData? data;

  RenewResponse({this.message, this.data});

  factory RenewResponse.fromJson(Map<String, dynamic> json) {
    return RenewResponse(
      message: json['message'],
      data: json['data'] != null ? RenewData.fromJson(json['data']) : null,
    );
  }
}

class RenewData {
  final String tier;
  final TierSubscription? subscription;
  final TransactionInfo? transaction;
  final String? expiresAt;

  RenewData({
    required this.tier,
    this.subscription,
    this.transaction,
    this.expiresAt,
  });

  factory RenewData.fromJson(Map<String, dynamic> json) {
    return RenewData(
      tier: json['tier'] ?? '',
      subscription: json['subscription'] != null
          ? TierSubscription.fromJson(json['subscription'])
          : null,
      transaction: json['transaction'] != null
          ? TransactionInfo.fromJson(json['transaction'])
          : null,
      expiresAt: json['expiresAt'],
    );
  }
}

/// Response model for cancel
class CancelResponse {
  final String? message;
  final CancelData? data;

  CancelResponse({this.message, this.data});

  factory CancelResponse.fromJson(Map<String, dynamic> json) {
    return CancelResponse(
      message: json['message'],
      data: json['data'] != null ? CancelData.fromJson(json['data']) : null,
    );
  }
}

class CancelData {
  final String currentTier;
  final TierSubscription? subscription;
  final String? note;

  CancelData({required this.currentTier, this.subscription, this.note});

  factory CancelData.fromJson(Map<String, dynamic> json) {
    return CancelData(
      currentTier: json['currentTier'] ?? '',
      subscription: json['subscription'] != null
          ? TierSubscription.fromJson(json['subscription'])
          : null,
      note: json['note'],
    );
  }
}

/// Response model for auto-renew toggle
class AutoRenewResponse {
  final String? message;
  final AutoRenewData? data;

  AutoRenewResponse({this.message, this.data});

  factory AutoRenewResponse.fromJson(Map<String, dynamic> json) {
    return AutoRenewResponse(
      message: json['message'],
      data: json['data'] != null ? AutoRenewData.fromJson(json['data']) : null,
    );
  }
}

class AutoRenewData {
  final String tier;
  final bool autoRenew;
  final String? expiresAt;

  AutoRenewData({required this.tier, required this.autoRenew, this.expiresAt});

  factory AutoRenewData.fromJson(Map<String, dynamic> json) {
    return AutoRenewData(
      tier: json['tier'] ?? '',
      autoRenew: json['autoRenew'] ?? false,
      expiresAt: json['expiresAt'],
    );
  }
}

/// Response model for subscription history
class HistoryResponse {
  final String? message;
  final HistoryData? data;

  HistoryResponse({this.message, this.data});

  factory HistoryResponse.fromJson(Map<String, dynamic> json) {
    return HistoryResponse(
      message: json['message'],
      data: json['data'] != null ? HistoryData.fromJson(json['data']) : null,
    );
  }
}

class HistoryData {
  final List<TierTransaction>? transactions;
  final PaginationInfo? pagination;

  HistoryData({this.transactions, this.pagination});

  factory HistoryData.fromJson(Map<String, dynamic> json) {
    return HistoryData(
      transactions: (json['transactions'] as List?)
          ?.map((tx) => TierTransaction.fromJson(tx))
          .toList(),
      pagination: json['pagination'] != null
          ? PaginationInfo.fromJson(json['pagination'])
          : null,
    );
  }
}

class TierTransaction {
  final String id;
  final String transactionId;
  final String type;
  final double amount;
  final String direction;
  final double? balanceBefore;
  final double? balanceAfter;
  final String description;
  final String category;
  final TierSubscriptionInfo? tierSubscription;
  final String status;
  final String createdAt;

  TierTransaction({
    required this.id,
    required this.transactionId,
    required this.type,
    required this.amount,
    required this.direction,
    this.balanceBefore,
    this.balanceAfter,
    required this.description,
    required this.category,
    this.tierSubscription,
    required this.status,
    required this.createdAt,
  });

  factory TierTransaction.fromJson(Map<String, dynamic> json) {
    return TierTransaction(
      id: json['_id'] ?? '',
      transactionId: json['transactionId'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      direction: json['direction'] ?? '',
      balanceBefore: json['balanceBefore']?.toDouble(),
      balanceAfter: json['balanceAfter']?.toDouble(),
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      tierSubscription: json['tierSubscription'] != null
          ? TierSubscriptionInfo.fromJson(json['tierSubscription'])
          : null,
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class TierSubscriptionInfo {
  final String tier;
  final String? previousTier;
  final int duration;
  final String subscribedAt;
  final String expiresAt;

  TierSubscriptionInfo({
    required this.tier,
    this.previousTier,
    required this.duration,
    required this.subscribedAt,
    required this.expiresAt,
  });

  factory TierSubscriptionInfo.fromJson(Map<String, dynamic> json) {
    return TierSubscriptionInfo(
      tier: json['tier'] ?? '',
      previousTier: json['previousTier'],
      duration: json['duration'] ?? 0,
      subscribedAt: json['subscribedAt'] ?? '',
      expiresAt: json['expiresAt'] ?? '',
    );
  }
}

class PaginationInfo {
  final int current;
  final int total;
  final int limit;
  final int totalTransactions;

  PaginationInfo({
    required this.current,
    required this.total,
    required this.limit,
    required this.totalTransactions,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      current: json['current'] ?? 1,
      total: json['total'] ?? 1,
      limit: json['limit'] ?? 20,
      totalTransactions: json['totalTransactions'] ?? 0,
    );
  }
}
