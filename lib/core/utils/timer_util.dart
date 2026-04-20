import 'package:velo_toulose/models/ride.dart';

class TimeUtils {
  final Ride? activeRide;
  TimeUtils({required this.activeRide});

  Duration get elapsed {
    if (activeRide == null) return Duration.zero;
    return DateTime.now().difference(activeRide!.startTime);
  }

  bool get isOvertime => elapsed.inMinutes >= 30;

  String get timerLabel {
    if (activeRide == null) return '00:00';
    final minutes = elapsed.inMinutes;
    final seconds = elapsed.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get statusLabel {
    if (isOvertime) {
      final overtime = elapsed.inMinutes - 30;
      return 'Overtime: ${overtime}min — €${(overtime * 0.05).toStringAsFixed(2)} extra';
    }
    final remaining = 30 - elapsed.inMinutes;
    return '$remaining min free time remaining';
  }
}
