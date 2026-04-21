import 'package:flutter/material.dart';
import 'package:velo_toulose/models/pass.dart';

enum PaymentMethodOption { payAsYouGo, selectPass }

class PaymentMethodViewModel extends ChangeNotifier {
  static const double unlockFee = 2.50;

  PaymentMethodOption _selected = PaymentMethodOption.payAsYouGo;
  PaymentMethodOption get selected => _selected;

  Pass? _selectedPass;
  Pass? get selectedPass => _selectedPass;

  double get totalPrice => _selectedPass != null ? 0.0 : unlockFee;

  String get priceLabel =>
      _selectedPass != null ? 'Free' : '€${unlockFee.toStringAsFixed(2)}';

  void selectPayAsYouGo() {
    _selected = PaymentMethodOption.payAsYouGo;
    _selectedPass = null;
    notifyListeners();
  }

  void setSelectedPass(Pass pass) {
    _selectedPass = pass;
    _selected = PaymentMethodOption.selectPass;
    notifyListeners();
  }
}
