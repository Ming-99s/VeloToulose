
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

  bool isEmpty() => bikeId == null || status == SlotStatus.free;

  Slot copyWith({
    String? slotId,
    int? slotNumber,
    SlotStatus? status,
    String? stationId,
    String? bikeId,
  }) {
    return Slot(
      slotId: slotId ?? this.slotId,
      slotNumber: slotNumber ?? this.slotNumber,
      status: status ?? this.status,
      stationId: stationId ?? this.stationId,
      bikeId: bikeId ?? this.bikeId,
    );
  }
}
