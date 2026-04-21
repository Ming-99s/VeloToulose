class Ride {
  final String rideId;
  final String userId;
  final String bikeId;
  final String startStationId;
  final String? endStationId; // null = ride still in progress
  final DateTime startTime;
  final DateTime? endTime; // null = ride still in progress

  static const int freeMinutes = 30; // 3 seconds free for demo

  const Ride({
    required this.rideId,
    required this.userId,
    required this.bikeId,
    required this.startStationId,
    this.endStationId,
    required this.startTime,
    this.endTime,
  });

  // Derived — duration in minute
  int get duration {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime).inMinutes;
  }

  bool isOvertime() => duration > freeMinutes;

  // Derived — computed, never stored
  double get cost => calculateCost();

double calculateCost({bool hasPass = false}) {
    const double unlockFee = 2.50;
    const double overtimeRatePerMinute = 0.05;
    const int freeMinutes = 30;

    double total = hasPass ? 0.0 : unlockFee;

    if (duration > freeMinutes) {
      final overtimeMinutes = duration - freeMinutes;
      total += overtimeMinutes * overtimeRatePerMinute;
    }

    return total;
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
