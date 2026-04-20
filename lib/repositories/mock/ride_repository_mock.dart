import 'package:velo_toulose/models/ride.dart';
import 'package:velo_toulose/repositories/abstract/ride_repository.dart';
import 'package:velo_toulose/repositories/abstract/station_repostiory.dart';
import 'package:velo_toulose/repositories/mock/station_repository_mock.dart';

class RideRepositoryMock implements RideRepository {
  Ride? _activeRide;
  final StationRepostiory _stationRepo; 

  RideRepositoryMock(this._stationRepo); // ← inject

  @override
  Future<Ride> startRide({
    required String userId,
    required String bikeId,
    required String startStationId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _stationRepo.removeBikeFromStation(startStationId, bikeId); 
    _activeRide = Ride(
      rideId: 'ride_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      bikeId: bikeId,
      startStationId: startStationId,
      startTime: DateTime.now(),
    );
    return _activeRide!;
  }

  @override
  Future<Ride> endRide(String rideId, String endStationId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_activeRide == null) throw Exception('No active ride found');
    _stationRepo.addBikeToStation(
      endStationId,
      _activeRide!.bikeId,
    ); // ← mutate
    _activeRide = _activeRide!.copyWith(
      endStationId: endStationId,
      endTime: DateTime.now(),
    );
    final ended = _activeRide!;
    _activeRide = null;
    return ended;
  }

  @override
  Future<Ride?> getActiveRide(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _activeRide;
  }
}
