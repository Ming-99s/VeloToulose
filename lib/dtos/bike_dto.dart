import 'package:velo_toulose/models/bike.dart';

class BikeDto {
  static const String slotIdKey = 'slotId';
  static const String stationIdKey = 'stationId';
  // status is NOT stored — derived from slotId

  static Bike fromJson(String id, Map<String, dynamic> json) {
    return Bike(
      bikeId: id,
      slotId: json[slotIdKey] as String?, // null = bike is on a ride
    );
  }

  static Map<String, dynamic> toJson(Bike bike) {
    return {
      slotIdKey: bike.slotId,
      stationIdKey: null, // set explicitly when placing bike
      // status NOT stored — derived from slotId
    };
  }
}
