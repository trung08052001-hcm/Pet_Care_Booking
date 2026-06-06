import 'dart:async';

import 'package:geolocator/geolocator.dart';

class LocationRequirementService {
  StreamSubscription<Position>? _positionSubscription;

  Future<bool> ensureLocationReady() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    }

    if (permission == LocationPermission.denied) {
      return false;
    }

    _startLocationIndicator();
    return true;
  }

  void _startLocationIndicator() {
    _positionSubscription ??= Geolocator.getPositionStream(
      locationSettings: AndroidSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50,
        foregroundNotificationConfig: const ForegroundNotificationConfig(
          notificationTitle: 'Pet Care Booking đang lấy vị trí',
          notificationText: 'App đang lấy vị trí để hỗ trợ chỉ đường.',
          enableWakeLock: false,
          setOngoing: true,
        ),
      ),
    ).listen((_) {});
  }

  Future<void> stop() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
  }
}
