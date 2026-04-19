import 'package:flutter/material.dart';
import 'package:velo_toulose/models/pass.dart';
import 'package:velo_toulose/repositories/abstract/pass_repository.dart';

class PassViewModel extends ChangeNotifier {
  final PassRepository _repository;

  PassViewModel({required PassRepository repository}) : _repository = repository;

  List<Pass> _passes = [];
  List<Pass> get passes => _passes;

  int _selectedIndex = 2; // default to Year Pass
  int get selectedIndex => _selectedIndex;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Pass? get selectedPass =>
      _passes.isNotEmpty ? _passes[_selectedIndex] : null;

  Future<void> fetchPasses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _passes = await _repository.fetchPass();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectPass(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
