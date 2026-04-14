import 'package:velo_toulose/models/bike.dart';
import 'package:velo_toulose/models/station.dart';

abstract class StationRepostiory {
  Future<List<Station>> loadStations();
  Future<List<Bike>> loadBikesByStation(String stationId);
}
