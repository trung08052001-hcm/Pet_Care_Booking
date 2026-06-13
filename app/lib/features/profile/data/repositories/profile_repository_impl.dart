import 'package:app/core/common/typedefs.dart';
import 'package:app/core/error/app_error.dart';
import 'package:app/core/local/hive_box_names.dart';
import 'package:app/core/local/hive_local_store.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/features/profile/data/datasources/profile_edit_remote_data_source.dart';
import 'package:app/features/profile/data/datasources/profile_mock_data_source.dart';
import 'package:app/features/profile/domain/entities/profile_page_content.dart';
import 'package:app/features/profile/domain/entities/profile_user.dart';
import 'package:app/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(
    this._mockDataSource, [
    this._remoteDataSource,
    this._store,
    this._networkInfo,
  ]);

  final ProfileMockDataSource _mockDataSource;
  final ProfileEditRemoteDataSource? _remoteDataSource;
  final HiveLocalStore? _store;
  final NetworkInfo? _networkInfo;

  static const _cacheKey = 'profile_user';

  @override
  ResultFuture<ProfilePageContent> getProfilePageContent() async {
    try {
      final baseContent = _mockDataSource.getPageContent();
      final cachedUser = _cachedUser(baseContent.user);

      if (_remoteDataSource != null &&
          _networkInfo != null &&
          await _networkInfo.isConnected) {
        try {
          final remoteUser = await _remoteDataSource.getMe();
          final user = _mergeUser(
            baseContent.user,
            fullName: remoteUser.fullName,
            avatarUrl: remoteUser.avatar,
          );
          await _cacheUser(user);
          return Right(_withUser(baseContent, user));
        } on Exception {
          if (cachedUser != null) {
            return Right(_withUser(baseContent, cachedUser));
          }
        }
      }

      if (cachedUser != null) {
        return Right(_withUser(baseContent, cachedUser));
      }

      return Right(baseContent);
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(
          exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  ProfilePageContent _withUser(ProfilePageContent content, ProfileUser user) {
    return ProfilePageContent(
      user: user,
      mainMenuItems: content.mainMenuItems,
      supportSectionTitle: content.supportSectionTitle,
      supportMenuItems: content.supportMenuItems,
      logoutLabel: content.logoutLabel,
      appVersionLabel: content.appVersionLabel,
    );
  }

  ProfileUser _mergeUser(
    ProfileUser baseUser, {
    required String fullName,
    required String? avatarUrl,
  }) {
    final name = fullName.trim();
    return ProfileUser(
      fullName: name.isEmpty ? baseUser.fullName : name,
      memberSinceLabel: '',
      editProfileLabel: baseUser.editProfileLabel,
      avatarInitials: _initials(name.isEmpty ? baseUser.fullName : name),
      avatarUrl: avatarUrl,
    );
  }

  ProfileUser? _cachedUser(ProfileUser baseUser) {
    final data = _store?.getMap(boxName: HiveBoxNames.appCache, key: _cacheKey);
    if (data == null) {
      return null;
    }

    return _mergeUser(
      baseUser,
      fullName: data['fullName'] as String? ?? '',
      avatarUrl: data['avatarUrl'] as String?,
    );
  }

  Future<void> _cacheUser(ProfileUser user) async {
    await _store?.putMap(
      boxName: HiveBoxNames.appCache,
      key: _cacheKey,
      value: {
        'fullName': user.fullName,
        'avatarUrl': user.avatarUrl,
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
  }

  String _initials(String value) {
    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return '?';
    }
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'
        .toUpperCase();
  }
}
