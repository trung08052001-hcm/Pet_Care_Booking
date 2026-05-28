import 'dart:convert';

import 'package:app/core/error/app_error.dart';
import 'package:app/core/storage/storage_service.dart';
import 'package:app/features/authentication/data/models/auth_models.dart';
import 'package:app/features/authentication/data/services/auth_api_service.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthSessionModel> signIn(SignInRequestModel request);

  Future<AuthSessionModel> signUp(SignUpRequestModel request);

  Future<AuthSessionModel> signInWithGoogle(GoogleLoginRequestModel request);

  Future<AuthSessionModel> signInWithZalo(ZaloLoginRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._apiService);

  final AuthApiService _apiService;

  @override
  Future<AuthSessionModel> signIn(SignInRequestModel request) async {
    final response = await _apiService.signIn(request.toJson());
    return response.data;
  }

  @override
  Future<AuthSessionModel> signUp(SignUpRequestModel request) async {
    final response = await _apiService.signUp(request.toJson());
    return response.data;
  }

  @override
  Future<AuthSessionModel> signInWithGoogle(
    GoogleLoginRequestModel request,
  ) async {
    final response = await _apiService.signInWithGoogle(request.toJson());
    return response.data;
  }

  @override
  Future<AuthSessionModel> signInWithZalo(ZaloLoginRequestModel request) async {
    final response = await _apiService.signInWithZalo(request.toJson());
    return response.data;
  }
}

abstract interface class AuthLocalDataSource {
  Future<void> saveSession(AuthSessionModel session);

  Future<AuthSessionModel?> getCachedSession();

  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl(
    this._secureStorage,
    this._preferences,
  );

  final SecureStorageService _secureStorage;
  final AppPreferences _preferences;

  @override
  Future<void> saveSession(AuthSessionModel session) async {
    await _secureStorage.write(
      key: StorageKeys.authToken,
      value: session.tokens.accessToken,
    );
    await _secureStorage.write(
      key: StorageKeys.authRefreshToken,
      value: session.tokens.refreshToken,
    );
    await _preferences.writeString(
      key: StorageKeys.authTokenType,
      value: session.tokens.tokenType,
    );
    await _preferences.writeString(
      key: StorageKeys.cachedAuthUser,
      value: jsonEncode(session.user.toJson()),
    );
    await _preferences.writeBool(
      key: StorageKeys.isAuthenticated,
      value: true,
    );
  }

  @override
  Future<AuthSessionModel?> getCachedSession() async {
    final accessToken = await _secureStorage.read(StorageKeys.authToken);
    final refreshToken = await _secureStorage.read(StorageKeys.authRefreshToken);
    final tokenType = _preferences.readString(StorageKeys.authTokenType);
    final userJson = _preferences.readString(StorageKeys.cachedAuthUser);
    final isAuthenticated =
        _preferences.readBool(StorageKeys.isAuthenticated) ?? false;

    if (!isAuthenticated) {
      return null;
    }

    if (accessToken == null ||
        refreshToken == null ||
        tokenType == null ||
        userJson == null) {
      await clearSession();
      return null;
    }

    final decodedUser = jsonDecode(userJson);
    if (decodedUser is! Map<String, dynamic>) {
      throw const CacheException(message: 'Cached auth user is corrupted.');
    }

    return AuthSessionModel(
      user: AuthUserModel.fromJson(decodedUser),
      tokens: AuthTokensModel(
        tokenType: tokenType,
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
    );
  }

  @override
  Future<void> clearSession() async {
    await _secureStorage.delete(StorageKeys.authToken);
    await _secureStorage.delete(StorageKeys.authRefreshToken);
    await _preferences.remove(StorageKeys.authTokenType);
    await _preferences.remove(StorageKeys.cachedAuthUser);
    await _preferences.writeBool(
      key: StorageKeys.isAuthenticated,
      value: false,
    );
  }
}
