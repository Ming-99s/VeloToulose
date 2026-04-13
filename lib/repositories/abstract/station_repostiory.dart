import 'package:velo_toulose/models/station.dart';

abstract class StationRepostiory {
  Future<List<Station>> loadStations();
}
