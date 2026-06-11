import 'package:app/features/profile/data/datasources/profile_edit_remote_data_source.dart';
import 'package:app/features/profile/domain/entities/profile_edit_user.dart';

class UpdateProfileEditUseCase {
  const UpdateProfileEditUseCase(this._dataSource);

  final ProfileEditRemoteDataSource _dataSource;

  Future<ProfileEditUser> updateAvatar(String? avatarDataUrl) {
    return _dataSource.updateProfile(avatarDataUrl: avatarDataUrl);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _dataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}
