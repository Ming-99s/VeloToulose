import 'dart:async';
import 'package:flutter/material.dart';
import 'package:velo_toulose/models/ride.dart';
import 'package:velo_toulose/repositories/abstract/ride_repository.dart';

class RideViewModel extends ChangeNotifier {
  final RideRepository _repository;

  RideViewModel(this._repository);

  Ride? activeRide;
  bool isLoading = false;
  String? error;
  Timer? _timer;

  bool get hasActiveRide => activeRide != null;

  // called when user confirms booking
  Future<void> startRide({
    required String userId,
    required String bikeId,
    required String startStationId,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      activeRide = await _repository.startRide(
        userId: userId,
        bikeId: bikeId,
        startStationId: startStationId,
      );
      _startTimer();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Ends the current ride and returns the completed Ride with cost info.
  /// Returns null if there was no active ride or an error occurred.
  Future<Ride?> endRide(String endStationId) async {
    if (activeRide == null) return null;

    isLoading = true;
    notifyListeners();

    try {
      final endedRide = await _repository.endRide(
        activeRide!.rideId,
        endStationId,
      );
      activeRide = null;
      _stopTimer();
      notifyListeners();
      return endedRide; // caller can use this to create a receipt
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // check if user already has an active ride on app start
  Future<void> checkActiveRide(String userId) async {
    activeRide = await _repository.getActiveRide(userId);
    if (activeRide != null) _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    // update every second for demo
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners(); // triggers timerLabel to recompute
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
