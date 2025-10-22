class WalletTopUpRequest {
  final double amount;
  final String paymentMethod;

  WalletTopUpRequest({required this.amount, required this.paymentMethod});

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'paymentMethod': paymentMethod};
  }
}

class WalletTopUpResponse {
  final String? message;
  final TopUpData? data;

  WalletTopUpResponse({this.message, this.data});

  factory WalletTopUpResponse.fromJson(Map<String, dynamic> json) {
    return WalletTopUpResponse(
      message: json['message'],
      data: json['data'] != null ? TopUpData.fromJson(json['data']) : null,
    );
  }
}

class TopUpData {
  final String? transactionId;
  final String? paymentId;
  final double? amount;
  final String? method;
  final String? status;
  final bool? requiresRedirect;
  final bool? instantCredit;
  final double? newBalance;
  final String? message;
  // USDT specific fields
  final String? walletAddress;
  final String? network;

  TopUpData({
    this.transactionId,
    this.paymentId,
    this.amount,
    this.method,
    this.status,
    this.requiresRedirect,
    this.instantCredit,
    this.newBalance,
    this.message,
    this.walletAddress,
    this.network,
  });

  factory TopUpData.fromJson(Map<String, dynamic> json) {
    return TopUpData(
      transactionId: json['transactionId'],
      paymentId: json['paymentId'],
      amount: json['amount']?.toDouble(),
      method: json['method'],
      status: json['status'],
      requiresRedirect: json['requiresRedirect'],
      instantCredit: json['instantCredit'],
      newBalance: json['newBalance']?.toDouble(),
      message: json['message'],
      walletAddress: json['walletAddress'],
      network: json['network'],
    );
  }
}

class PaymentMethod {
  final String id;
  final String name;
  final String description;
  final bool enabled;
  final String? badge;
  final String? badgeColor;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.enabled,
    this.badge,
    this.badgeColor,
  });
}

class WalletTransaction {
  final String? transactionId;
  final String? user;
  final String? type;
  final double? amount;
  final String? direction;
  final double? balanceBefore;
  final double? balanceAfter;
  final String? status;
  final String? description;
  final String? category;
  final TopUpDetails? topUp;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  WalletTransaction({
    this.transactionId,
    this.user,
    this.type,
    this.amount,
    this.direction,
    this.balanceBefore,
    this.balanceAfter,
    this.status,
    this.description,
    this.category,
    this.topUp,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      transactionId: json['transactionId'],
      user: json['user'],
      type: json['type'],
      amount: json['amount']?.toDouble(),
      direction: json['direction'],
      balanceBefore: json['balanceBefore']?.toDouble(),
      balanceAfter: json['balanceAfter']?.toDouble(),
      status: json['status'],
      description: json['description'],
      category: json['category'],
      topUp: json['topUp'] != null
          ? TopUpDetails.fromJson(json['topUp'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}

class TopUpDetails {
  final String? method;
  final String? gatewayTransactionId;

  TopUpDetails({this.method, this.gatewayTransactionId});

  factory TopUpDetails.fromJson(Map<String, dynamic> json) {
    return TopUpDetails(
      method: json['method'],
      gatewayTransactionId: json['gatewayTransactionId'],
    );
  }
}
