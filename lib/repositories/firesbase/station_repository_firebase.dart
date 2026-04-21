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

      // FIX #10: parse slots directly from the snapshot — no extra reads
      final slots = _parseSlotsFromData(id, data);

      final locationData = Map<String, dynamic>.from(data['location'] as Map);

      result.add(
        Station(
          stationId: id,
          name: data['name'] as String,
          location: LatLng(
            (locationData['lat'] as num).toDouble(),
            (locationData['lng'] as num).toDouble(),
          ),
          capacity: data['capacity'] as int,
          slots: slots,
        ),
      );
    }

    return result;
  }


  List<Slot> _parseSlotsFromData(String stationId, Map<String, dynamic> data) {
    final rawSlots = data['slots'];
    if (rawSlots == null) return [];
    final slotsMap = Map<String, dynamic>.from(rawSlots as Map);
    return slotsMap.entries.map((e) {
      final sd = Map<String, dynamic>.from(e.value as Map);
      return Slot(
        slotId: e.key,
        stationId: stationId,
        bikeId: sd['bikeId'] as String?,
      );
    }).toList();
  }


  /// Still available for targeted single-station refreshes.
  @override
  Future<List<Slot>> loadSlotsByStation(String stationId) async {
    final snapshot = await _stations.child('$stationId/slots').get();
    if (!snapshot.exists) return [];

    final slotsMap = Map<String, dynamic>.from(snapshot.value as Map);

    return slotsMap.entries.map((entry) {
      final data = Map<String, dynamic>.from(entry.value as Map);
      return Slot(
        slotId: entry.key,
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
    if (!snapshot.exists || snapshot.value == null) return [];

    final raw = snapshot.value;
    if (raw is! Map) return [];

    return raw.entries.map((entry) {
      final data = Map<String, dynamic>.from(entry.value as Map);
      return Bike(
        bikeId: entry.key as String,
        slotId: data['slotId'] as String?,
      );
    }).toList();
  }


  @override
  Future<void> removeBikeFromStation(String stationId, String bikeId) async {
    final slotsSnap = await _stations.child('$stationId/slots').get();
    if (!slotsSnap.exists) return;

    final slotsMap = Map<String, dynamic>.from(slotsSnap.value as Map);
    for (final entry in slotsMap.entries) {
      final data = Map<String, dynamic>.from(entry.value as Map);
      if (data['bikeId'] == bikeId) {
        await _stations.child('$stationId/slots/${entry.key}').update({
          'bikeId': null,
          'status': 'free',
        });
        break;
      }
    }
    await _bikes.child(bikeId).update({'slotId': null, 'stationId': null});
  }


  @override
  Future<void> addBikeToStation(String stationId, String bikeId) async {
    String? claimedSlotId;

    final result = await _stations.child('$stationId/slots').runTransaction((
      currentData,
    ) {
      if (currentData == null) return Transaction.abort();

      final slotsMap = Map<String, dynamic>.from(currentData as Map);

      for (final entry in slotsMap.entries) {
        final slotData = Map<String, dynamic>.from(entry.value as Map);
        if (slotData['bikeId'] == null) {
          claimedSlotId = entry.key;
          slotsMap[entry.key] = {
            ...slotData,
            'bikeId': bikeId,
            'status': 'occupied',
          };
          return Transaction.success(slotsMap);
        }
      }

      return Transaction.abort(); // station full
    });

    if (!result.committed || claimedSlotId == null) {
      throw Exception('No free slots at station $stationId');
    }

    await _bikes.child(bikeId).update({
      'slotId': claimedSlotId,
      'stationId': stationId,
    });
  }
}
