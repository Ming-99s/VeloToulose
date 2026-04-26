import 'package:hive_flutter/hive_flutter.dart';
import 'package:velo_toulose/core/utils/id_generator.dart';
import 'package:velo_toulose/dtos/ride_dto.dart';
import 'package:velo_toulose/models/ride.dart';
import 'package:velo_toulose/repositories/abstract/ride_repository.dart';
import 'package:velo_toulose/repositories/abstract/station_repostiory.dart';

class RideRepositoryMock implements RideRepository {
  Box get _box => Hive.box('rides_box');

  final StationRepostiory _stationRepo;
  RideRepositoryMock(this._stationRepo);

  @override
  Future<Ride> startRide({
    required String userId,
    required String bikeId,
    required String startStationId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _stationRepo.removeBikeFromStation(startStationId, bikeId);
    final ride = Ride(
      rideId: IdGenerator.ride(),
      userId: userId,
      bikeId: bikeId,
      startStationId: startStationId,
      startTime: DateTime.now(),
    );
    await _box.put(ride.rideId, RideDto().toJson(ride));
    return ride;
  }

  @override
  Future<Ride> endRide(String rideId, String endStationId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final raw = _box.get(rideId);
    if (raw == null) throw Exception('No active ride found');
    final map = Map<String, dynamic>.from(raw as Map);
    final ride = RideDto.fromJson(map[RideDto.rideId], map);
    await _stationRepo.addBikeToStation(endStationId, ride.bikeId);
    final ended = ride.copyWith(
      endStationId: endStationId,
      endTime: DateTime.now(),
    );
    await _box.put(rideId, RideDto().toJson(ended));
    return ended;
  }

  @override
  Future<Ride?> getActiveRide(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (final e in _box.values) {
      final map = Map<String, dynamic>.from(e as Map);
      if (map[RideDto.userIdKey] == userId && map[RideDto.endTimeKey] == null) {
        return RideDto.fromJson(map[RideDto.rideId], map);
      }
    }
    return null;
  }
}
