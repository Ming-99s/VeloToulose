import 'package:velo_toulose/core/enum/bike_status.dart';


class Bike {
  final String bikeId;
  final String? slotId; 

  const Bike({
    required this.bikeId,
    this.slotId,
  });

  // Derived attribute — computed from slotId, never stored
  BikeStatus get status {
    return slotId == null ? BikeStatus.inUse : BikeStatus.available;
  }

  void lock() {
    // lock logic handled via repository
  }

  void unlock() {
    // unlock logic handled via repository
  }

  Bike copyWith({
    String? bikeId,
    String? type,
    int? batteryLevel,
    String? slotId,
    bool clearSlotId = false,
  }) {
    return Bike(
      bikeId: bikeId ?? this.bikeId,
      slotId: clearSlotId ? null : slotId ?? this.slotId,
    );
  }
}
