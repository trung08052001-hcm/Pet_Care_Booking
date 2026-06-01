import 'package:app/core/common/typedefs.dart';
import 'package:app/features/authentication/domain/entities/auth_session.dart';

abstract interface class AuthRepository {
  ResultFuture<AuthSession> signIn({
    required String identifier,
    required String password,
  });

  ResultFuture<AuthSession> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
  });

  ResultFuture<AuthSession> signInWithGoogle({required String idToken});

  ResultFuture<AuthSession> signInWithZalo({
    String? oauthCode,
    String? accessToken,
    String? codeVerifier,
  });

  ResultFuture<AuthSession?> restoreSession();

  ResultFuture<void> requestPasswordResetOtp({required String email});

  ResultFuture<void> verifyPasswordResetOtp({
    required String email,
    required String otp,
  });

  ResultFuture<void> logout();
}
