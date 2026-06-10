import 'package:app/core/common/typedefs.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/profile/domain/entities/user_address.dart';
import 'package:app/features/profile/domain/repositories/profile_address_repository.dart';

class GetProfileAddressUseCase
    implements UseCase<UserAddress?, NoParams> {
  const GetProfileAddressUseCase(this._repository);

  final ProfileAddressRepository _repository;

  @override
  ResultFuture<UserAddress?> call(NoParams params) {
    return _repository.getAddress();
  }
}
