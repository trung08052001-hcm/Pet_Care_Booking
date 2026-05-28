import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/authentication/domain/entities/auth_session.dart';
import 'package:app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignInWithGoogleParams extends Equatable {
  const SignInWithGoogleParams({required this.idToken});

  final String idToken;

  @override
  List<Object?> get props => [idToken];
}

class SignInWithGoogleUseCase
    implements UseCase<AuthSession, SignInWithGoogleParams> {
  const SignInWithGoogleUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<AuthSession> call(SignInWithGoogleParams params) {
    return _repository.signInWithGoogle(idToken: params.idToken);
  }
}
