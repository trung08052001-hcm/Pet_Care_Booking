import 'package:app/core/usecase/usecase.dart';
import 'package:app/core/common/typedefs.dart';
import 'package:app/features/authentication/domain/entities/auth_session.dart';
import 'package:app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:equatable/equatable.dart';

class SignUpParams extends Equatable {
  const SignUpParams({
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

class SignUpUseCase implements UseCase<AuthSession, SignUpParams> {
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  @override
  ResultFuture<AuthSession> call(SignUpParams params) {
    return _repository.signUp(
      fullName: params.fullName,
      email: params.email,
      phone: params.phone,
      password: params.password,
      confirmPassword: params.confirmPassword,
      acceptTerms: params.acceptTerms,
    );
  }
}
