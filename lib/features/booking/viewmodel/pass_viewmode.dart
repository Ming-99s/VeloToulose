import 'package:flutter/material.dart';
import 'package:velo_toulose/core/enum/pass_plans.dart';
import 'package:velo_toulose/core/enum/pass_type.dart';
import 'package:velo_toulose/core/utils/id_generator.dart';
import 'package:velo_toulose/models/pass.dart';
import 'package:velo_toulose/repositories/abstract/pass_repository.dart';

class PassViewModel extends ChangeNotifier {
  // static plans — no loading, no repo
  final List<PassPlan> plans = kPassPlans;
  final PassRepository passRepository;

  PassViewModel({required this.passRepository});

  int _selectedIndex = 2;
  int get selectedIndex => _selectedIndex;

  PassPlan get selectedPlan => plans[_selectedIndex];

  // FIX #8: userId is required so the Pass is correctly scoped in Firebase
  Pass buildSelectedPass(String userId) {
    final plan = selectedPlan;
    final now = DateTime.now();

    Duration validity;
    switch (plan.type) {
      case PassType.daily:
        validity = const Duration(hours: 24);
        break;
      case PassType.weekly:
        validity = const Duration(days: 7);
        break;
      case PassType.annual:
        validity = const Duration(days: 365);
        break;
      default:
        validity = const Duration(hours: 24);
    }

    return Pass(
      passId: IdGenerator.pass(plan.type.name),
      userId: userId,
      type: plan.type,
      startDate: now,
      endDate: now.add(validity),
      price: plan.price,
      isActive: true,
    );
  }

  void selectPass(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}
