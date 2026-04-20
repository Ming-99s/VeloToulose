import 'package:latlong2/latlong.dart';
import 'package:velo_toulose/core/enum/slot_status.dart';
import 'package:velo_toulose/models/bike.dart';
import 'package:velo_toulose/models/station.dart';
import 'package:velo_toulose/models/slot.dart';
import 'package:velo_toulose/repositories/abstract/station_repostiory.dart';

class StationRepositoryMock implements StationRepostiory{
  // Helper to build slots — bikeId present = bike is docked
  List<Slot> _buildSlots({
    required String stationId,
    required int total,
    required int occupied,
  }) {
    return List.generate(total, (i) {
      final slotNumber = i + 1;
      final hasBike = i < occupied; 
      return Slot(
        slotId: '${stationId}_slot_$slotNumber',
        slotNumber: slotNumber,
        status: hasBike ? SlotStatus.occupied : SlotStatus.free,
        stationId: stationId,
        bikeId: hasBike ? 'bike_${stationId}_$slotNumber' : null,
      );
    });
  }
  List<Bike> _buildBikes({required String stationId, required int count}) {
    return List.generate(count, (i) {
      final slotNumber = i + 1;
      return Bike(
        bikeId: 'bike_${stationId}_$slotNumber',
        slotId: '${stationId}_slot_$slotNumber',
      );
    });
  }
    @override
  Future<List<Slot>> loadSlotsByStation(String stationId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // mock bikes — in real app this comes from API
  final allSlots = {
      '1': _buildSlots(stationId: '1', total: 10, occupied: 10),
      '2': _buildSlots(stationId: '2', total: 8, occupied: 2),
      '3': _buildSlots(stationId: '3', total: 6, occupied: 0),
    };

    return allSlots[stationId] ?? [];
  }
  @override
  Future<List<Bike>> loadBikesByStation(String stationId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // mock bikes — in real app this comes from API
    final allBikes = {
      '1': _buildBikes(stationId: '1', count: 5),
      '2': _buildBikes(stationId: '2', count: 2),
      '3': _buildBikes(stationId: '3', count: 0),
    };

    return allBikes[stationId] ?? [];
  }


  @override
  Future<List<Station>> loadStations() async {
    // simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      Station(
        stationId: '1',
        name: 'Central Station',
        location: const LatLng(11.492046, 104.943556),
        capacity: 10,
        slots: _buildSlots(stationId: '1', total: 10, occupied: 5),
      ),
      Station(
        stationId: '2',
        name: 'River Park',
        location: const LatLng(11.5530, 104.9250),
        capacity: 8,
        slots: _buildSlots(stationId: '2', total: 8, occupied: 2),
      ),
      Station(
        stationId: '3',
        name: 'Night Market',
        location: const LatLng(11.5580, 104.9350),
        capacity: 6,
        slots: _buildSlots(stationId: '3', total: 6, occupied: 0),
      ),
    ];
  }
}
