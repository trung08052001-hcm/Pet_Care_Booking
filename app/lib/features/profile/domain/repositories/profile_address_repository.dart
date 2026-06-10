import 'package:app/core/common/typedefs.dart';
import 'package:app/features/profile/domain/entities/user_address.dart';

abstract interface class ProfileAddressRepository {
  ResultFuture<UserAddress?> getAddress();

  ResultFuture<UserAddress> saveAddress(UserAddress address);
}
