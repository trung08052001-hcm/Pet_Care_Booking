import 'package:app/core/config/app_config.dart';
import 'package:app/core/storage/storage_service.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._secureStorageService);

  final SecureStorageService _secureStorageService;

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
