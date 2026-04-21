import 'package:velo_toulose/models/bike.dart';
import 'package:velo_toulose/models/slot.dart';
import 'package:velo_toulose/models/station.dart';

abstract class StationRepostiory {
  Future<List<Station>> loadStations();
  Future<List<Bike>> loadBikesByStation(String stationId);
  Future<List<Slot>> loadSlotsByStation(String stationId);
  Future<void> removeBikeFromStation(String stationId, String bikeId);
  Future<void> addBikeToStation(String stationId, String bikeId);
}
