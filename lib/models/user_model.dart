class User {
  final String id;
  final String phoneNumber;
  final String fullName;
  final String email;
  String? gender;
  DateTime? dateOfBirth;

  final bool isActive;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.email,
    this.gender,
    this.dateOfBirth,
    required this.isActive,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
    this.lastLogin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      phoneNumber: json['phone_number'],
      fullName: json["full_name"] ?? "",
      isActive: json['is_active'] ?? true,
      isVerified: json['is_verified'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'])
          : null,
      email: json["email"] ?? "",
      gender: json["gender"] ?? "",
      dateOfBirth: json["date_of_birth"] != null
          ? DateTime.parse(json["date_of_birth"])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'full_name': fullName,
      'is_active': isActive,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
    };
  }

  String get displayName => fullName;
}

class AuthResponse {
  final String accessToken;
  final String refreshToken;
  final User user;
  final String tokenType;

  AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.tokenType = 'bearer',
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      user: User.fromJson(json['user']),
      tokenType: json['token_type'] ?? 'bearer',
    );
  }
}

class SendOTPRequest {
  final String phoneNumber;
  final String purpose;

  SendOTPRequest({required this.phoneNumber, this.purpose = 'login'});

  Map<String, dynamic> toJson() {
    return {'phone_number': phoneNumber, 'purpose': purpose};
  }
}

class VerifyOTPRequest {
  final String phoneNumber;
  final String otpCode;
  final String? fullName;

  VerifyOTPRequest({
    required this.phoneNumber,
    required this.otpCode,
    this.fullName,
  });

  Map<String, dynamic> toJson() {
    final data = {'phone_number': phoneNumber, 'otp_code': otpCode};
    if (fullName != null) data['full_name'] = fullName!;

    return data;
  }
}

class OTPResponse {
  final String message;
  final int expiresIn;
  final int canResendIn;

  OTPResponse({
    required this.message,
    required this.expiresIn,
    required this.canResendIn,
  });

  factory OTPResponse.fromJson(Map<String, dynamic> json) {
    return OTPResponse(
      message: json['message'],
      expiresIn: json['expires_in'],
      canResendIn: json['can_resend_in'],
    );
  }
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {'refresh_token': refreshToken};
  }
}

class UserUpdateRequest {
  final String fullName;
  final String email;
  final String gender;
  final String dateOfBirth;

  UserUpdateRequest({
    this.fullName = "",
    this.gender = "",
    this.email = "",
    this.dateOfBirth = "",
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (fullName != "") data['full_name'] = fullName;
    if (email != "") data['email'] = email;
    if (gender != "") data["gender"] = gender;
    if (dateOfBirth != "") data['date_of_birth'] = dateOfBirth;
    return data;
  }

  UserUpdateRequest copyWith({
    String? fullName,
    String? email,
    String? gender,
    String? dateOfBirth,
  }) {
    return UserUpdateRequest(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }
}

class UpdateUserResponse {
  final User user;
  final String accessToken;

  UpdateUserResponse({
    required this.user,
    required this.accessToken,
  });

  factory UpdateUserResponse.fromJson(Map<String, dynamic> json) {
    return UpdateUserResponse(
      user: User.fromJson(json['user']),
      accessToken: json['access_token'],
    );
  }
}
