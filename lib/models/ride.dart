class Ride {
  final String rideId;
  final String userId;
  final String bikeId;
  final String startStationId;
  final String? endStationId; // null = ride still in progress
  final DateTime startTime;
  final DateTime? endTime; // null = ride still in progress

  static const int freeSeconds = 3; // 3 seconds free for demo

  const Ride({
    required this.rideId,
    required this.userId,
    required this.bikeId,
    required this.startStationId,
    this.endStationId,
    required this.startTime,
    this.endTime,
  });

  // Derived — duration in seconds
  int get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime).inSeconds;
  }

  bool isOvertime() => duration > freeSeconds;

  // Derived — computed, never stored
  double get cost => calculateCost();

  double calculateCost() {
    const double overtimeRatePerSecond = 0.05;

    if (!isOvertime()) return 0;

    final overtimeSeconds = duration - freeSeconds;
    return overtimeSeconds * overtimeRatePerSecond;
  }

  bool get isInProgress => endTime == null;

  Ride copyWith({
    String? rideId,
    String? userId,
    String? bikeId,
    String? startStationId,
    String? endStationId,
    DateTime? startTime,
    DateTime? endTime,
  }) {
    return Ride(
      rideId: rideId ?? this.rideId,
      userId: userId ?? this.userId,
      bikeId: bikeId ?? this.bikeId,
      startStationId: startStationId ?? this.startStationId,
      endStationId: endStationId ?? this.endStationId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
