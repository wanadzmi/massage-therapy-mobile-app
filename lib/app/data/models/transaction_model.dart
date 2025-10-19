class TransactionModel {
  final String id;
  final String transactionId;
  final String type;
  final double amount;
  final String direction;
  final double balanceBefore;
  final double balanceAfter;
  final String status;
  final String description;
  final String category;
  final DateTime createdAt;
  final String formattedAmount;
  final TopUpDetails? topUp;
  final RelatedBooking? relatedBooking;
  final RelatedPayment? relatedPayment;

  TransactionModel({
    required this.id,
    required this.transactionId,
    required this.type,
    required this.amount,
    required this.direction,
    required this.balanceBefore,
    required this.balanceAfter,
    required this.status,
    required this.description,
    required this.category,
    required this.createdAt,
    required this.formattedAmount,
    this.topUp,
    this.relatedBooking,
    this.relatedPayment,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? json['_id'] ?? '',
      transactionId: json['transactionId'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      direction: json['direction'] ?? '',
      balanceBefore: (json['balanceBefore'] ?? 0).toDouble(),
      balanceAfter: (json['balanceAfter'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      formattedAmount: json['formattedAmount'] ?? '',
      topUp: json['topUp'] != null
          ? TopUpDetails.fromJson(json['topUp'])
          : null,
      relatedBooking: json['relatedBooking'] != null
          ? RelatedBooking.fromJson(json['relatedBooking'])
          : null,
      relatedPayment: json['relatedPayment'] != null
          ? RelatedPayment.fromJson(json['relatedPayment'])
          : null,
    );
  }
}

class TopUpDetails {
  final String method;
  final String? gatewayTransactionId;

  TopUpDetails({required this.method, this.gatewayTransactionId});

  factory TopUpDetails.fromJson(Map<String, dynamic> json) {
    return TopUpDetails(
      method: json['method'] ?? '',
      gatewayTransactionId: json['gatewayTransactionId'],
    );
  }
}

class RelatedBooking {
  final String id;
  final String service;
  final DateTime date;
  final String startTime;

  RelatedBooking({
    required this.id,
    required this.service,
    required this.date,
    required this.startTime,
  });

  factory RelatedBooking.fromJson(Map<String, dynamic> json) {
    return RelatedBooking(
      id: json['id'] ?? json['_id'] ?? '',
      service: json['service'] ?? '',
      date: DateTime.parse(json['date']),
      startTime: json['startTime'] ?? '',
    );
  }
}

class RelatedPayment {
  final String id;
  final String method;
  final Gateway? gateway;

  RelatedPayment({required this.id, required this.method, this.gateway});

  factory RelatedPayment.fromJson(Map<String, dynamic> json) {
    return RelatedPayment(
      id: json['id'] ?? json['_id'] ?? '',
      method: json['method'] ?? '',
      gateway: json['gateway'] != null
          ? Gateway.fromJson(json['gateway'])
          : null,
    );
  }
}

class Gateway {
  final String transactionId;

  Gateway({required this.transactionId});

  factory Gateway.fromJson(Map<String, dynamic> json) {
    return Gateway(transactionId: json['transactionId'] ?? '');
  }
}

class TransactionSummary {
  final double totalCredits;
  final double totalDebits;
  final int creditCount;
  final int debitCount;

  TransactionSummary({
    required this.totalCredits,
    required this.totalDebits,
    required this.creditCount,
    required this.debitCount,
  });

  factory TransactionSummary.fromJson(Map<String, dynamic> json) {
    return TransactionSummary(
      totalCredits: (json['totalCredits'] ?? 0).toDouble(),
      totalDebits: (json['totalDebits'] ?? 0).toDouble(),
      creditCount: json['creditCount'] ?? 0,
      debitCount: json['debitCount'] ?? 0,
    );
  }
}

class TransactionPagination {
  final int current;
  final int total;
  final int limit;
  final int totalTransactions;

  TransactionPagination({
    required this.current,
    required this.total,
    required this.limit,
    required this.totalTransactions,
  });

  factory TransactionPagination.fromJson(Map<String, dynamic> json) {
    return TransactionPagination(
      current: json['current'] ?? 1,
      total: json['total'] ?? 1,
      limit: json['limit'] ?? 20,
      totalTransactions: json['totalTransactions'] ?? 0,
    );
  }
}
