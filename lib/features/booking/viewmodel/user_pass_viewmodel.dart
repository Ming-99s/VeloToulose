import 'package:flutter/material.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/models/pass.dart';
import 'package:velo_toulose/repositories/abstract/pass_repository.dart';

class UserPassViewModel extends ChangeNotifier {
  final PassRepository _repository;
  late AuthViewModel _authViewModel;

  UserPassViewModel({required PassRepository repository})
    : _repository = repository;

  void setAuthViewModel(AuthViewModel auth) {
    _authViewModel = auth;
  }

  Pass? _activePass;
  Pass? get activePass => _activePass;
  bool get hasActivePass => _activePass != null && _activePass!.isValid();

  Future<void> loadUserPass() async {
    final userId = _authViewModel.currentUser?.userId;
    if (userId == null) {
      _activePass = null;
      notifyListeners();
      return;
    }
    _activePass = await _repository.getPassForUser(userId);
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
