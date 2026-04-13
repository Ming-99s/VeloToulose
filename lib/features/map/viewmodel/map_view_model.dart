import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:velo_toulose/models/station.dart';
import 'package:velo_toulose/repositories/abstract/station_repostiory.dart';
import 'package:velo_toulose/repositories/mock/station_repository_mock.dart';

class MapViewModel extends ChangeNotifier {
  LatLng? userLocation;
  bool isLoading = false;
  Station? selectedStation; 

  List<Station> stations = [];

  void selectStation(Station station) {
    selectedStation = station;
    notifyListeners();
  }

  void clearSelectedStation() {
    selectedStation = null;
    notifyListeners();
  }
  // Phnom Penh as fallback if location fails
  static const LatLng fallback = LatLng(11.5564, 104.9282);
  final StationRepostiory _stationRepo = StationRepositoryMock();

  Future<void> loadStations() async {
    stations = await _stationRepo.loadStations();
    notifyListeners();
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
