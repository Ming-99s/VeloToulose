import 'package:hive_flutter/hive_flutter.dart';
import 'package:velo_toulose/dtos/pass_dto.dart';
import '../../models/pass.dart';
import '../abstract/pass_repository.dart';

class PassRepositoryMock implements PassRepository {
  static const _boxName = 'user_passes_box';

  Box get _box => Hive.box(_boxName);

  @override
  Future<List<Pass>> fetchPass() async => [];

@override
  Future<void> savePass(Pass pass) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // overwrite any existing pass for this user
    final existing = await getPassForUser(pass.userId);
    if (existing != null) await _box.delete(existing.passId);
    final json = PassDto().toJson(pass);
    await _box.put(pass.passId, json);
  }

  @override
  Future<Pass?> getPassById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final raw = _box.get(id);
    if (raw == null) return null;
    return PassDto.fromJson(id, Map<String, dynamic>.from(raw as Map));
  }

@override
  Future<Pass?> getPassForUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (final e in _box.values) {
      final map = Map<String, dynamic>.from(e as Map);
      if (map[PassDto.userIdKey] == userId) {
        return PassDto.fromJson(map[PassDto.passIdKey], map);
      }
    }
    return null;
  }
}
