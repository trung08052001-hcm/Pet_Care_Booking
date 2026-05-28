import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => const [];
}

final class AuthSessionRestoreRequested extends AuthEvent {
  const AuthSessionRestoreRequested();
}

final class AuthSignInRequested extends AuthEvent {
  const AuthSignInRequested({
    required this.identifier,
    required this.password,
  });

  final String identifier;
  final String password;

  @override
  List<Object?> get props => [
        identifier,
        password,
      ];
}

final class AuthSignUpRequested extends AuthEvent {
  const AuthSignUpRequested({
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

  @override
  List<Object?> get props => [
        fullName,
        email,
        phone,
        password,
        confirmPassword,
        acceptTerms,
      ];
}

final class AuthSignInWithZaloRequested extends AuthEvent {
  const AuthSignInWithZaloRequested({
    this.oauthCode,
    this.accessToken,
    this.codeVerifier,
  });

  final String? oauthCode;
  final String? accessToken;
  final String? codeVerifier;

  @override
  List<Object?> get props => [
        oauthCode,
        accessToken,
        codeVerifier,
      ];
}

final class AuthFeedbackCleared extends AuthEvent {
  const AuthFeedbackCleared();
}
