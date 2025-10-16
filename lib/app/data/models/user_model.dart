class User {
  final String? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? role;
  final bool? isPhoneVerified;
  final bool? isEmailVerified;
  final String? memberTier;
  final Wallet? wallet;
  final String? referralCode;
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
    this.wallet,
    this.referralCode,
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
      wallet: json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null,
      referralCode: json['referralCode'],
      tierBenefits: json['tierBenefits'] != null
          ? TierBenefits.fromJson(json['tierBenefits'])
          : null,
      profileImage: json['profile_image'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
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
      'wallet': wallet?.toJson(),
      'referralCode': referralCode,
      'tierBenefits': tierBenefits?.toJson(),
      'profile_image': profileImage,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
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
    Wallet? wallet,
    String? referralCode,
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
      wallet: wallet ?? this.wallet,
      referralCode: referralCode ?? this.referralCode,
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
      discount: json['discount'],
      pointsMultiplier: json['pointsMultiplier'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'discount': discount, 'pointsMultiplier': pointsMultiplier};
  }
}
