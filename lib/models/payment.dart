
import 'package:velo_toulose/core/enum/payment_type.dart';

class Payment {
  final String paymentId;
  final String userId;
  final PaymentType type;
  final double amount;
  final DateTime createdAt;
  final String? rideId; // null if paying for a pass
  final String? passId; // null if paying for a ride

  const Payment({
    required this.paymentId,
    required this.userId,
    required this.type,
    required this.amount,
    required this.createdAt,
    this.rideId,
    this.passId,
  });

  Payment copyWith({
    String? paymentId,
    String? userId,
    PaymentType? type,
    double? amount,
    DateTime? createdAt,
    String? rideId,
    String? passId,
  }) {
    return Payment(
      paymentId: paymentId ?? this.paymentId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
      rideId: rideId ?? this.rideId,
      passId: passId ?? this.passId,
    );
  }
}
