import 'package:app/core/network/api_config.dart';
import 'package:app/features/profile/domain/entities/profile_edit_user.dart';
import 'package:dio/dio.dart';

class ProfileEditRemoteDataSource {
  const ProfileEditRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ProfileEditUser> getMe() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.authMe);
    final data = _asMap(response.data?['data']);
    final user = _asMap(data?['user']);
    if (user == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid profile response from server.',
      );
    }
    return _parseUser(user);
  }

  Future<ProfileEditUser> updateProfile({String? avatarDataUrl}) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.authMeProfile,
      data: {'avatarDataUrl': avatarDataUrl},
    );
    final data = _asMap(response.data?['data']);
    final user = _asMap(data?['user']);
    if (user == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid profile response from server.',
      );
    }
    return _parseUser(user);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.authMePassword,
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
  }

  Map<String, dynamic>? _asMap(Object? value) {
    if (value is! Map) {
      return null;
    }
    return Map<String, dynamic>.from(value);
  }

  ProfileEditUser _parseUser(Map<String, dynamic> json) {
    return ProfileEditUser(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
    );
  }
}
