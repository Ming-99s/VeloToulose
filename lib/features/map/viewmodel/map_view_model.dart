import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:velo_toulose/models/bike.dart';
import 'package:velo_toulose/models/slot.dart';
import 'package:velo_toulose/models/station.dart';
import 'package:velo_toulose/repositories/abstract/station_repostiory.dart';

class MapViewModel extends ChangeNotifier {
  MapViewModel(this.stationRepostiory);

  final StationRepostiory stationRepostiory;
  LatLng? userLocation;
  bool isLoading = false;
  Station? selectedStation;

  List<Station> stations = [];
  List<Bike> bikes = [];
  List<Slot> slots = [];

  void selectStation(Station station) {
    selectedStation = station;
    notifyListeners();
    loadBikesByStation(station.stationId);
    loadDockByStation(station.stationId);
  }

  void clearSelectedStation() {
    selectedStation = null;
    notifyListeners();
  }

  // Phnom Penh as fallback if location fails
  static const LatLng fallback = LatLng(11.5564, 104.9282);

  Future<void> loadStations() async {
    stations = await stationRepostiory.loadStations();

    if (selectedStation != null) {
      selectedStation = stations.firstWhere(
        (s) => s.stationId == selectedStation!.stationId,
        orElse: () => selectedStation!,
      );

      await loadBikesByStation(selectedStation!.stationId);
      await loadDockByStation(selectedStation!.stationId);
    }

    notifyListeners();
  }

  Future<void> loadBikesByStation(String stationid) async {
    bikes = await stationRepostiory.loadBikesByStation(stationid);
    notifyListeners();
  }

  Future<void> loadDockByStation(String stationid) async {
    slots = await stationRepostiory.loadSlotsByStation(stationid);
    notifyListeners();
  }

  List<Bike> getBikesAt() {
    return bikes.toList();
  }

  List<Slot> getDockAt() {
    return slots.where((s) => s.isEmpty).toList();
  }

  double? getDistanceTo(Station station) {
    if (userLocation == null) return null;

    const distance = Distance();
    return distance.as(LengthUnit.Meter, userLocation!, station.location);
  }

  Future<void> getUserLocation() async {
    isLoading = true;
    notifyListeners();

    try {
      // check if location service is enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        userLocation = fallback;
        return;
      }

      // check/request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          userLocation = fallback;
          return;
        }
      }

      // get actual position
      final position = await Geolocator.getCurrentPosition();
      userLocation = LatLng(position.latitude, position.longitude);
    } catch (e) {
      userLocation = fallback; // fallback if anything goes wrong
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
