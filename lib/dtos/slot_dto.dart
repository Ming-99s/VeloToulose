

import 'package:velo_toulose/core/enum/slot_status.dart';
import 'package:velo_toulose/models/slot.dart';

class SlotDto {
  static const String slotNumberKey = 'slotNumber';
  static const String statusKey = 'status';
  static const String stationIdKey = 'stationId';
  static const String bikeIdKey = 'bikeId';

  static Slot fromJson(String id, Map<String, dynamic> json) {
    assert(json[slotNumberKey] is int);
    assert(json[statusKey] is String);
    assert(json[stationIdKey] is String);

    return Slot(
      slotId: id,
      slotNumber: json[slotNumberKey],
      status: SlotStatus.fromString(json[statusKey]),
      stationId: json[stationIdKey],
      bikeId: json[bikeIdKey], // nullable — null means slot is empty
    );
  }

  Map<String, dynamic> toJson(Slot slot) {
    return {
      slotNumberKey: slot.slotNumber,
      statusKey: slot.status.toJson(),
      stationIdKey: slot.stationId,
      bikeIdKey: slot.bikeId,
    };
  }
}
