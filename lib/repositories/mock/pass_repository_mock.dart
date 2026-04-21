import 'package:velo_toulose/core/enum/pass_type.dart';
import 'package:velo_toulose/models/pass.dart';
import 'package:velo_toulose/repositories/abstract/pass_repository.dart';

class PassRepositoryMock implements PassRepository {
  // FIX #1: in-memory store so savePass / getPassById work correctly in dev
  final Map<String, Pass> _store = {};

  @override
  Future<void> savePass(Pass pass) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _store[pass.passId] = pass;
  }

  @override
  Future<Pass?> getPassById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _store[id];
  }

  @override
  Future<List<Pass>> fetchPass() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Pass(
        passId: 'pass_001',
        userId: 'mock_user',
        type: PassType.daily,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(hours: 24)),
        price: 2,
        isActive: true,
      ),
      Pass(
        passId: 'pass_002',
        userId: 'mock_user',
        type: PassType.weekly,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 7)),
        price: 15,
        isActive: true,
      ),
      Pass(
        passId: 'pass_003',
        userId: 'mock_user',
        type: PassType.annual,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 365)),
        price: 99,
        isActive: true,
      ),
    ];
  }
}
