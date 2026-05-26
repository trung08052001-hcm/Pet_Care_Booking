import 'package:app/core/common/typedefs.dart';
import 'package:app/features/authentication/domain/entities/auth_session.dart';
import 'package:app/features/authentication/domain/repositories/auth_repository.dart';

class RestoreSessionUseCase {
  const RestoreSessionUseCase(this._repository);

  final AuthRepository _repository;

  ResultFuture<AuthSession?> call() {
    return _repository.restoreSession();
  }
}
