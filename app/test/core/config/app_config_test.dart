import 'package:app/core/config/app_config.dart';
import 'package:app/core/config/app_flavor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConfig', () {
    test('creates dev config with network logs enabled', () {
      final config = AppConfig.fromFlavor(AppFlavor.dev);

      expect(config.appName, 'Product Base Dev');
      expect(config.baseUrl, 'https://jsonplaceholder.typicode.com');
      expect(config.enableNetworkLogs, isTrue);
    });

    test('creates prod config with network logs disabled', () {
      final config = AppConfig.fromFlavor(AppFlavor.prod);

      expect(config.appName, 'Product Base');
      expect(config.enableNetworkLogs, isFalse);
    });
  });
}
