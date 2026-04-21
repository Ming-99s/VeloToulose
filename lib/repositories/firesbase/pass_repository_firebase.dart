import 'package:firebase_database/firebase_database.dart';
import 'package:velo_toulose/dtos/pass_dto.dart';
import 'package:velo_toulose/models/pass.dart';
import 'package:velo_toulose/repositories/abstract/pass_repository.dart';

class PassRepositoryFirebase implements PassRepository {
  final FirebaseDatabase _db;

  PassRepositoryFirebase({FirebaseDatabase? db})
    : _db = db ?? FirebaseDatabase.instance;

  DatabaseReference get _passes => _db.ref('passes');

  @override
  Future<List<Pass>> fetchPass() async {
    final snapshot = await _passes.get();
    if (!snapshot.exists) return [];

    final passesMap = Map<String, dynamic>.from(snapshot.value as Map);

    return passesMap.entries
        .map((entry) {
          final data = Map<String, dynamic>.from(entry.value as Map);
          return PassDto.fromJson(entry.key, data);
        })
        .where((pass) => pass.isActive)
        .toList();
  }

  @override
  Future<Pass?> getPassById(String id) async {
    final snapshot = await _passes.child(id).get();
    if (!snapshot.exists) return null;
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return PassDto.fromJson(id, data);
  }
}
