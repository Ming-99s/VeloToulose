class Ride {
  final String rideId;
  final String userId;
  final String bikeId;
  final String startStationId;
  final String? endStationId; // null = ride still in progress
  final DateTime startTime;
  final DateTime? endTime; // null = ride still in progress
  final double distance;

  static const int freeMinutes = 30;

  const Ride({
    required this.rideId,
    required this.userId,
    required this.bikeId,
    required this.startStationId,
    this.endStationId,
    required this.startTime,
    this.endTime,
    this.distance = 0,
  });

  // Derived — computed from start/end time
  int get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime).inMinutes;
  }

  bool isOvertime() => duration > freeMinutes;

  // Derived — computed, never stored
  double get cost => calculateCost();

  double calculateCost() {
    const double unlockFee = 1.20;
    const double overtimeRatePerMinute = 0.10;

    if (!isOvertime()) return unlockFee;

    final overtimeMinutes = duration - freeMinutes;
    return unlockFee + (overtimeMinutes * overtimeRatePerMinute);
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
    double? distance,
  }) {
    return Ride(
      rideId: rideId ?? this.rideId,
      userId: userId ?? this.userId,
      bikeId: bikeId ?? this.bikeId,
      startStationId: startStationId ?? this.startStationId,
      endStationId: endStationId ?? this.endStationId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      distance: distance ?? this.distance,
    );
  }
}
