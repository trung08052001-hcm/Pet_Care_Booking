import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:zalo_flutter/zalo_flutter.dart';

/// Uses `zalo_flutter` to get Zalo `oauthCode`,
/// then sends it to your backend `POST /api/v1/auth/zalo/login`.
class ZaloAuthService {
  const ZaloAuthService();

  /// Call once on app startup.
  /// Your backend accepts `oauthCode` and optional `codeVerifier`.
  static Future<void> init({required String appId}) async {
    // `zalo_flutter` does not expose an init call; keep this for API stability.
    if (kDebugMode && Platform.isAndroid) {
      final hashKey = await ZaloFlutter.getHashKeyAndroid();
      debugPrint(
        '[Zalo] Android HashKey (paste to Zalo Dashboard > Login > Android): $hashKey',
      );
      debugPrint(
        '[Zalo] Package name must be: com.example.app',
      );
    }
  }

  Future<ZaloOAuthData> login() async {
    try {
      final res = await ZaloFlutter.login();
      if (res == null) {
        throw const ZaloAuthException(
          'Zalo SDK did not return data. Please check app ID / hash key / package name in Zalo developer dashboard.',
        );
      }

      final isSuccess = res?['isSuccess'] == true;
      if (!isSuccess) {
        final error = res?['error'] as Map<dynamic, dynamic>?;
        final errorCode = error?['errorCode']?.toString();
        final errorMessage = error?['errorMessage']?.toString();
        final code = errorCode ?? 'unknown';
        final hint = code == '5008' || code == '-5008'
            ? ' Hash Key Android chưa khớp — xem log [Zalo] HashKey khi chạy app.'
            : '';
        throw ZaloAuthException(
          (errorMessage != null && errorMessage.isNotEmpty)
              ? 'Zalo login failed ($code): $errorMessage.$hint'
              : 'Zalo login failed ($code).$hint',
        );
      }

      final data = res['data'] as Map<dynamic, dynamic>?;
      if (kDebugMode) {
        debugPrint('[Zalo] login success data keys: ${data?.keys.toList()}');
      }

      // `zalo_flutter` exchanges oauthCode on native side and returns tokens.
      // Zalo API uses snake_case keys: access_token, refresh_token, oauth_code.
      final oauthCode = _readString(data, 'oauthCode', 'oauth_code');
      final accessToken = _readString(data, 'accessToken', 'access_token');
      final codeVerifier = _readString(data, 'codeVerifier', 'code_verifier');

      if (oauthCode.isEmpty && accessToken.isEmpty) {
        throw const ZaloAuthException(
          'Zalo did not return oauthCode or accessToken.',
        );
      }

      return ZaloOAuthData(
        oauthCode: oauthCode.isNotEmpty ? oauthCode : null,
        accessToken: accessToken.isNotEmpty ? accessToken : null,
        codeVerifier: codeVerifier.isNotEmpty ? codeVerifier : null,
      );
    } catch (e) {
      if (e is ZaloAuthException) rethrow;
      throw ZaloAuthException('Zalo SDK error: $e');
    }
  }

  static String _readString(
    Map<dynamic, dynamic>? data,
    String camelKey,
    String snakeKey,
  ) {
    if (data == null) return '';
    final value = data[camelKey] ?? data[snakeKey];
    return value?.toString().trim() ?? '';
  }
}

class ZaloOAuthData {
  const ZaloOAuthData({
    this.oauthCode,
    this.accessToken,
    this.codeVerifier,
  });

  final String? oauthCode;
  final String? accessToken;
  final String? codeVerifier;
}

class ZaloAuthException implements Exception {
  const ZaloAuthException(this.message);
  final String message;

  @override
  String toString() => 'ZaloAuthException: $message';
}
