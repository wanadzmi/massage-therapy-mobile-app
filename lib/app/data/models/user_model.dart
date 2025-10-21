class User {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final bool? isPhoneVerified;
  final bool? isEmailVerified;
  final String? memberTier;
  final DateTime? memberSince;
  final DateTime? dateOfBirth;
  final String? gender;
  final EmergencyContact? emergencyContact;
  final Wallet? wallet;
  final LoyaltyPoints? loyaltyPoints;
  final Referral? referral;
  final Preferences? preferences;
  final List<Address>? addresses;
  final BookingStats? bookingStats;
  final TierBenefits? tierBenefits;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.isPhoneVerified,
    this.isEmailVerified,
    this.memberTier,
    this.memberSince,
    this.dateOfBirth,
    this.gender,
    this.emergencyContact,
    this.wallet,
    this.loyaltyPoints,
    this.referral,
    this.preferences,
    this.addresses,
    this.bookingStats,
    this.tierBenefits,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      isPhoneVerified: json['isPhoneVerified'],
      isEmailVerified: json['isEmailVerified'],
      memberTier: json['memberTier'],
      memberSince: json['memberSince'] != null
          ? DateTime.parse(json['memberSince'])
          : null,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      gender: json['gender'],
      emergencyContact: json['emergencyContact'] != null
          ? EmergencyContact.fromJson(json['emergencyContact'])
          : null,
      wallet: json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null,
      loyaltyPoints: json['loyaltyPoints'] != null
          ? LoyaltyPoints.fromJson(json['loyaltyPoints'])
          : null,
      referral: json['referral'] != null
          ? Referral.fromJson(json['referral'])
          : null,
      preferences: json['preferences'] != null
          ? Preferences.fromJson(json['preferences'])
          : null,
      addresses: json['addresses'] != null
          ? (json['addresses'] as List).map((a) => Address.fromJson(a)).toList()
          : null,
      bookingStats: json['bookingStats'] != null
          ? BookingStats.fromJson(json['bookingStats'])
          : null,
      tierBenefits: json['tierBenefits'] != null
          ? TierBenefits.fromJson(json['tierBenefits'])
          : null,
      profileImage: json['profileImage'] ?? json['profile_image'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : (json['created_at'] != null
                ? DateTime.parse(json['created_at'])
                : null),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : (json['updated_at'] != null
                ? DateTime.parse(json['updated_at'])
                : null),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'isPhoneVerified': isPhoneVerified,
      'isEmailVerified': isEmailVerified,
      'memberTier': memberTier,
      'memberSince': memberSince?.toIso8601String(),
      'dateOfBirth': dateOfBirth != null
          ? dateOfBirth!.toIso8601String().split('T')[0]
          : null,
      'gender': gender,
      'emergencyContact': emergencyContact?.toJson(),
      'wallet': wallet?.toJson(),
      'loyaltyPoints': loyaltyPoints?.toJson(),
      'referral': referral?.toJson(),
      'preferences': preferences?.toJson(),
      'addresses': addresses?.map((a) => a.toJson()).toList(),
      'bookingStats': bookingStats?.toJson(),
      'tierBenefits': tierBenefits?.toJson(),
      'profileImage': profileImage,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    bool? isPhoneVerified,
    bool? isEmailVerified,
    String? memberTier,
    DateTime? memberSince,
    DateTime? dateOfBirth,
    String? gender,
    EmergencyContact? emergencyContact,
    Wallet? wallet,
    LoyaltyPoints? loyaltyPoints,
    Referral? referral,
    Preferences? preferences,
    List<Address>? addresses,
    BookingStats? bookingStats,
    TierBenefits? tierBenefits,
    String? profileImage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      memberTier: memberTier ?? this.memberTier,
      memberSince: memberSince ?? this.memberSince,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      wallet: wallet ?? this.wallet,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      referral: referral ?? this.referral,
      preferences: preferences ?? this.preferences,
      addresses: addresses ?? this.addresses,
      bookingStats: bookingStats ?? this.bookingStats,
      tierBenefits: tierBenefits ?? this.tierBenefits,
      profileImage: profileImage ?? this.profileImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Wallet {
  final double? balance;
  final String? currency;

  Wallet({this.balance, this.currency});

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance: json['balance']?.toDouble(),
      currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'balance': balance, 'currency': currency};
  }
}

