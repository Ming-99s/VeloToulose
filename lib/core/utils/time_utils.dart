import 'package:velo_toulose/models/ride.dart';

class TimeUtils {
  final Ride? activeRide;

  TimeUtils({required this.activeRide});

  String get timerLabel {
    final now = DateTime.now();
    final diff = now.difference(activeRide!.startTime);

    final minutes = diff.inMinutes;
    final seconds = diff.inSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')} mn';
  }
}
