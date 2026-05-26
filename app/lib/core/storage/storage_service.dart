import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class StorageKeys {
  const StorageKeys._();

  static const authToken = 'auth_token';
  static const authRefreshToken = 'auth_refresh_token';
  static const authTokenType = 'auth_token_type';
  static const cachedAuthUser = 'cached_auth_user';
  static const isAuthenticated = 'is_authenticated';
  static const cachedSamplePosts = 'cached_sample_posts';
  static const hasCompletedOnboarding = 'has_completed_onboarding';
}

abstract interface class SecureStorageService {
  Future<void> write({
    required String key,
    required String value,
  });

  Future<String?> read(String key);

  Future<void> delete(String key);
}

@LazySingleton(as: SecureStorageService)
class SecureStorageServiceImpl implements SecureStorageService {
  SecureStorageServiceImpl(this._storage);

  final FlutterSecureStorage _storage;

  @override
  Future<void> write({
    required String key,
    required String value,
  }) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<String?> read(String key) {
    return _storage.read(key: key);
  }

  @override
  Future<void> delete(String key) {
    return _storage.delete(key: key);
  }
}

@lazySingleton
class AppPreferences {
  AppPreferences(this._preferences);

  final SharedPreferences _preferences;

  Future<bool> writeString({
    required String key,
    required String value,
  }) {
    return _preferences.setString(key, value);
  }

  Future<bool> writeBool({
    required String key,
    required bool value,
  }) {
    return _preferences.setBool(key, value);
  }

  String? readString(String key) {
    return _preferences.getString(key);
  }

  bool? readBool(String key) {
    return _preferences.getBool(key);
  }

  Future<bool> remove(String key) {
    return _preferences.remove(key);
  }
}
