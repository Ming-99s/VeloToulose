import '../../models/pass.dart';

abstract class PassRepository {
  Future<List<Pass>> fetchPass();
   Future<Pass?> getPassById(String id);
}