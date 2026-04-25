import 'package:latlong2/latlong.dart';
import 'package:velo_toulose/models/bike.dart';
import 'package:velo_toulose/models/station.dart';
import 'package:velo_toulose/models/slot.dart';
import 'package:velo_toulose/repositories/abstract/station_repostiory.dart';

class StationRepositoryMock implements StationRepostiory {
  late final List<Station> _stations;
  final List<Bike> _allBikes = []; // ← global bike registry

  StationRepositoryMock() {
    _stations = [
      Station(
        stationId: '1',
        name: 'Central Station',
        location: const LatLng(11.492046, 104.943556),
        slots: _buildSlots(stationId: '1', total: 10, occupied: 5),
      ),
      Station(
        stationId: '2',
        name: 'River Park',
        location: const LatLng(11.5530, 104.9250),
        slots: _buildSlots(stationId: '2', total: 8, occupied: 2),
      ),
      Station(
        stationId: '3',
        name: 'Night Market',
        location: const LatLng(11.5580, 104.9350),
        slots: _buildSlots(stationId: '3', total: 6, occupied: 0),
      ),
    ];

    // build _allBikes from all occupied slots across all stations
    for (final station in _stations) {
      for (final slot in station.slots) {
        if (slot.bikeId != null) {
          _allBikes.add(Bike(bikeId: slot.bikeId!, slotId: slot.slotId));
        }
      }
    }
  }

  List<Slot> _buildSlots({
    required String stationId,
    required int total,
    required int occupied,
  }) {
    return List.generate(total, (i) {
      final hasBike = i < occupied;
      final slotNumber = i + 1;
      return Slot(
        slotId: '${stationId}_slot_$slotNumber',
        stationId: stationId,
        bikeId: hasBike ? 'bike_${stationId}_$slotNumber' : null,
      );
    });
  }

  Station _getStation(String stationId) =>
      _stations.firstWhere((s) => s.stationId == stationId);

  @override
  Future<void> removeBikeFromStation(String stationId, String bikeId) async {
    final station = _getStation(stationId);
    final idx = _stations.indexOf(station);

    // update slot — free it
    final updatedSlots = station.slots.map((slot) {
      if (slot.bikeId == bikeId) {
        return slot.copyWith(clearBike: true);
      }
      return slot;
    }).toList();

    _stations[idx] = station.copyWith(slots: updatedSlots);

    // remove bike from global registry
    _allBikes.removeWhere((b) => b.bikeId == bikeId);
  }

  @override
  Future<void> addBikeToStation(String stationId, String bikeId) async {
    final station = _getStation(stationId);
    final idx = _stations.indexOf(station);
    bool placed = false;
    String? placedSlotId;

    // occupy first free slot
    final updatedSlots = station.slots.map((slot) {
      if (!placed && slot.isEmpty) {
        placed = true;
        placedSlotId = slot.slotId;
        return slot.copyWith(bikeId: bikeId);
      }
      return slot;
    }).toList();

    _stations[idx] = station.copyWith(slots: updatedSlots);

    // add bike to global registry linked to its new slot
    if (placedSlotId != null) {
      _allBikes.add(Bike(bikeId: bikeId, slotId: placedSlotId!));
    }
  }

  @override
  Future<List<Slot>> loadSlotsByStation(String stationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _getStation(stationId).slots;
  }

  @override
  Future<List<Bike>> loadBikesByStation(String stationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // return only bikes whose slotId belongs to this station
    final stationSlotIds = _getStation(
      stationId,
    ).slots.map((s) => s.slotId).toSet();
    return _allBikes.where((b) => stationSlotIds.contains(b.slotId)).toList();
  }

  @override
  Future<List<Station>> loadStations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _stations;
  }
}
