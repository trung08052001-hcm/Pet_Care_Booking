import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/features/profile/data/datasources/profile_address_remote_data_source.dart';
import 'package:app/features/profile/data/models/user_address_model.dart';
import 'package:app/features/profile/domain/entities/user_address.dart';
import 'package:app/features/profile/domain/repositories/profile_address_repository.dart';
import 'package:dartz/dartz.dart';

class ProfileAddressRepositoryImpl implements ProfileAddressRepository {
  const ProfileAddressRepositoryImpl(this._remoteDataSource);

  final ProfileAddressRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<UserAddress?> getAddress() async {
    try {
      final address = await _remoteDataSource.getAddress();
      return Right(address?.toEntity());
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(exception, stackTrace: stackTrace),
      );
    }
  }

  @override
  ResultFuture<UserAddress> saveAddress(UserAddress address) async {
    try {
      final savedAddress = await _remoteDataSource.saveAddress(
        UserAddressModel(
          detail: address.detail,
          label: address.label,
          latitude: address.latitude,
          longitude: address.longitude,
        ),
      );
      return Right(savedAddress.toEntity());
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(exception, stackTrace: stackTrace),
      );
    }
  }
}
