import 'package:flutter/material.dart';
import 'package:velo_toulose/features/booking/viewmodel/user_pass_viewmodel.dart';
import 'package:velo_toulose/features/notification/viewmodel/notification_view_model.dart';
import 'package:velo_toulose/models/user.dart';
import 'package:velo_toulose/repositories/abstract/user_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final UserRepository _repository;
  final UserPassViewModel _userPassViewModel;
  final NotificationViewModel _notificationViewModel;

  AuthViewModel(
    this._repository, {
    required UserPassViewModel userPassViewModel,
    required NotificationViewModel notificationViewModel,
  }) : _userPassViewModel = userPassViewModel,
       _notificationViewModel = notificationViewModel;

  User? currentUser;
  bool isLoading = false;
  String? error;

  bool get isLoggedIn => currentUser != null;

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      error = 'Please fill in all fields';
      notifyListeners();
      return false;
    }
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      currentUser = await _repository.login(email, password);
      await _userPassViewModel.loadUserPass(); // ✅
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        password.isEmpty) {
      error = 'Please fill in all fields';
      notifyListeners();
      return false;
    }
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      currentUser = await _repository.register(
        firstName,
        lastName,
        email,
        password,
      );
      await _userPassViewModel.loadUserPass(); // ✅
      return true;
    } catch (e) {
      error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(User updated) async {
    currentUser = updated;
    notifyListeners();
    await _repository.updateUser(updated);
  }

  Future<void> signOut() async {
    currentUser = null;
    error = null;
    _userPassViewModel.clearPass(); 
    _notificationViewModel.clearNotifications(); 
    notifyListeners();
  }

  void clearError() {
    error = null;
    notifyListeners();
  }
}
