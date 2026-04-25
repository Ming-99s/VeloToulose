import 'package:velo_toulose/models/ride.dart';

class RideDto {
  static const String rideId = 'rideId';
  static const String userIdKey = 'userId';
  static const String bikeIdKey = 'bikeId';
  static const String startStationIdKey = 'startStationId';
  static const String endStationIdKey = 'endStationId';
  static const String startTimeKey = 'startTime';
  static const String endTimeKey = 'endTime';

  static Ride fromJson(String id, Map<String, dynamic> json) {
    assert(json[userIdKey] is String);
    assert(json[rideId] is String);
    assert(json[bikeIdKey] is String);
    assert(json[startStationIdKey] is String);
    assert(json[startTimeKey] is String);

    return Ride(
      rideId: id,
      userId: json[userIdKey],
      bikeId: json[bikeIdKey],
      startStationId: json[startStationIdKey],
      endStationId: json[endStationIdKey], // nullable — ride in progress
      startTime: DateTime.parse(json[startTimeKey]),
      endTime: json[endTimeKey] != null
          ? DateTime.parse(json[endTimeKey])
          : null, // nullable — ride in progress
    );
  }

  Map<String, dynamic> toJson(Ride ride) {
    return {
      rideId : ride.rideId,
      userIdKey: ride.userId,
      bikeIdKey: ride.bikeId,
      startStationIdKey: ride.startStationId,
      endStationIdKey: ride.endStationId,
      startTimeKey: ride.startTime.toIso8601String(),
      endTimeKey: ride.endTime?.toIso8601String(),
    };
  }
}
