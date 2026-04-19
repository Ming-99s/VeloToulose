import 'package:latlong2/latlong.dart';

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
  int get availableBikes => slots.where((slot) => slot.bikeId != null).length;
  int get emptyDock => slots.where((s) => s.isEmpty()).length;

  List<Slot> getAvailableBikes() =>
      slots.where((slot) => slot.bikeId != null).toList();

  List<Slot> getFreeSlots() => slots.where((slot) => slot.isEmpty()).toList();

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
