
import 'package:velo_toulose/core/enum/slot_status.dart';

class Slot {
  final String slotId;
  final String stationId;
  final String? bikeId; // null = slot is empty (bike is on a ride)

  const Slot({
    required this.slotId,
    required this.stationId,
    this.bikeId,
  });

  bool get isEmpty => bikeId == null;
  bool get isOccupied => bikeId != null;

  Slot copyWith({
    String? slotId,
    String? stationId,
    String? bikeId,
    bool clearBike = false,
  }) {
    return Slot(
      slotId: slotId ?? this.slotId,
      stationId: stationId ?? this.stationId,
      bikeId: clearBike ? null : (bikeId ?? this.bikeId)
    );
  }
}
