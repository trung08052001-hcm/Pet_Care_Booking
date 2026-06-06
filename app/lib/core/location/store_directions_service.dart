import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

abstract final class StoreDirectionsService {
  static const String storeAddress =
      '154 Trần Thị Trọng, phường Tân Sơn, TPHCM';

  static Future<bool> openGoogleMapsDirections() async {
    await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    final destination = Uri.encodeComponent(storeAddress);
    final appUri = Uri.parse('google.navigation:q=$destination&mode=d');
    final webUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$destination&travelmode=driving',
    );

    if (await canLaunchUrl(appUri)) {
      return launchUrl(appUri, mode: LaunchMode.externalApplication);
    }
    return launchUrl(webUri, mode: LaunchMode.externalApplication);
  }
}
