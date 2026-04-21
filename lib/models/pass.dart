import 'package:velo_toulose/core/enum/pass_type.dart';

class Pass {
  final String passId;
  final String userId; 
  final PassType type;
  final DateTime startDate;
  final DateTime endDate;
  final double price;
  final bool isActive;

  const Pass({
    required this.passId,
    required this.userId,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.price,
    required this.isActive,
  });

  bool isValid() {
    final now = DateTime.now();
    return isActive && now.isAfter(startDate) && now.isBefore(endDate);
  }

  Pass copyWith({
    String? passId,
    String? userId,
    PassType? type,
    DateTime? startDate,
    DateTime? endDate,
    double? price,
    bool? isActive,
  }) {
    return Pass(
      passId: passId ?? this.passId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      price: price ?? this.price,
      isActive: isActive ?? this.isActive,
    );
  }
}
