import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/material.dart';
import 'package:velo_toulose/core/enum/payment_type.dart';
import 'package:velo_toulose/core/utils/id_generator.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/models/pass.dart';
import 'package:velo_toulose/models/payment.dart';
import 'package:velo_toulose/models/ride.dart';
import 'package:velo_toulose/repositories/abstract/payment_repository.dart';
import 'package:velo_toulose/repositories/abstract/ride_repository.dart';

class RideViewModel extends ChangeNotifier {
  final RideRepository _repository;
  final MapViewModel _mapViewModel;
  final PaymentRepository _paymentRepository;

  RideViewModel(this._repository, this._mapViewModel, this._paymentRepository);

  Ride? activeRide;
  bool isLoading = false;
  String? error;
  Timer? _timer;

  bool get hasActiveRide => activeRide != null;

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
      await _mapViewModel.loadStations(); //refresh after booking
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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
      await _mapViewModel.loadStations(); //refresh after return
      notifyListeners();
      return endedRide;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> checkActiveRide(String userId) async {
    activeRide = await _repository.getActiveRide(userId);
    if (activeRide != null) _startTimer();
    notifyListeners();
  }

  // Starts the ride and records the unlock fee payment — no logic in the view
  Future<void> confirmBooking({
    required String userId,
    required String bikeId,
    required String startStationId,
    required Pass? usedPass,
  }) async {
    final fbUser = fb_auth.FirebaseAuth.instance.currentUser;
    if (fbUser == null) return;
    await fbUser.getIdToken();

    await startRide(
      userId: userId,
      bikeId: bikeId,
      startStationId: startStationId,
    );

    if (usedPass == null) {
      await _paymentRepository.savePayment(
        Payment(
          paymentId: IdGenerator.payment(),
          userId: userId,
          type: PaymentType.unlockFee,
          amount: 2.50,
          createdAt: DateTime.now(),
          rideId: activeRide?.rideId,
        ),
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
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
