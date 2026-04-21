import 'package:firebase_database/firebase_database.dart';
import 'package:velo_toulose/dtos/pass_dto.dart';
import 'package:velo_toulose/models/pass.dart';
import 'package:velo_toulose/repositories/abstract/pass_repository.dart';

class PassRepositoryFirebase implements PassRepository {
  final FirebaseDatabase _db;

  PassRepositoryFirebase({FirebaseDatabase? db})
    : _db = db ?? FirebaseDatabase.instance;

  DatabaseReference get _passes => _db.ref('passes');

  /// FIX #1: Persists the Pass object so it survives app restarts.
  @override
  Future<void> savePass(Pass pass) async {
    await _passes.child(pass.passId).set(PassDto.toJson(pass));
  }

  @override
  Future<Pass?> getPassById(String id) async {
    final snapshot = await _passes.child(id).get();
    if (!snapshot.exists) return null;
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return PassDto.fromJson(id, data);
  }

  @override
  Future<List<Pass>> fetchPass() async {
    final snapshot = await _passes.get();
    if (!snapshot.exists) return [];

    final passesMap = Map<String, dynamic>.from(snapshot.value as Map);
    return passesMap.entries
        .map(
          (e) => PassDto.fromJson(
            e.key,
            Map<String, dynamic>.from(e.value as Map),
          ),
        )
        .where((p) => p.isActive)
        .toList();
  }
}
