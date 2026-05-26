import 'package:app/core/config/app_config.dart';
import 'package:app/core/di/injection.dart';
import 'package:app/core/network/dio_factory.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @singleton
  AppConfig get appConfig => currentAppConfig;

  @lazySingleton
  Logger logger(AppConfig appConfig) {
    return Logger(
      printer: PrettyPrinter(
        methodCount: appConfig.enableNetworkLogs ? 1 : 0,
        errorMethodCount: appConfig.enableNetworkLogs ? 8 : 2,
      ),
    );
  }

  @preResolve
  Future<SharedPreferences> sharedPreferences() {
    return SharedPreferences.getInstance();
  }

  @lazySingleton
  FlutterSecureStorage secureStorage() => const FlutterSecureStorage();

  @lazySingleton
  Connectivity connectivity() => Connectivity();

  @lazySingleton
  Dio dio(DioFactory dioFactory) => dioFactory.create();
}
