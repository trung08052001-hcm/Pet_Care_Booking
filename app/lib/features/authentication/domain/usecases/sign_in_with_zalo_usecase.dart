import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/authentication/domain/entities/auth_session.dart';
import 'package:app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignInWithZaloParams extends Equatable {
  const SignInWithZaloParams({
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

class SignInWithZaloUseCase
    implements UseCase<AuthSession, SignInWithZaloParams> {
  const SignInWithZaloUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<AuthSession> call(SignInWithZaloParams params) {
    return _repository.signInWithZalo(
      oauthCode: params.oauthCode,
      accessToken: params.accessToken,
      codeVerifier: params.codeVerifier,
    );
  }
}
