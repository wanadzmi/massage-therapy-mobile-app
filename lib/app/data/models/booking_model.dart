class Booking {
  final String? id;
  final String? bookingCode;
  final String? user;
  final BookingTherapist? therapist;
  final BookingService? service;
  final BookingStore? store;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  final String? status; // pending, confirmed, in_progress, completed, cancelled
  final BookingDuration? duration;
  final BookingPricing? pricing;
  final BookingPayment? payment;
  final BookingNotes? notes;
  final BookingRescheduleData? rescheduleData;
  final BookingCancellation? cancellation;
  final BookingCheckin? checkin;
  final BookingCheckout? checkout;
  final BookingReminders? reminders;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Booking({
    this.id,
    this.bookingCode,
    this.user,
    this.therapist,
    this.service,
    this.store,
    this.date,
    this.startTime,
    this.endTime,
    this.status,
    this.duration,
    this.pricing,
    this.payment,
    this.notes,
    this.rescheduleData,
    this.cancellation,
    this.checkin,
    this.checkout,
    this.reminders,
    this.createdAt,
    this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? json['id'],
      bookingCode: json['bookingCode'],
      user: json['user'],
      therapist: json['therapist'] != null
          ? BookingTherapist.fromJson(json['therapist'])
          : null,
      service: json['service'] != null
          ? BookingService.fromJson(json['service'])
          : null,
      store: json['store'] != null
          ? BookingStore.fromJson(json['store'])
          : null,
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
      startTime: json['startTime'],
      endTime: json['endTime'],
      status: json['status'],
      duration: json['duration'] != null
          ? BookingDuration.fromJson(json['duration'])
          : null,
      pricing: json['pricing'] != null
          ? BookingPricing.fromJson(json['pricing'])
          : null,
      payment: json['payment'] != null
          ? BookingPayment.fromJson(json['payment'])
          : null,
      notes: json['notes'] != null
          ? BookingNotes.fromJson(json['notes'])
          : null,
      rescheduleData: json['rescheduleData'] != null
          ? BookingRescheduleData.fromJson(json['rescheduleData'])
          : null,
      cancellation: json['cancellation'] != null
          ? BookingCancellation.fromJson(json['cancellation'])
          : null,
      checkin: json['checkin'] != null
          ? BookingCheckin.fromJson(json['checkin'])
          : null,
      checkout: json['checkout'] != null
          ? BookingCheckout.fromJson(json['checkout'])
          : null,
      reminders: json['reminders'] != null
          ? BookingReminders.fromJson(json['reminders'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'bookingCode': bookingCode,
      'user': user,
      'therapist': therapist?.toJson(),
      'service': service?.toJson(),
      'store': store?.toJson(),
      'date': date?.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'duration': duration?.toJson(),
      'pricing': pricing?.toJson(),
      'payment': payment?.toJson(),
      'notes': notes?.toJson(),
      'rescheduleData': rescheduleData?.toJson(),
      'cancellation': cancellation?.toJson(),
      'checkin': checkin?.toJson(),
      'checkout': checkout?.toJson(),
      'reminders': reminders?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class BookingDuration {
  final int? minutes;
  final String? display;

  BookingDuration({this.minutes, this.display});

  factory BookingDuration.fromJson(Map<String, dynamic> json) {
    return BookingDuration(minutes: json['minutes'], display: json['display']);
  }

  Map<String, dynamic> toJson() {
    return {'minutes': minutes, 'display': display};
  }
}

class BookingTherapist {
  final String? id;
  final String? name;
  final String? profileImage;
  final String? displayName;
  final bool? isLocked;
  final TherapistInfo? therapistInfo;
  final TierBenefits? tierBenefits;

  BookingTherapist({
    this.id,
    this.name,
    this.profileImage,
    this.displayName,
    this.isLocked,
    this.therapistInfo,
    this.tierBenefits,
  });

  factory BookingTherapist.fromJson(Map<String, dynamic> json) {
    return BookingTherapist(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      profileImage: json['profileImage'],
      displayName: json['displayName'],
      isLocked: json['isLocked'],
      therapistInfo: json['therapistInfo'] != null
          ? TherapistInfo.fromJson(json['therapistInfo'])
          : null,
      tierBenefits: json['tierBenefits'] != null
          ? TierBenefits.fromJson(json['tierBenefits'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'profileImage': profileImage,
      'displayName': displayName,
      'isLocked': isLocked,
      'therapistInfo': therapistInfo?.toJson(),
      'tierBenefits': tierBenefits?.toJson(),
    };
  }
}

class TherapistInfo {
  final TherapistRating? rating;

  TherapistInfo({this.rating});

  factory TherapistInfo.fromJson(Map<String, dynamic> json) {
    return TherapistInfo(
      rating: json['rating'] != null
          ? TherapistRating.fromJson(json['rating'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'rating': rating?.toJson()};
  }
}

class TherapistRating {
  final double? average;
  final int? count;

  TherapistRating({this.average, this.count});

  factory TherapistRating.fromJson(Map<String, dynamic> json) {
    return TherapistRating(
      average: json['average']?.toDouble(),
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'average': average, 'count': count};
  }
}

class TierBenefits {
  final int? discount;
  final int? pointsMultiplier;

  TierBenefits({this.discount, this.pointsMultiplier});

  factory TierBenefits.fromJson(Map<String, dynamic> json) {
    return TierBenefits(
      discount: json['discount'],
      pointsMultiplier: json['pointsMultiplier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'discount': discount, 'pointsMultiplier': pointsMultiplier};
  }
}

class BookingService {
  final String? id;
  final String? name;
  final String? category;
  final ServiceDuration? duration;
  final ServicePricing? pricing;
  final double? pricePerMinute;
  final bool? hasDiscount;
  final int? discountPercentage;

  BookingService({
    this.id,
    this.name,
    this.category,
    this.duration,
    this.pricing,
    this.pricePerMinute,
    this.hasDiscount,
    this.discountPercentage,
  });

  factory BookingService.fromJson(Map<String, dynamic> json) {
    return BookingService(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      category: json['category'],
      duration: json['duration'] != null
          ? ServiceDuration.fromJson(json['duration'])
          : null,
      pricing: json['pricing'] != null
          ? ServicePricing.fromJson(json['pricing'])
          : null,
      pricePerMinute: json['pricePerMinute']?.toDouble(),
      hasDiscount: json['hasDiscount'],
      discountPercentage: json['discountPercentage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'category': category,
      'duration': duration?.toJson(),
      'pricing': pricing?.toJson(),
      'pricePerMinute': pricePerMinute,
      'hasDiscount': hasDiscount,
      'discountPercentage': discountPercentage,
    };
  }
}

class ServiceDuration {
  final int? minutes;
  final String? display;

  ServiceDuration({this.minutes, this.display});

  factory ServiceDuration.fromJson(Map<String, dynamic> json) {
    return ServiceDuration(minutes: json['minutes'], display: json['display']);
  }

  Map<String, dynamic> toJson() {
    return {'minutes': minutes, 'display': display};
  }
}

class ServicePricing {
  final double? price;
  final String? currency;
  final double? discountPrice;

  ServicePricing({this.price, this.currency, this.discountPrice});

  factory ServicePricing.fromJson(Map<String, dynamic> json) {
    return ServicePricing(
      price: json['price']?.toDouble(),
      currency: json['currency'],
      discountPrice: json['discountPrice']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'currency': currency,
      'discountPrice': discountPrice,
    };
  }
}

class BookingStore {
  final String? id;
  final String? name;
  final StoreAddress? address;
  final List<String>? images;
  final String? fullAddress;
  final bool? isCurrentlyOpen;

  BookingStore({
    this.id,
    this.name,
    this.address,
    this.images,
    this.fullAddress,
    this.isCurrentlyOpen,
  });

  factory BookingStore.fromJson(Map<String, dynamic> json) {
    return BookingStore(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      address: json['address'] != null
          ? StoreAddress.fromJson(json['address'])
          : null,
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      fullAddress: json['fullAddress'],
      isCurrentlyOpen: json['isCurrentlyOpen'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'address': address?.toJson(),
      'images': images,
      'fullAddress': fullAddress,
      'isCurrentlyOpen': isCurrentlyOpen,
    };
  }
}

class StoreAddress {
  final String? street;
  final String? area;
  final String? city;
  final String? state;
  final String? postcode;
  final String? country;

  StoreAddress({
    this.street,
    this.area,
    this.city,
    this.state,
    this.postcode,
    this.country,
  });

  factory StoreAddress.fromJson(Map<String, dynamic> json) {
    return StoreAddress(
      street: json['street'],
      area: json['area'],
      city: json['city'],
      state: json['state'],
      postcode: json['postcode'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'area': area,
      'city': city,
      'state': state,
      'postcode': postcode,
      'country': country,
    };
  }
}

class BookingPricing {
  final double? servicePrice;
  final double? discountAmount;
  final double? voucherDiscount;
  final int? loyaltyPointsUsed;
  final double? loyaltyPointsValue;
  final double? totalAmount;
  final int? loyaltyPointsEarned;

  BookingPricing({
    this.servicePrice,
    this.discountAmount,
    this.voucherDiscount,
    this.loyaltyPointsUsed,
    this.loyaltyPointsValue,
    this.totalAmount,
    this.loyaltyPointsEarned,
  });

  factory BookingPricing.fromJson(Map<String, dynamic> json) {
    return BookingPricing(
      servicePrice: json['servicePrice']?.toDouble(),
      discountAmount: json['discountAmount']?.toDouble(),
      voucherDiscount: json['voucherDiscount']?.toDouble(),
      loyaltyPointsUsed: json['loyaltyPointsUsed'],
      loyaltyPointsValue: json['loyaltyPointsValue']?.toDouble(),
      totalAmount: json['totalAmount']?.toDouble(),
      loyaltyPointsEarned: json['loyaltyPointsEarned'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'servicePrice': servicePrice,
      'discountAmount': discountAmount,
      'voucherDiscount': voucherDiscount,
      'loyaltyPointsUsed': loyaltyPointsUsed,
      'loyaltyPointsValue': loyaltyPointsValue,
      'totalAmount': totalAmount,
      'loyaltyPointsEarned': loyaltyPointsEarned,
    };
  }
}

class BookingPayment {
  final String? method;
  final String? status;
  final String? transactionId;
  final DateTime? paidAt;
  final DateTime? refundedAt;

  BookingPayment({
    this.method,
    this.status,
    this.transactionId,
    this.paidAt,
    this.refundedAt,
  });

  factory BookingPayment.fromJson(Map<String, dynamic> json) {
    return BookingPayment(
      method: json['method'],
      status: json['status'],
      transactionId: json['transactionId'],
      paidAt: json['paidAt'] != null ? DateTime.parse(json['paidAt']) : null,
      refundedAt: json['refundedAt'] != null
          ? DateTime.parse(json['refundedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'status': status,
      'transactionId': transactionId,
      'paidAt': paidAt?.toIso8601String(),
      'refundedAt': refundedAt?.toIso8601String(),
    };
  }
}

class BookingNotes {
  final String? customerNotes;
  final String? therapistNotes;
  final String? adminNotes;

  BookingNotes({this.customerNotes, this.therapistNotes, this.adminNotes});

  factory BookingNotes.fromJson(Map<String, dynamic> json) {
    return BookingNotes(
      customerNotes: json['customerNotes'],
      therapistNotes: json['therapistNotes'],
      adminNotes: json['adminNotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerNotes': customerNotes,
      'therapistNotes': therapistNotes,
      'adminNotes': adminNotes,
    };
  }
}

class BookingRescheduleData {
  final int? rescheduleCount;

  BookingRescheduleData({this.rescheduleCount});

  factory BookingRescheduleData.fromJson(Map<String, dynamic> json) {
    return BookingRescheduleData(rescheduleCount: json['rescheduleCount']);
  }

  Map<String, dynamic> toJson() {
    return {'rescheduleCount': rescheduleCount};
  }
}

class BookingCancellation {
  final bool? refundEligible;
  final String? cancelledBy;
  final String? reason;
  final DateTime? cancelledAt;

  BookingCancellation({
    this.refundEligible,
    this.cancelledBy,
    this.reason,
    this.cancelledAt,
  });

  factory BookingCancellation.fromJson(Map<String, dynamic> json) {
    return BookingCancellation(
      refundEligible: json['refundEligible'],
      cancelledBy: json['cancelledBy'],
      reason: json['reason'],
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refundEligible': refundEligible,
      'cancelledBy': cancelledBy,
      'reason': reason,
      'cancelledAt': cancelledAt?.toIso8601String(),
    };
  }
}

class BookingCheckin {
  final DateTime? checkedInAt;
  final String? checkedInBy;

  BookingCheckin({this.checkedInAt, this.checkedInBy});

  factory BookingCheckin.fromJson(Map<String, dynamic> json) {
    return BookingCheckin(
      checkedInAt: json['checkedInAt'] != null
          ? DateTime.parse(json['checkedInAt'])
          : null,
      checkedInBy: json['checkedInBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checkedInAt': checkedInAt?.toIso8601String(),
      'checkedInBy': checkedInBy,
    };
  }
}

class BookingCheckout {
  final DateTime? checkedOutAt;
  final bool? serviceCompleted;
  final int? customerSatisfaction;

  BookingCheckout({
    this.checkedOutAt,
    this.serviceCompleted,
    this.customerSatisfaction,
  });

  factory BookingCheckout.fromJson(Map<String, dynamic> json) {
    return BookingCheckout(
      checkedOutAt: json['checkedOutAt'] != null
          ? DateTime.parse(json['checkedOutAt'])
          : null,
      serviceCompleted: json['serviceCompleted'],
      customerSatisfaction: json['customerSatisfaction'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'checkedOutAt': checkedOutAt?.toIso8601String(),
      'serviceCompleted': serviceCompleted,
      'customerSatisfaction': customerSatisfaction,
    };
  }
}

class BookingReminders {
  final bool? sent24h;
  final bool? sent2h;
  final bool? sentConfirmation;

  BookingReminders({this.sent24h, this.sent2h, this.sentConfirmation});

  factory BookingReminders.fromJson(Map<String, dynamic> json) {
    return BookingReminders(
      sent24h: json['sent24h'],
      sent2h: json['sent2h'],
      sentConfirmation: json['sentConfirmation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sent24h': sent24h,
      'sent2h': sent2h,
      'sentConfirmation': sentConfirmation,
    };
  }
}
