import 'package:velo_toulose/models/ride.dart';

abstract class RideRepository {
  Future<Ride> startRide({
    required String userId,
    required String bikeId,
    required String startStationId,
  });
  Future<Ride> endRide(String rideId, String endStationId);
  Future<Ride?> getActiveRide(String userId);
}
