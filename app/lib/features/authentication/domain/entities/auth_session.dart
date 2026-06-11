import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    required this.authProvider,
    this.avatar,
    required this.isActive,
    required this.acceptedTermsAt,
    required this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String fullName;
  final String email;
  final String? phone;
  final String role;
  final String authProvider;
  final String? avatar;
  final bool isActive;
  final String? acceptedTermsAt;
  final String? lastLoginAt;
  final String? createdAt;
  final String? updatedAt;

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        phone,
        role,
        authProvider,
        avatar,
        isActive,
        acceptedTermsAt,
        lastLoginAt,
        createdAt,
        updatedAt,
      ];
}

class AuthTokens extends Equatable {
  const AuthTokens({
    required this.tokenType,
    required this.accessToken,
    required this.refreshToken,
  });

  final String tokenType;
  final String accessToken;
  final String refreshToken;

  @override
  List<Object?> get props => [
        tokenType,
        accessToken,
        refreshToken,
      ];
}

class AuthSession extends Equatable {
  const AuthSession({
    required this.user,
    required this.tokens,
  });

  final AuthUser user;
  final AuthTokens tokens;

  @override
  List<Object?> get props => [
        user,
        tokens,
      ];
}
