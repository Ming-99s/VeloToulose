// Pass_repository_mock.dart

import '../../models/pass.dart';
import '../abstract/pass_repository.dart';

class PassRepositoryMock implements  PassRepository{

  @override
  Future<List<Pass>> fetchPass() async {
    return Future.delayed(Duration(seconds: 4), () {
      throw Exception("No pass yet");
    });
  }
}
