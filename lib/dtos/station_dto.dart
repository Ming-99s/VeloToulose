

import 'package:velo_toulose/models/slot.dart';
import 'package:velo_toulose/models/station.dart';

class StationDto {
  static const String nameKey = 'name';
  static const String addressKey = 'address';
  static const String latitudeKey = 'latitude';
  static const String longitudeKey = 'longitude';
  static const String capacityKey = 'capacity';
  // availableBikes NOT stored — derived from slots

  static Station fromJson(
    String id,
    Map<String, dynamic> json,
    List<Slot> slots,
  ) {
    assert(json[nameKey] is String);
    assert(json[addressKey] is Map<String, dynamic>);
    assert(json[latitudeKey] is num);
    assert(json[longitudeKey] is num);
    assert(json[capacityKey] is int);

    return Station(
      stationId: id,
      name: json[nameKey],
      address: json[addressKey],
      latitude: (json[latitudeKey] as num).toDouble(),
      longitude: (json[longitudeKey] as num).toDouble(),
      capacity: json[capacityKey],
      slots: slots, // loaded separately from subcollection
    );
  }

  Map<String, dynamic> toJson(Station station) {
    return {
      nameKey: station.name,
      addressKey: station.address,
      latitudeKey: station.latitude,
      longitudeKey: station.longitude,
      capacityKey: station.capacity,
      // slots stored in subcollection — not here
      // availableBikes is derived — not stored
    };
  }
}
