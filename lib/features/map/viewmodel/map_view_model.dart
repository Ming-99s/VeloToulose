import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapViewModel extends ChangeNotifier {
  LatLng? userLocation;
  bool isLoading = false;

  // Phnom Penh as fallback if location fails
  static const LatLng fallback = LatLng(11.5564, 104.9282);

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
