import 'package:app/features/profile/data/datasources/profile_edit_remote_data_source.dart';
import 'package:app/features/profile/domain/entities/profile_edit_user.dart';

class GetProfileEditUserUseCase {
  const GetProfileEditUserUseCase(this._dataSource);

  final ProfileEditRemoteDataSource _dataSource;

  Future<ProfileEditUser> call() {
    return _dataSource.getMe();
  }
}
