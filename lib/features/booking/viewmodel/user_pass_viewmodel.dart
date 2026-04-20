import 'package:flutter/material.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/models/pass.dart';
import 'package:velo_toulose/repositories/abstract/pass_repository.dart';

class UserPassViewModel extends ChangeNotifier {
  final PassRepository _repository;
  final AuthViewModel _authViewModel;

  UserPassViewModel({
    required PassRepository repository,
    required AuthViewModel authViewModel,
  }) : _repository = repository,
       _authViewModel = authViewModel;

  Pass? _activePass;
  Pass? get activePass => _activePass;
  bool get hasActivePass => _activePass != null && _activePass!.isValid();

  // call this after login
  Future<void> loadUserPass() async {
    final passId = _authViewModel.currentUser?.passid;
    if (passId == null) {
      _activePass = null;
      notifyListeners();
      return;
    }
    _activePass = await _repository.getPassById(passId);
    notifyListeners();
  }

  // call this when user buys a pass
  Future<void> activatePass(Pass pass) async {
    _activePass = pass;

    final updatedUser = _authViewModel.currentUser?.copyWith(
      passid: pass.passId,
    );
    if (updatedUser != null) {
      await _authViewModel.updateUser(updatedUser);
    }
    notifyListeners();
  }

  void clearPass() {
    _activePass = null;
    final updatedUser = _authViewModel.currentUser?.copyWith(clearPass: true);
    if (updatedUser != null) {
      _authViewModel.updateUser(updatedUser);
    }
    notifyListeners();
  }
}
