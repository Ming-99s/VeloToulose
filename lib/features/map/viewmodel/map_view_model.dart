import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:velo_toulose/models/bike.dart';
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

  void selectStation(Station station) {
    selectedStation = station;
    notifyListeners();
    loadBikesByStation(station.stationId);
  }

  void clearSelectedStation() {
    selectedStation = null;
    notifyListeners();
  }

  // Phnom Penh as fallback if location fails
  static const LatLng fallback = LatLng(11.5564, 104.9282);

  Future<void> loadStations() async {
    stations = await stationRepostiory.loadStations();
    notifyListeners();
  }

  Future<void> loadBikesByStation(String stationid) async {
    bikes = await stationRepostiory.loadBikesByStation(stationid);
    notifyListeners();
  }

  List<Bike> getBikesAt(Station station) {
    return bikes
        .where(
          (bike) => station.slots.any((slot) => slot.bikeId == bike.bikeId),
        )
        .toList();
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
