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

  /// Call this when user buys a pass.
  /// FIX #1: now persists the Pass object to Firebase BEFORE linking it to
  /// the user, so [loadUserPass] can retrieve it after an app restart.
  Future<void> activatePass(Pass pass) async {
    _activePass = pass;
    notifyListeners(); // update UI immediately (optimistic)

    // Persist the Pass document first
    await _repository.savePass(pass);

    // Then link the passId on the user record
    final updatedUser = _authViewModel.currentUser?.copyWith(
      passid: pass.passId,
    );
    if (updatedUser != null) {
      await _authViewModel.updateUser(updatedUser);
    }
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
