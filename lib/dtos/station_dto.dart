import 'package:latlong2/latlong.dart';
import 'package:velo_toulose/models/slot.dart';
import 'package:velo_toulose/models/station.dart';

class StationDto {
  static const String nameKey = 'name';
  static const String locationKey = 'location';
  static const String capacityKey = 'capacity';

  static Station fromJson(
    String id,
    Map<String, dynamic> json,
    List<Slot> slots,
  ) {
    assert(json[nameKey] is String);
    assert(json[capacityKey] is int);
    assert(json[locationKey] is Map);

    final locationData = Map<String, dynamic>.from(json[locationKey] as Map);

    return Station(
      stationId: id,
      name: json[nameKey] as String,
      location: LatLng(
        (locationData['lat'] as num).toDouble(),
        (locationData['lng'] as num).toDouble(),
      ),
      capacity: json[capacityKey] as int,
      slots: slots,
    );
  }

  static Map<String, dynamic> toJson(Station station) {
    return {
      nameKey: station.name,
      locationKey: {
        'lat': station.location.latitude,
        'lng': station.location.longitude,
      },
      capacityKey: station.capacity,
    };
  }
}