class TierBenefits {
  final int? discount;
  final int? pointsMultiplier;

  TierBenefits({this.discount, this.pointsMultiplier});

  factory TierBenefits.fromJson(Map<String, dynamic> json) {
    return TierBenefits(
      discount: json['discount']?.toInt(),
      pointsMultiplier: json['pointsMultiplier']?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'discount': discount, 'pointsMultiplier': pointsMultiplier};
  }
}

class LoyaltyPoints {
  final int? balance;
  final int? totalEarned;
  final int? totalRedeemed;

  LoyaltyPoints({this.balance, this.totalEarned, this.totalRedeemed});

  factory LoyaltyPoints.fromJson(Map<String, dynamic> json) {
    return LoyaltyPoints(
      balance: json['balance']?.toInt(),
      totalEarned: json['totalEarned']?.toInt(),
      totalRedeemed: json['totalRedeemed']?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'totalEarned': totalEarned,
      'totalRedeemed': totalRedeemed,
    };
  }
}

class Referral {
  final String? code;
  final bool? isActive;
  final int? totalReferrals;
  final int? successfulReferrals;
  final double? referralEarnings;

  Referral({
    this.code,
    this.isActive,
    this.totalReferrals,
    this.successfulReferrals,
    this.referralEarnings,
  });

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      code: json['code'],
      isActive: json['isActive'],
      totalReferrals: json['totalReferrals']?.toInt(),
      successfulReferrals: json['successfulReferrals']?.toInt(),
      referralEarnings: json['referralEarnings']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'isActive': isActive,
      'totalReferrals': totalReferrals,
      'successfulReferrals': successfulReferrals,
      'referralEarnings': referralEarnings,
    };
  }
}

class Preferences {
  final NotificationPreferences? notifications;
  final String? language;
  final String? currency;
  final String? timezone;

  Preferences({
    this.notifications,
    this.language,
    this.currency,
    this.timezone,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      notifications: json['notifications'] != null
          ? NotificationPreferences.fromJson(json['notifications'])
          : null,
      language: json['language'],
      currency: json['currency'],
      timezone: json['timezone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications?.toJson(),
      'language': language,
      'currency': currency,
      'timezone': timezone,
    };
  }
}

class NotificationPreferences {
  final bool? email;
  final bool? sms;
  final bool? push;
  final bool? marketing;

  NotificationPreferences({this.email, this.sms, this.push, this.marketing});

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      email: json['email'],
      sms: json['sms'],
      push: json['push'],
      marketing: json['marketing'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'sms': sms, 'push': push, 'marketing': marketing};
  }
}

class Address {
  final String? id;
  final String? type;
  final String? street;
  final String? city;
  final String? state;
  final String? postcode;
  final String? country;
  final bool? isDefault;

  Address({
    this.id,
    this.type,
    this.street,
    this.city,
    this.state,
    this.postcode,
    this.country,
    this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      type: json['type'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      postcode: json['postcode'],
      country: json['country'],
      isDefault: json['isDefault'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'street': street,
      'city': city,
      'state': state,
      'postcode': postcode,
      'country': country,
      'isDefault': isDefault,
    };
  }
}

class BookingStats {
  final int? totalBookings;
  final int? completedBookings;
  final int? cancelledBookings;
  final double? totalSpent;
  final double? averageRating;

  BookingStats({
    this.totalBookings,
    this.completedBookings,
    this.cancelledBookings,
    this.totalSpent,
    this.averageRating,
  });

  factory BookingStats.fromJson(Map<String, dynamic> json) {
    return BookingStats(
      totalBookings: json['totalBookings']?.toInt(),
      completedBookings: json['completedBookings']?.toInt(),
      cancelledBookings: json['cancelledBookings']?.toInt(),
      totalSpent: json['totalSpent']?.toDouble(),
      averageRating: json['averageRating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBookings': totalBookings,
      'completedBookings': completedBookings,
      'cancelledBookings': cancelledBookings,
      'totalSpent': totalSpent,
      'averageRating': averageRating,
    };
  }
}

class EmergencyContact {
  final String? name;
  final String? phone;
  final String? relationship;

  EmergencyContact({this.name, this.phone, this.relationship});

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'],
      phone: json['phone'],
      relationship: json['relationship'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'phone': phone, 'relationship': relationship};
  }
}
