
import 'package:velo_toulose/models/bike.dart';

class BikeDto {
  static const String typeKey = 'type';
  static const String batteryLevelKey = 'batteryLevel';
  static const String slotIdKey = 'slotId';
  // status is NOT stored — derived from slotId

  static Bike fromJson(String id, Map<String, dynamic> json) {
    assert(json[typeKey] is String);
    assert(json[batteryLevelKey] is int);

    return Bike(
      bikeId: id,
      type: json[typeKey],
      batteryLevel: json[batteryLevelKey],
      slotId: json[slotIdKey], // nullable — null means bike is on a ride
    );
  }

  Map<String, dynamic> toJson(Bike bike) {
    return {
      typeKey: bike.type,
      batteryLevelKey: bike.batteryLevel,
      slotIdKey: bike.slotId,
      // status NOT stored — it is derived from slotId
    };
  }
}
