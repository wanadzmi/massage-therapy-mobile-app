class Booking {
  final String? id;
  final String? bookingCode;
  final BookingCustomer? customer;
  final BookingTherapist? therapist;
  final BookingService? service;
  final BookingStore? store;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  final String? status; // pending, confirmed, in_progress, completed, cancelled
  final BookingPayment? payment;
  final BookingPreferences? preferences;
  final String? notes;
  final BookingCancellation? cancellation;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Booking({
    this.id,
    this.bookingCode,
    this.customer,
    this.therapist,
    this.service,
    this.store,
    this.date,
    this.startTime,
    this.endTime,
    this.status,
    this.payment,
    this.preferences,
    this.notes,
    this.cancellation,
    this.createdAt,
    this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['_id'] ?? json['id'],
      bookingCode: json['bookingCode'],
      customer: json['customer'] != null
          ? BookingCustomer.fromJson(json['customer'])
          : null,
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
      payment: json['payment'] != null
          ? BookingPayment.fromJson(json['payment'])
          : null,
      preferences: json['preferences'] != null
          ? BookingPreferences.fromJson(json['preferences'])
          : null,
      notes: json['notes'],
      cancellation: json['cancellation'] != null
          ? BookingCancellation.fromJson(json['cancellation'])
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
      'customer': customer?.toJson(),
      'therapist': therapist?.toJson(),
      'service': service?.toJson(),
      'store': store?.toJson(),
      'date': date?.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'payment': payment?.toJson(),
      'preferences': preferences?.toJson(),
      'notes': notes,
      'cancellation': cancellation?.toJson(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class BookingCustomer {
  final String? id;
  final String? name;
  final String? phone;

  BookingCustomer({this.id, this.name, this.phone});

  factory BookingCustomer.fromJson(Map<String, dynamic> json) {
    return BookingCustomer(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'phone': phone};
  }
}

class BookingTherapist {
  final String? id;
  final String? name;
  final String? profilePicture;

  BookingTherapist({this.id, this.name, this.profilePicture});

  factory BookingTherapist.fromJson(Map<String, dynamic> json) {
    return BookingTherapist(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      profilePicture: json['profilePicture'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'profilePicture': profilePicture};
  }
}

class BookingService {
  final String? id;
  final String? name;
  final int? duration;

  BookingService({this.id, this.name, this.duration});

  factory BookingService.fromJson(Map<String, dynamic> json) {
    return BookingService(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'duration': duration};
  }
}

class BookingStore {
  final String? id;
  final String? name;
  final String? address;

  BookingStore({this.id, this.name, this.address});

  factory BookingStore.fromJson(Map<String, dynamic> json) {
    return BookingStore(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'address': address};
  }
}

class BookingPayment {
  final String? method;
  final double? subtotal;
  final BookingDiscount? discount;
  final double? total;
  final String? status;

  BookingPayment({
    this.method,
    this.subtotal,
    this.discount,
    this.total,
    this.status,
  });

  factory BookingPayment.fromJson(Map<String, dynamic> json) {
    return BookingPayment(
      method: json['method'],
      subtotal: json['subtotal']?.toDouble(),
      discount: json['discount'] != null
          ? BookingDiscount.fromJson(json['discount'])
          : null,
      total: json['total']?.toDouble(),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'method': method,
      'subtotal': subtotal,
      'discount': discount?.toJson(),
      'total': total,
      'status': status,
    };
  }
}

class BookingDiscount {
  final double? amount;
  final String? type;
  final String? details;

  BookingDiscount({this.amount, this.type, this.details});

  factory BookingDiscount.fromJson(Map<String, dynamic> json) {
    return BookingDiscount(
      amount: json['amount']?.toDouble(),
      type: json['type'],
      details: json['details'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'amount': amount, 'type': type, 'details': details};
  }
}

class BookingPreferences {
  final String? pressure;
  final List<String>? focus;

  BookingPreferences({this.pressure, this.focus});

  factory BookingPreferences.fromJson(Map<String, dynamic> json) {
    return BookingPreferences(
      pressure: json['pressure'],
      focus: json['focus'] != null ? List<String>.from(json['focus']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'pressure': pressure, 'focus': focus};
  }
}

class BookingCancellation {
  final String? cancelledBy;
  final String? reason;
  final DateTime? cancelledAt;

  BookingCancellation({this.cancelledBy, this.reason, this.cancelledAt});

  factory BookingCancellation.fromJson(Map<String, dynamic> json) {
    return BookingCancellation(
      cancelledBy: json['cancelledBy'],
      reason: json['reason'],
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cancelledBy': cancelledBy,
      'reason': reason,
      'cancelledAt': cancelledAt?.toIso8601String(),
    };
  }
}
