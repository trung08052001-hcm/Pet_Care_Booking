import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class LogoutUseCase implements UseCase<void, NoParams> {
  LogoutUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  ResultFuture<void> call(NoParams params) {
    return _authRepository.logout();
  }
}
