class TodaySummary {
  final SummaryStats? summary;
  final TodayPayments? payments;
  final TodayRevenue? revenue;
  final List<UpcomingBooking>? upcomingBookings;

  TodaySummary({
    this.summary,
    this.payments,
    this.revenue,
    this.upcomingBookings,
  });

  factory TodaySummary.fromJson(Map<String, dynamic> json) {
    return TodaySummary(
      summary: json['summary'] != null && json['summary'] is Map
          ? SummaryStats.fromJson(json['summary'] as Map<String, dynamic>)
          : null,
      payments: json['payments'] != null && json['payments'] is Map
          ? TodayPayments.fromJson(json['payments'] as Map<String, dynamic>)
          : null,
      revenue: json['revenue'] != null && json['revenue'] is Map
          ? TodayRevenue.fromJson(json['revenue'] as Map<String, dynamic>)
          : null,
      upcomingBookings:
          json['upcomingBookings'] != null && json['upcomingBookings'] is List
          ? (json['upcomingBookings'] as List)
                .map(
                  (booking) =>
                      UpcomingBooking.fromJson(booking as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summary': summary?.toJson(),
      'payments': payments?.toJson(),
      'revenue': revenue?.toJson(),
      'upcomingBookings': upcomingBookings?.map((b) => b.toJson()).toList(),
    };
  }
}

class SummaryStats {
  final int? totalCustomers;
  final CustomerBreakdown? customerBreakdown;
  final int? totalBookings;
  final int? completedBookings;
  final int? pendingBookings;
  final int? cashCollectionNeeded;

  SummaryStats({
    this.totalCustomers,
    this.customerBreakdown,
    this.totalBookings,
    this.completedBookings,
    this.pendingBookings,
    this.cashCollectionNeeded,
  });

  factory SummaryStats.fromJson(Map<String, dynamic> json) {
    // Calculate total bookings from API fields
    final completed = json['completed'] as int? ?? 0;
    final inProgress = json['inProgress'] as int? ?? 0;
    final upcoming = json['upcoming'] as int? ?? 0;
    final cancelled = json['cancelled'] as int? ?? 0;
    final noShow = json['noShow'] as int? ?? 0;

    final totalBookings =
        completed + inProgress + upcoming + cancelled + noShow;

    return SummaryStats(
      totalCustomers: json['totalCustomers'] as int?,
      customerBreakdown:
          json['customerBreakdown'] != null && json['customerBreakdown'] is Map
          ? CustomerBreakdown.fromJson(
              json['customerBreakdown'] as Map<String, dynamic>,
            )
          : null,
      totalBookings: totalBookings,
      completedBookings: completed,
      pendingBookings: upcoming + inProgress,
      cashCollectionNeeded: json['cashCollectionNeeded'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCustomers': totalCustomers,
      'customerBreakdown': customerBreakdown?.toJson(),
      'totalBookings': totalBookings,
      'completedBookings': completedBookings,
      'pendingBookings': pendingBookings,
      'cashCollectionNeeded': cashCollectionNeeded,
    };
  }
}

class CustomerBreakdown {
  final int? male;
  final int? female;
  final int? other;

  CustomerBreakdown({this.male, this.female, this.other});

  factory CustomerBreakdown.fromJson(Map<String, dynamic> json) {
    return CustomerBreakdown(
      male: json['male'] as int?,
      female: json['female'] as int?,
      other: json['other'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'male': male, 'female': female, 'other': other};
  }
}

class TodayPayments {
  final int? cash;
  final int? transfer;
  final int? total;

  TodayPayments({this.cash, this.transfer, this.total});

  factory TodayPayments.fromJson(Map<String, dynamic> json) {
    return TodayPayments(
      cash: json['cash'] as int?,
      transfer: json['transfer'] as int?,
      total: json['total'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'cash': cash, 'transfer': transfer, 'total': total};
  }
}

class TodayRevenue {
  final double? completed;
  final double? pending;
  final double? total;

  TodayRevenue({this.completed, this.pending, this.total});

  factory TodayRevenue.fromJson(Map<String, dynamic> json) {
    // API returns: {total: 1190, cash: 0, transfer: 1190}
    // We need to map: cash = completed (already collected), transfer/pending = pending
    final total = json['total']?.toDouble() ?? 0.0;
    final cash = json['cash']?.toDouble() ?? 0.0;
    final transfer = json['transfer']?.toDouble() ?? 0.0;

    return TodayRevenue(
      completed: cash, // Cash already collected
      pending: transfer, // Transfer/wallet not yet collected
      total: total,
    );
  }

  Map<String, dynamic> toJson() {
    return {'completed': completed, 'pending': pending, 'total': total};
  }
}

class UpcomingBooking {
  final String? id;
  final String? bookingCode;
  final String? customerName;
  final String? serviceName;
  final String? startTime;
  final String? endTime;
  final String? status;
  final bool? requiresCashCollection;

  UpcomingBooking({
    this.id,
    this.bookingCode,
    this.customerName,
    this.serviceName,
    this.startTime,
    this.endTime,
    this.status,
    this.requiresCashCollection,
  });

  factory UpcomingBooking.fromJson(Map<String, dynamic> json) {
    // API returns: {customer: {name: ...}, service: ..., time: "15:00 - 16:00", isCash: false}
    final customer = json['customer'] as Map<String, dynamic>?;
    final timeRange = json['time'] as String?; // "15:00 - 16:00"
    final times = timeRange?.split(' - ');

    return UpcomingBooking(
      id: json['_id'] ?? json['id'],
      bookingCode: json['bookingCode'],
      customerName: customer?['name'] ?? json['customerName'],
      serviceName: json['service'] ?? json['serviceName'],
      startTime: times?.first ?? json['startTime'],
      endTime: times?.last ?? json['endTime'],
      status: json['status'],
      requiresCashCollection:
          json['isCash'] as bool? ?? json['requiresCashCollection'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'bookingCode': bookingCode,
      'customerName': customerName,
      'serviceName': serviceName,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'requiresCashCollection': requiresCashCollection,
    };
  }
}
