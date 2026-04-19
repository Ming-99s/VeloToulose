// Pass_repository_mock.dart

import 'package:velo_toulose/core/enum/pass_type.dart';

import '../../models/pass.dart';
import '../abstract/pass_repository.dart';
class PassRepositoryMock implements  PassRepository{

  @override
  Future<List<Pass>> fetchPass() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      Pass(
        passId: 'pass_001',
        type: PassType.day,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(hours: 24)),
        price: 2,
        isActive: true,
      ),
      Pass(
        passId: 'pass_002',
        type: PassType.annual,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 30)),
        price: 29,
        isActive: true,
      ),
      Pass(
        passId: 'pass_003',
        type: PassType.annual,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 365)),
        price: 299,
        isActive: true,
      ),
    ];
  }
}
