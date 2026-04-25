import 'package:flutter/material.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/models/pass.dart';
import 'package:velo_toulose/repositories/abstract/pass_repository.dart';

class UserPassViewModel extends ChangeNotifier {
  final PassRepository passRepository;

  UserPassViewModel({
    required  this.passRepository,
  });

  Pass? _activePass;
  Pass? get activePass => _activePass;
  bool get hasActivePass => _activePass != null && _activePass!.isValid();

  Future<void> loadUserPass(String userId) async {
    
    _activePass = await passRepository.getPassForUser(userId);
    notifyListeners();
  }

  Future<void> activatePass(Pass pass) async {
    _activePass = pass;
    notifyListeners();
  }

  void clearPass() {
    _activePass = null;
    notifyListeners();
  }
}
