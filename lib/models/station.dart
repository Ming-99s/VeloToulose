import 'package:latlong2/latlong.dart';
import 'package:velo_toulose/core/enum/slot_status.dart';

import 'slot.dart';

class Station {
  final String stationId;
  final String name;
  final LatLng location;
  final int capacity;
  final List<Slot> slots;

  const Station({
    required this.stationId,
    required this.name,
    required this.location,
    required this.capacity,
    required this.slots,
  });

  // Derived attribute — computed from slots, never stored

  List<Slot> getAvailableBikes() => slots.where((s) => s.isOccupied).toList();
  List<Slot> getFreeSlots() => slots.where((s) => s.isEmpty).toList();

  Station copyWith({
    String? stationId,
    String? name,
    LatLng? location,
    int? capacity,
    List<Slot>? slots,
  }) {
    return Station(
      stationId: stationId ?? this.stationId,
      name: name ?? this.name,
      location: location ?? this.location,
      capacity: capacity ?? this.capacity,
      slots: slots ?? this.slots,
    );
  }
}
