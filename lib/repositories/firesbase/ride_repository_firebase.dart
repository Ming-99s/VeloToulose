import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:velo_toulose/dtos/ride_dto.dart';
import 'package:velo_toulose/models/ride.dart';
import 'package:velo_toulose/repositories/abstract/ride_repository.dart';

class RideRepositoryFirebase implements RideRepository {
  final FirebaseDatabase _db;

  RideRepositoryFirebase({FirebaseDatabase? db})
    : _db = db ?? FirebaseDatabase.instance;

  DatabaseReference get _rides => _db.ref('rides');
  DatabaseReference get _bikes => _db.ref('bikes');
  DatabaseReference get _stations => _db.ref('stations');
  DatabaseReference get _activeRides => _db.ref('activeRides');

  // ─── startRide ────────────────────────────────────────────────────────────

  @override
  Future<Ride> startRide({
    required String userId,
    required String bikeId,
    required String startStationId,
  }) async {
    debugPrint(
      '[RideRepo] startRide → userId=$userId bikeId=$bikeId station=$startStationId',
    );

    final slotsSnap = await _stations.child('$startStationId/slots').get();
    String? slotId;
    if (slotsSnap.exists) {
      final slotsMap = Map<String, dynamic>.from(slotsSnap.value as Map);
      for (final entry in slotsMap.entries) {
        final data = Map<String, dynamic>.from(entry.value as Map);
        if (data['bikeId'] == bikeId) {
          slotId = entry.key;
          break;
        }
      }
    }
    debugPrint('[RideRepo] startRide → found slotId=$slotId');

    final newRef = _rides.push();
    final rideKey = newRef.key!;
    final now = DateTime.now();

    final updates = <String, dynamic>{
      'rides/$rideKey/${RideDto.userIdKey}': userId,
      'rides/$rideKey/${RideDto.bikeIdKey}': bikeId,
      'rides/$rideKey/${RideDto.startStationIdKey}': startStationId,
      'rides/$rideKey/${RideDto.startTimeKey}': now.toIso8601String(),
      'rides/$rideKey/${RideDto.statusKey}': RideDto.statusActive,
      'bikes/$bikeId/slotId': null,
      'bikes/$bikeId/stationId': null,
      'activeRides/$userId': rideKey,
    };

    if (slotId != null) {
      updates['stations/$startStationId/slots/$slotId/bikeId'] = null;
      updates['stations/$startStationId/slots/$slotId/status'] = 'free';
    }

    await _db.ref().update(updates);
    debugPrint('[RideRepo] startRide → rideKey=$rideKey written OK');

    return Ride(
      rideId: rideKey,
      userId: userId,
      bikeId: bikeId,
      startStationId: startStationId,
      startTime: now,
    );
  }


  @override
  Future<Ride> endRide(String rideId, String endStationId) async {
    debugPrint('[RideRepo] endRide → rideId=$rideId endStation=$endStationId');

    // 1. Fetch the ride record
    final snapshot = await _rides.child(rideId).get();
    if (!snapshot.exists) {
      debugPrint('[RideRepo] endRide → ERROR: ride $rideId not found in DB');
      throw Exception('Ride not found: $rideId');
    }
    debugPrint('[RideRepo] endRide → ride found OK');

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    final ride = RideDto.fromJson(rideId, data);
    debugPrint(
      '[RideRepo] endRide → bikeId=${ride.bikeId} userId=${ride.userId}',
    );

    final stationSnap = await _stations.child('$endStationId/slots').get();
    if (!stationSnap.exists) {
      debugPrint(
        '[RideRepo] endRide → ERROR: station $endStationId has no slots node',
      );
      throw Exception('Station $endStationId not found or has no slots');
    }

    final rawSlots = Map<String, dynamic>.from(stationSnap.value as Map);
    final freeCount = rawSlots.values
        .map((v) => Map<String, dynamic>.from(v as Map))
        .where((s) => !s.containsKey('bikeId') || s['bikeId'] == null)
        .length;
    debugPrint(
      '[RideRepo] endRide → station $endStationId has $freeCount free slots out of ${rawSlots.length}',
    );

    if (freeCount == 0) {
      throw Exception('No free slots at station $endStationId');
    }

    // 3. Claim a free slot atomically
    final slotId = await _claimFreeSlot(endStationId, ride.bikeId);
    debugPrint('[RideRepo] endRide → claimed slotId=$slotId');

    final endTime = DateTime.now();

await _db.ref().update({
      'rides/$rideId/${RideDto.endStationIdKey}': endStationId,
      'rides/$rideId/${RideDto.endTimeKey}': endTime.toIso8601String(),
      'rides/$rideId/${RideDto.statusKey}': RideDto.statusEnded,
      'rides/$rideId/${RideDto.userIdKey}': ride.userId, 
      'activeRides/${ride.userId}': null,
      'bikes/${ride.bikeId}/slotId': slotId,
      'bikes/${ride.bikeId}/stationId': endStationId,
    });

    debugPrint('[RideRepo] endRide → ride ended OK');
    return ride.copyWith(endStationId: endStationId, endTime: endTime);
  }


  @override
  Future<Ride?> getActiveRide(String userId) async {
    debugPrint('[RideRepo] getActiveRide → userId=$userId');

    final snap = await _activeRides.child(userId).get();
    if (!snap.exists) {
      debugPrint('[RideRepo] getActiveRide → no active ride found');
      return null;
    }

    final rideId = snap.value as String;
    debugPrint('[RideRepo] getActiveRide → found rideId=$rideId');

    final rideSnap = await _rides.child(rideId).get();
    if (!rideSnap.exists) {
      debugPrint('[RideRepo] getActiveRide → stale pointer, cleaning up');
      await _activeRides.child(userId).remove();
      return null;
    }

    final rideData = Map<String, dynamic>.from(rideSnap.value as Map);
    return RideDto.fromJson(rideId, rideData);
  }


  Future<String> _claimFreeSlot(String stationId, String bikeId) async {
    String? claimedSlotId;

    final result = await _stations.child('$stationId/slots').runTransaction((
      currentData,
    ) {
      if (currentData == null) {
        debugPrint(
          '[RideRepo] _claimFreeSlot → transaction currentData is null',
        );
        return Transaction.abort();
      }

      final slotsMap = Map<String, dynamic>.from(currentData as Map);
      debugPrint(
        '[RideRepo] _claimFreeSlot → scanning ${slotsMap.length} slots',
      );

      for (final entry in slotsMap.entries) {
        final slotData = Map<String, dynamic>.from(entry.value as Map);
        // Firebase DELETES keys set to null — free slot has absent OR null bikeId
        final isFree =
            !slotData.containsKey('bikeId') || slotData['bikeId'] == null;
        debugPrint(
          '[RideRepo] _claimFreeSlot → slot ${entry.key} isFree=$isFree bikeId=${slotData['bikeId']}',
        );
        if (isFree) {
          claimedSlotId = entry.key;
          slotsMap[entry.key] = {'bikeId': bikeId, 'status': 'occupied'};
          return Transaction.success(slotsMap);
        }
      }

      debugPrint('[RideRepo] _claimFreeSlot → no free slot found, aborting');
      return Transaction.abort();
    });

    if (!result.committed || claimedSlotId == null) {
      debugPrint(
        '[RideRepo] _claimFreeSlot → transaction not committed: ${result.committed}',
      );
      throw Exception('No free slots available at station $stationId');
    }

    return claimedSlotId!;
  }
}
