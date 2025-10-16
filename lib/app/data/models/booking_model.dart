class Booking {
  final String? id;
  final String? userId;
  final String? serviceId;
  final DateTime? appointmentDate;
  final String? appointmentTime;
  final String? status; // pending, confirmed, completed, cancelled
  final String? notes;
  final double? totalAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Related objects
  final String? serviceName;
  final String? userName;

  Booking({
    this.id,
    this.userId,
    this.serviceId,
    this.appointmentDate,
    this.appointmentTime,
    this.status,
    this.notes,
    this.totalAmount,
    this.createdAt,
    this.updatedAt,
    this.serviceName,
    this.userName,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      serviceId: json['service_id'],
      appointmentDate: json['appointment_date'] != null
          ? DateTime.parse(json['appointment_date'])
          : null,
      appointmentTime: json['appointment_time'],
      status: json['status'],
      notes: json['notes'],
      totalAmount: json['total_amount']?.toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      serviceName: json['service_name'],
      userName: json['user_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'appointment_date': appointmentDate?.toIso8601String(),
      'appointment_time': appointmentTime,
      'status': status,
      'notes': notes,
      'total_amount': totalAmount,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'service_name': serviceName,
      'user_name': userName,
    };
  }
}
