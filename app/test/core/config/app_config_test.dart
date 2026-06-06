import 'package:app/core/config/app_config.dart';
import 'package:app/core/config/app_flavor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConfig', () {
    test('creates dev config with network logs enabled', () {
      final config = AppConfig.fromFlavor(AppFlavor.dev);

      expect(config.appName, 'PawSitive Care Dev');
      expect(config.baseUrl, 'http://192.168.1.29:5000/api/v1');
      expect(config.enableNetworkLogs, isTrue);
    });

    test('creates prod config with network logs disabled', () {
      final config = AppConfig.fromFlavor(AppFlavor.prod);

      expect(config.appName, 'PawSitive Care');
      expect(config.baseUrl, 'https://api.pawsitive-care.com/api/v1');
      expect(config.enableNetworkLogs, isFalse);
    });
  });
}
