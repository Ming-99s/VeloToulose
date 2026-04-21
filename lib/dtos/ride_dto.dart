import 'package:velo_toulose/models/ride.dart';

class RideDto {
  static const String userIdKey = 'userId';
  static const String bikeIdKey = 'bikeId';
  static const String startStationIdKey = 'startStationId';
  static const String endStationIdKey = 'endStationId';
  static const String startTimeKey = 'startTime';
  static const String endTimeKey = 'endTime';
  // FIX #4: stored status enables O(1) active-ride lookup via activeRides node
  static const String statusKey = 'status';
  static const String statusActive = 'active';
  static const String statusEnded = 'ended';

  // cost and duration NOT stored — derived from startTime/endTime

  static Ride fromJson(String id, Map<String, dynamic> json) {
    return Ride(
      rideId: id,
      userId: json[userIdKey] as String,
      bikeId: json[bikeIdKey] as String,
      startStationId: json[startStationIdKey] as String,
      endStationId: json[endStationIdKey] as String?,
      startTime: DateTime.parse(json[startTimeKey] as String),
      endTime: json[endTimeKey] != null
          ? DateTime.parse(json[endTimeKey] as String)
          : null,
    );
  }

  static Map<String, dynamic> toJson(Ride ride) {
    return {
      userIdKey: ride.userId,
      bikeIdKey: ride.bikeId,
      startStationIdKey: ride.startStationId,
      endStationIdKey: ride.endStationId,
      startTimeKey: ride.startTime.toIso8601String(),
      endTimeKey: ride.endTime?.toIso8601String(),
      statusKey: ride.isInProgress ? statusActive : statusEnded,
    };
  }
}
