import 'package:firebase_database/firebase_database.dart';
import 'package:latlong2/latlong.dart';
import 'package:velo_toulose/models/bike.dart';
import 'package:velo_toulose/models/slot.dart';
import 'package:velo_toulose/models/station.dart';
import 'package:velo_toulose/repositories/abstract/station_repostiory.dart';

class StationRepositoryFirebase implements StationRepostiory {
  final FirebaseDatabase _db;

  StationRepositoryFirebase({FirebaseDatabase? db})
    : _db = db ?? FirebaseDatabase.instance;

  DatabaseReference get _stations => _db.ref('stations');
  DatabaseReference get _bikes => _db.ref('bikes');

  @override
  Future<List<Station>> loadStations() async {
    final snapshot = await _stations.get();
    if (!snapshot.exists) return [];

    final stationsMap = Map<String, dynamic>.from(snapshot.value as Map);
    final List<Station> result = [];

    for (final entry in stationsMap.entries) {
      final id = entry.key;
      final data = Map<String, dynamic>.from(entry.value as Map);

      final slots = await loadSlotsByStation(id);

      final locationData = Map<String, dynamic>.from(data['location'] as Map);
      final location = LatLng(
        (locationData['lat'] as num).toDouble(),
        (locationData['lng'] as num).toDouble(),
      );

      result.add(
        Station(
          stationId: id,
          name: data['name'] as String,
          location: location,
          capacity: data['capacity'] as int,
          slots: slots,
        ),
      );
    }

    return result;
  }

  @override
  Future<List<Slot>> loadSlotsByStation(String stationId) async {
    final snapshot = await _stations.child('$stationId/slots').get();
    if (!snapshot.exists) return [];

    final slotsMap = Map<String, dynamic>.from(snapshot.value as Map);

    return slotsMap.entries.map((entry) {
      final id = entry.key;
      final data = Map<String, dynamic>.from(entry.value as Map);
      return Slot(
        slotId: id,
        stationId: stationId,
        bikeId: data['bikeId'] as String?,
      );
    }).toList();
  }

  @override
  Future<List<Bike>> loadBikesByStation(String stationId) async {
    final snapshot = await _bikes
        .orderByChild('stationId')
        .equalTo(stationId)
        .get();
    if (!snapshot.exists) return [];

    final bikesMap = Map<String, dynamic>.from(snapshot.value as Map);

    return bikesMap.entries.map((entry) {
      final id = entry.key;
      final data = Map<String, dynamic>.from(entry.value as Map);
      return Bike(bikeId: id, slotId: data['slotId'] as String?);
    }).toList();
  }

  @override
  void removeBikeFromStation(String stationId, String bikeId) async {
    // Find which slot has this bike and clear it
    final slotsSnap = await _stations.child('$stationId/slots').get();
    if (!slotsSnap.exists) return;

    final slotsMap = Map<String, dynamic>.from(slotsSnap.value as Map);
    for (final entry in slotsMap.entries) {
      final data = Map<String, dynamic>.from(entry.value as Map);
      if (data['bikeId'] == bikeId) {
        // Free the slot
        await _stations.child('$stationId/slots/${entry.key}').update({
          'bikeId': null,
          'status': 'free',
        });
        break;
      }
    }

    // Mark bike as on a ride
    await _bikes.child(bikeId).update({'slotId': null, 'stationId': null});
  }

  @override
  void addBikeToStation(String stationId, String bikeId) async {
    // Find first free slot in this station
    final slotsSnap = await _stations.child('$stationId/slots').get();
    if (!slotsSnap.exists) return;

    final slotsMap = Map<String, dynamic>.from(slotsSnap.value as Map);
    for (final entry in slotsMap.entries) {
      final data = Map<String, dynamic>.from(entry.value as Map);
      if (data['bikeId'] == null) {
        final slotId = entry.key;

        // Assign bike to first free slot
        await _stations.child('$stationId/slots/$slotId').update({
          'bikeId': bikeId,
          'status': 'occupied',
        });

        // Update bike location
        await _bikes.child(bikeId).update({
          'slotId': slotId,
          'stationId': stationId,
        });
        break;
      }
    }
  }
}
