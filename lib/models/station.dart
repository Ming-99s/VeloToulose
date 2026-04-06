import 'slot.dart';

class Station {
  final String stationId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int capacity;
  final List<Slot> slots;

  const Station({
    required this.stationId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.capacity,
    required this.slots,
  });

  // Derived attribute — computed from slots, never stored
  int get availableBikes => slots.where((slot) => slot.bikeId != null).length;

  List<Slot> getAvailableBikes() =>
      slots.where((slot) => slot.bikeId != null).toList();

  List<Slot> getFreeSlots() => slots.where((slot) => slot.isEmpty()).toList();

  Station copyWith({
    String? stationId,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    int? capacity,
    List<Slot>? slots,
  }) {
    return Station(
      stationId: stationId ?? this.stationId,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      capacity: capacity ?? this.capacity,
      slots: slots ?? this.slots,
    );
  }
}
