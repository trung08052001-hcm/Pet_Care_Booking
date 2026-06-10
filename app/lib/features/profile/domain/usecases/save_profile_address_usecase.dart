import 'package:app/core/common/typedefs.dart';
import 'package:app/features/profile/domain/entities/user_address.dart';
import 'package:app/features/profile/domain/repositories/profile_address_repository.dart';
import 'package:equatable/equatable.dart';

class SaveProfileAddressUseCase {
  const SaveProfileAddressUseCase(this._repository);

  final ProfileAddressRepository _repository;

  ResultFuture<UserAddress> call(SaveProfileAddressParams params) {
    return _repository.saveAddress(
      UserAddress(
        detail: params.detail,
        label: params.label,
        latitude: params.latitude,
        longitude: params.longitude,
      ),
    );
  }
}

class SaveProfileAddressParams extends Equatable {
  const SaveProfileAddressParams({
    required this.detail,
    this.label = '',
    this.latitude,
    this.longitude,
  });

  final String detail;
  final String label;
  final double? latitude;
  final double? longitude;

  @override
  List<Object?> get props => [
        detail,
        label,
        latitude,
        longitude,
      ];
}
