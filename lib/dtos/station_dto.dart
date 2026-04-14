

import 'package:latlong2/latlong.dart';
import 'package:velo_toulose/models/slot.dart';
import 'package:velo_toulose/models/station.dart';

class StationDto {
  static const String nameKey = 'name';
  static const String location = 'location';
  static const String capacityKey = 'capacity';
  // availableBikes NOT stored — derived from slots

  static Station fromJson(
    String id,
    Map<String, dynamic> json,
    List<Slot> slots,
  ) {
    assert(json[nameKey] is String);
    assert(json[capacityKey] is int);
    assert(json[location] is LatLng);


    return Station(
      stationId: id,
      name: json[nameKey],
      location: json[location],
      capacity: json[capacityKey],
      slots: slots, // loaded separately from subcollection
    );
  }

  Map<String, dynamic> toJson(Station station) {
    return {
      nameKey: station.name,
      capacityKey: station.capacity,
      // slots stored in subcollection — not here
      // availableBikes is derived — not stored
    };
  }
}
