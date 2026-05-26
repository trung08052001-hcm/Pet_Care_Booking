import 'package:app/core/usecase/usecase.dart';
import 'package:app/core/common/typedefs.dart';
import 'package:app/features/authentication/domain/entities/auth_session.dart';
import 'package:app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignInParams extends Equatable {
  const SignInParams({
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

class SignInUseCase implements UseCase<AuthSession, SignInParams> {
  const SignInUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<AuthSession> call(SignInParams params) {
    return _repository.signIn(
      identifier: params.identifier,
      password: params.password,
    );
  }
}
