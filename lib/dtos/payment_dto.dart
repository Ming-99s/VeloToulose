import 'package:velo_toulose/core/enum/payment_type.dart';
import 'package:velo_toulose/models/payment.dart';

class PaymentDto {
  static const String paymentIdKey = 'paymentId';
  static const String userIdKey = 'userId';
  static const String typeKey = 'type';
  static const String amountKey = 'amount';
  static const String createdAtKey = 'createdAt';
  static const String rideIdKey = 'rideId';
  static const String passIdKey = 'passId';

  static Payment fromJson(String id, Map<String, dynamic> json) {
    assert(json[userIdKey] is String);
    assert(json[typeKey] is String);
    assert(json[amountKey] is num);
    assert(json[createdAtKey] is String);
    return Payment(
      paymentId: id,
      userId: json[userIdKey] as String,
      type: PaymentType.fromString(json[typeKey] as String),
      amount: (json[amountKey] as num).toDouble(),
      createdAt: DateTime.parse(json[createdAtKey] as String),
      rideId: json[rideIdKey] as String?,
      passId: json[passIdKey] as String?,
    );
  }

  static Map<String, dynamic> toJson(Payment payment) {
    return {
      paymentIdKey: payment.paymentId, 
      userIdKey: payment.userId,
      typeKey: payment.type.toJson(),
      amountKey: payment.amount,
      createdAtKey: payment.createdAt.toIso8601String(),
      rideIdKey: payment.rideId,
      passIdKey: payment.passId,
    };
  }
}
