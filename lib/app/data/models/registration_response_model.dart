class RegistrationResponse {
  final String? message;
  final RegistrationData? data;

  RegistrationResponse({this.message, this.data});

  factory RegistrationResponse.fromJson(Map<String, dynamic> json) {
    return RegistrationResponse(
      message: json['message'],
      data: json['data'] != null
          ? RegistrationData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data?.toJson()};
  }
}

class RegistrationData {
  final String? userId;
  final String? phone;
  final String? name;
  final bool? isPhoneVerified;
  final String? nextStep;
  final String? devOTP;
  final String? devMessage;

  RegistrationData({
    this.userId,
    this.phone,
    this.name,
    this.isPhoneVerified,
    this.nextStep,
    this.devOTP,
    this.devMessage,
  });

  factory RegistrationData.fromJson(Map<String, dynamic> json) {
    return RegistrationData(
      userId: json['userId'],
      phone: json['phone'],
      name: json['name'],
      isPhoneVerified: json['isPhoneVerified'],
      nextStep: json['nextStep'],
      devOTP: json['devOTP'],
      devMessage: json['devMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'phone': phone,
      'name': name,
      'isPhoneVerified': isPhoneVerified,
      'nextStep': nextStep,
      'devOTP': devOTP,
      'devMessage': devMessage,
    };
  }
}

class OTPVerificationResponse {
  final String? message;
  final OTPVerificationData? data;

  OTPVerificationResponse({this.message, this.data});

  factory OTPVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OTPVerificationResponse(
      message: json['message'],
      data: json['data'] != null
          ? OTPVerificationData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'data': data?.toJson()};
  }
}

class OTPVerificationData {
  final String? token;
  final Map<String, dynamic>? user;

  OTPVerificationData({this.token, this.user});

  factory OTPVerificationData.fromJson(Map<String, dynamic> json) {
    return OTPVerificationData(token: json['token'], user: json['user']);
  }

  Map<String, dynamic> toJson() {
    return {'token': token, 'user': user};
  }
}
