import 'dart:convert';

import 'package:app/features/authentication/domain/entities/auth_session.dart';

class SignInRequestModel {
  const SignInRequestModel({
    required this.identifier,
    required this.password,
  });

  final String identifier;
  final String password;

  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'password': password,
      };
}

class SignUpRequestModel {
  const SignUpRequestModel({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.confirmPassword,
    required this.acceptTerms,
  });

  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String confirmPassword;
  final bool acceptTerms;

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'password': password,
        'confirmPassword': confirmPassword,
        'acceptTerms': acceptTerms,
      };
}

class ZaloLoginRequestModel {
  const ZaloLoginRequestModel({
    this.oauthCode,
    this.accessToken,
    this.codeVerifier,
  });

  final String? oauthCode;
  final String? accessToken;
  final String? codeVerifier;

  Map<String, dynamic> toJson() => {
        if (oauthCode != null && oauthCode!.isNotEmpty) 'oauthCode': oauthCode,
        if (accessToken != null && accessToken!.isNotEmpty)
          'accessToken': accessToken,
        if (codeVerifier != null && codeVerifier!.isNotEmpty)
          'codeVerifier': codeVerifier,
      };
}

class AuthApiResponseModel {
  const AuthApiResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthApiResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthApiResponseModel(
      success: json['success'] == true,
      message: json['message'] as String? ?? '',
      data: AuthSessionModel.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      ),
    );
  }

  final bool success;
  final String message;
  final AuthSessionModel data;
}

class AuthSessionModel {
  const AuthSessionModel({
    required this.user,
    required this.tokens,
  });

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      user: AuthUserModel.fromJson(
        Map<String, dynamic>.from(json['user'] as Map),
      ),
      tokens: AuthTokensModel.fromJson(
        Map<String, dynamic>.from(json['tokens'] as Map),
      ),
    );
  }

  final AuthUserModel user;
  final AuthTokensModel tokens;

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'tokens': tokens.toJson(),
      };

  AuthSession toEntity() => AuthSession(
        user: user.toEntity(),
        tokens: tokens.toEntity(),
      );

  String encodeUserJson() => jsonEncode(user.toJson());
}

class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.authProvider,
    required this.isActive,
    required this.acceptedTermsAt,
    required this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      role: json['role'] as String? ?? 'customer',
      authProvider: json['authProvider'] as String? ?? 'local',
      isActive: json['isActive'] == true,
      acceptedTermsAt: json['acceptedTermsAt'] as String?,
      lastLoginAt: json['lastLoginAt'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String role;
  final String authProvider;
  final bool isActive;
  final String? acceptedTermsAt;
  final String? lastLoginAt;
  final String? createdAt;
  final String? updatedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'phone': phone,
        'role': role,
        'authProvider': authProvider,
        'isActive': isActive,
        'acceptedTermsAt': acceptedTermsAt,
        'lastLoginAt': lastLoginAt,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  AuthUser toEntity() => AuthUser(
        id: id,
        fullName: fullName,
        email: email,
        phone: phone,
        role: role,
        authProvider: authProvider,
        isActive: isActive,
        acceptedTermsAt: acceptedTermsAt,
        lastLoginAt: lastLoginAt,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

class AuthTokensModel {
  const AuthTokensModel({
    required this.tokenType,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) {
    return AuthTokensModel(
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
    );
  }

  final String tokenType;
  final String accessToken;
  final String refreshToken;

  Map<String, dynamic> toJson() => {
        'tokenType': tokenType,
        'accessToken': accessToken,
        'refreshToken': refreshToken,
      };

  AuthTokens toEntity() => AuthTokens(
        tokenType: tokenType,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
}
