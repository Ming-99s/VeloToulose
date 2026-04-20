// lib/core/constants/pass_plans.dart

import 'package:velo_toulose/core/enum/pass_type.dart';

class PassPlan {
  final PassType type;
  final String title;
  final String period;
  final double price;
  final List<String> features;
  final String? badge;

  const PassPlan({
    required this.type,
    required this.title,
    required this.period,
    required this.price,
    required this.features,
    this.badge,
  });
}


// static list — no repo needed
const List<PassPlan> kPassPlans = [
  PassPlan(
    type: PassType.daily,
    title: 'Day Pass',
    period: '/24h',
    price: 2,
    features: [
      'No unlock fee all day',
      'First 30 min free per trip',
      'Overtime €0.05/min after 30 min',
    ],
  ),
  PassPlan(
    type: PassType.weekly,
    title: 'Monthly Pass',
    period: '/mo',
    price: 29,
    features: [
      'No unlock fee all month',
      'First 30 min free per trip',
      'Overtime €0.05/min after 30 min',
    ],
  ),
  PassPlan(
    type: PassType.annual,
    title: 'Year Pass',
    period: '/yr',
    price: 299,
    features: [
      'No unlock fee all year',
      'First 30 min free per trip',
      'Overtime €0.05/min after 30 min',
      'Full theft insurance included',
    ],
    badge: 'BEST VALUE',
  ),
];
