import 'package:flutter/material.dart';
import 'package:velo_toulose/features/booking/viewmodel/user_pass_viewmodel.dart';
import 'package:velo_toulose/features/notification/viewmodel/notification_view_model.dart';
import 'package:velo_toulose/models/user.dart';
import 'package:velo_toulose/repositories/abstract/user_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  final UserPassViewModel userPassViewModel;
  final NotificationViewModel notificationViewModel;

  AuthViewModel({
    required this.userRepository,
    required this.userPassViewModel,
    required this.notificationViewModel,
  });

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
      currentUser = await userRepository.login(email, password);
      await userPassViewModel.loadUserPass(currentUser!.userId);
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
      currentUser = await userRepository.register(
        firstName,
        lastName,
        email,
        password,
      );
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
    await userRepository.updateUser(updated);
  }

  Future<void> signOut() async {
    currentUser = null;
    error = null;
    userPassViewModel.clearPass();
    notificationViewModel.clearNotifications();
    notifyListeners();
  }

  void clearError() {
    error = null;
    notifyListeners();
  }
}
