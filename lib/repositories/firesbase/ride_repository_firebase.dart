import 'package:firebase_database/firebase_database.dart';
import 'package:velo_toulose/dtos/ride_dto.dart';
import 'package:velo_toulose/models/ride.dart';
import 'package:velo_toulose/repositories/abstract/ride_repository.dart';
import 'package:velo_toulose/repositories/abstract/station_repostiory.dart';

class RideRepositoryFirebase implements RideRepository {
  final FirebaseDatabase _db;
  final StationRepostiory _stationRepo;

  RideRepositoryFirebase(this._stationRepo, {FirebaseDatabase? db})
    : _db = db ?? FirebaseDatabase.instance;

  DatabaseReference get _rides => _db.ref('rides');

  @override
  Future<Ride> startRide({
    required String userId,
    required String bikeId,
    required String startStationId,
  }) async {
    _stationRepo.removeBikeFromStation(startStationId, bikeId);

    final now = DateTime.now();

    final rideData = {
      RideDto.userIdKey: userId,
      RideDto.bikeIdKey: bikeId,
      RideDto.startStationIdKey: startStationId,
      RideDto.endStationIdKey: null,
      RideDto.startTimeKey: now.toIso8601String(),
      RideDto.endTimeKey: null,
    };

    // push() generates a unique key (like Firestore's auto-id)
    final newRef = _rides.push();
    await newRef.set(rideData);

    return Ride(
      rideId: newRef.key!,
      userId: userId,
      bikeId: bikeId,
      startStationId: startStationId,
      startTime: now,
    );
  }

  @override
  Future<Ride> endRide(String rideId, String endStationId) async {
    final snapshot = await _rides.child(rideId).get();
    if (!snapshot.exists) throw Exception('Ride not found');

    final endTime = DateTime.now();
    await _rides.child(rideId).update({
      RideDto.endStationIdKey: endStationId,
      RideDto.endTimeKey: endTime.toIso8601String(),
    });

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    final ride = RideDto.fromJson(rideId, data);
    final endedRide = ride.copyWith(
      endStationId: endStationId,
      endTime: endTime,
    );

    _stationRepo.addBikeToStation(endStationId, ride.bikeId);

    return endedRide;
  }

  @override
  Future<Ride?> getActiveRide(String userId) async {
    // Query rides where userId matches and endTime is null
    final snapshot = await _rides.orderByChild('userId').equalTo(userId).get();

    if (!snapshot.exists) return null;

    final ridesMap = Map<String, dynamic>.from(snapshot.value as Map);

    for (final entry in ridesMap.entries) {
      final data = Map<String, dynamic>.from(entry.value as Map);
      // Active ride = no endTime
      if (data[RideDto.endTimeKey] == null) {
        return RideDto.fromJson(entry.key, data);
      }
    }

    return null;
  }
}
