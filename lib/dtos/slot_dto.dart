import 'package:velo_toulose/models/slot.dart';

class SlotDto {
  static const String slotNumberKey = 'slotNumber';
  static const String statusKey = 'status';
  static const String stationIdKey = 'stationId';
  static const String bikeIdKey = 'bikeId';

  static Slot fromJson(String id, Map<String, dynamic> json) {
    assert(json[stationIdKey] is String);

    return Slot(
      slotId: id,
      stationId: json[stationIdKey],
      bikeId: json[bikeIdKey] as String?, // null = slot is empty
    );
  }

  static Map<String, dynamic> toJson(Slot slot) {
    return {
      stationIdKey: slot.stationId,
      bikeIdKey: slot.bikeId,
      statusKey: slot.isEmpty ? 'free' : 'occupied',
    };
  }
}
