import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class CurrentLocationAddressResult {
  const CurrentLocationAddressResult({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  final String address;
  final double latitude;
  final double longitude;
}

class CurrentLocationAddressService {
  const CurrentLocationAddressService(this._dio);

  final Dio _dio;

  Future<CurrentLocationAddressResult> resolveCurrentAddress() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Vui lòng bật định vị trên thiết bị.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception('Bạn cần cấp quyền vị trí để lấy địa chỉ hiện tại.');
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
    final address = await _reverseGeocode(position);

    return CurrentLocationAddressResult(
      address: address,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<String> _reverseGeocode(Position position) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'jsonv2',
          'lat': position.latitude,
          'lon': position.longitude,
          'accept-language': 'vi',
        },
        options: Options(
          headers: {
            'User-Agent': 'PawSitiveCareApp/1.0',
          },
        ),
      );
      final displayName = response.data?['display_name'] as String?;
      if (displayName != null && displayName.trim().isNotEmpty) {
        return displayName.trim();
      }
    } on Exception {
      // Fall back to coordinates when reverse geocoding is unavailable.
    }

    return 'Vị trí hiện tại (${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)})';
  }
}
