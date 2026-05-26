import 'package:app/core/config/app_flavor.dart';
import 'package:equatable/equatable.dart';

class AppConfig extends Equatable {
  const AppConfig({
    required this.flavor,
    required this.appName,
    required this.baseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
    required this.enableNetworkLogs,
  });

  factory AppConfig.fromFlavor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.dev:
        return const AppConfig(
          flavor: AppFlavor.dev,
          appName: 'PawSitive Care Dev',
          baseUrl: String.fromEnvironment(
            'DEV_BASE_URL',
            defaultValue: 'http://192.168.1.29:5000/api/v1',
            // defaultValue: 'http://10.0.2.2:5000/api/v1',
          ),
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
          enableNetworkLogs: true,
        );
      case AppFlavor.stg:
        return const AppConfig(
          flavor: AppFlavor.stg,
          appName: 'PawSitive Care Stg',
          baseUrl: String.fromEnvironment(
            'STG_BASE_URL',
            defaultValue: 'https://stg-api.pawsitive-care.com/api/v1',
          ),
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
          enableNetworkLogs: true,
        );
      case AppFlavor.prod:
        return const AppConfig(
          flavor: AppFlavor.prod,
          appName: 'PawSitive Care',
          baseUrl: String.fromEnvironment(
            'PROD_BASE_URL',
            defaultValue: 'https://api.pawsitive-care.com/api/v1',
          ),
          connectTimeout: Duration(seconds: 30),
          receiveTimeout: Duration(seconds: 30),
          enableNetworkLogs: false,
        );
    }
  }

  final AppFlavor flavor;
  final String appName;
  final String baseUrl;
  final Duration connectTimeout;
  final Duration receiveTimeout;
  final bool enableNetworkLogs;

  @override
  List<Object> get props => [
        flavor,
        appName,
        baseUrl,
        connectTimeout,
        receiveTimeout,
        enableNetworkLogs,
      ];
}
