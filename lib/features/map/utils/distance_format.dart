import 'package:latlong2/latlong.dart';

class DistanceUtils {
  static double metersTo(LatLng from, LatLng to) {
    const distance = Distance();
    return distance.as(LengthUnit.Meter, from, to);
  }

  static String formatted(LatLng from, LatLng to) {
    final meters = metersTo(from, to);
    if (meters >= 1000) {
      return '${(meters / 1000).toStringAsFixed(1)} km';
    }
    return '${meters.toStringAsFixed(0)} m';
  }
}
