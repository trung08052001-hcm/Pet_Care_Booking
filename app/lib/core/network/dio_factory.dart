import 'package:app/core/config/app_config.dart';
import 'package:app/core/storage/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._secureStorageService);

  final SecureStorageService _secureStorageService;
  Future<String?>? _refreshTokenFuture;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorageService.read(StorageKeys.authToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final shouldRefresh =
        err.response?.statusCode == 401 &&
        request.path != '/auth/refresh-token' &&
        request.extra['tokenRefreshAttempted'] != true;

    if (!shouldRefresh) {
      handler.next(err);
      return;
    }

    final refreshedAccessToken = await _refreshAccessToken(request.baseUrl);
    if (refreshedAccessToken == null || refreshedAccessToken.isEmpty) {
      handler.next(err);
      return;
    }

    try {
      final retryResponse = await _retryRequest(request, refreshedAccessToken);
      handler.resolve(retryResponse);
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<String?> _refreshAccessToken(String baseUrl) {
    final runningRefresh = _refreshTokenFuture;
    if (runningRefresh != null) {
      return runningRefresh;
    }

    final refreshFuture = _performTokenRefresh(baseUrl);
    _refreshTokenFuture = refreshFuture;
    return refreshFuture.whenComplete(() {
      _refreshTokenFuture = null;
    });
  }

  Future<String?> _performTokenRefresh(String baseUrl) async {
    final refreshToken = await _secureStorageService.read(
      StorageKeys.authRefreshToken,
    );

    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }

    try {
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          contentType: Headers.jsonContentType,
          responseType: ResponseType.json,
        ),
      );
      final response = await refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh-token',
        data: {'refreshToken': refreshToken},
      );
      final data = response.data?['data'];
      if (data is! Map<String, dynamic>) {
        return null;
      }

      final tokens = data['tokens'];
      if (tokens is! Map<String, dynamic>) {
        return null;
      }

      final accessToken = tokens['accessToken'] as String?;
      final newRefreshToken = tokens['refreshToken'] as String?;
      if (accessToken == null || accessToken.isEmpty) {
        return null;
      }

      await _secureStorageService.write(
        key: StorageKeys.authToken,
        value: accessToken,
      );

      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await _secureStorageService.write(
          key: StorageKeys.authRefreshToken,
          value: newRefreshToken,
        );
      }

      return accessToken;
    } on DioException {
      return null;
    }
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions request,
    String accessToken,
  ) {
    final retryDio = Dio(
      BaseOptions(
        baseUrl: request.baseUrl,
        connectTimeout: request.connectTimeout,
        receiveTimeout: request.receiveTimeout,
        sendTimeout: request.sendTimeout,
        contentType: request.contentType,
        responseType: request.responseType,
      ),
    );
    final headers = Map<String, dynamic>.from(request.headers)
      ..['Authorization'] = 'Bearer $accessToken';
    final extra = Map<String, dynamic>.from(request.extra)
      ..['tokenRefreshAttempted'] = true;

    return retryDio.fetch<dynamic>(
      request.copyWith(
        headers: headers,
        extra: extra,
      ),
    );
  }
}

@lazySingleton
class NetworkLoggerInterceptor extends Interceptor {
  NetworkLoggerInterceptor(
    this._appConfig,
    this._logger,
  );

  final AppConfig _appConfig;
  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_appConfig.enableNetworkLogs) {
      _logger.i(
        '[${options.method}] ${options.baseUrl}${options.path}',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (_appConfig.enableNetworkLogs) {
      _logger.d(
        '[${response.requestOptions.method}] '
        '${response.requestOptions.baseUrl}${response.requestOptions.path} '
        '=> ${response.statusCode}',
      );
    }
    handler.next(response);
  }
}

@lazySingleton
class ErrorLoggerInterceptor extends Interceptor {
  ErrorLoggerInterceptor(this._logger);

  final Logger _logger;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.w(
      '[${err.requestOptions.method}] '
      '${err.requestOptions.baseUrl}${err.requestOptions.path} '
      '=> ${err.response?.statusCode ?? 'unknown'}',
      error: err,
      stackTrace: err.stackTrace,
    );
    handler.next(err);
  }
}

@lazySingleton
class DioFactory {
  DioFactory(
    this._appConfig,
    this._authInterceptor,
    this._networkLoggerInterceptor,
    this._errorLoggerInterceptor,
  );

  final AppConfig _appConfig;
  final AuthInterceptor _authInterceptor;
  final NetworkLoggerInterceptor _networkLoggerInterceptor;
  final ErrorLoggerInterceptor _errorLoggerInterceptor;

  Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: _appConfig.baseUrl,
        connectTimeout: _appConfig.connectTimeout,
        receiveTimeout: _appConfig.receiveTimeout,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.addAll([
      _authInterceptor,
      _networkLoggerInterceptor,
      _errorLoggerInterceptor,
    ]);

    return dio;
  }
}
