
import 'package:velo_toulose/core/enum/slot_status.dart';

class Slot {
  final String slotId;
  final int slotNumber;
  final SlotStatus status;
  final String stationId;
  final String? bikeId; // null = slot is empty (bike is on a ride)

  const Slot({
    required this.slotId,
    required this.slotNumber,
    required this.status,
    required this.stationId,
    this.bikeId,
  });

  bool isEmpty() => bikeId == null;

  Slot copyWith({
    String? slotId,
    int? slotNumber,
    SlotStatus? status,
    String? stationId,
    String? bikeId,
    bool clearBikeId = false,
  }) {
    return Slot(
      slotId: slotId ?? this.slotId,
      slotNumber: slotNumber ?? this.slotNumber,
      status: status ?? this.status,
      stationId: stationId ?? this.stationId,
      bikeId: clearBikeId ? null : bikeId ?? this.bikeId,
    );
  }
}
