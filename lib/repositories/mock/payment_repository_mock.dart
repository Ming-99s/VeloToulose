import 'package:hive_flutter/hive_flutter.dart';
import 'package:velo_toulose/dtos/payment_dto.dart';
import 'package:velo_toulose/models/payment.dart';
import 'package:velo_toulose/repositories/abstract/payment_repository.dart';

class PaymentRepositoryMock implements PaymentRepository {

  Box get _box => Hive.box('payments_box');

  @override
  Future<void> savePayment(Payment payment) async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _box.put(payment.paymentId, PaymentDto.toJson(payment));
  }

  @override
  Future<Payment?> getPaymentById(String paymentId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final raw = _box.get(paymentId);
    if (raw == null) return null;

    final map = Map<String, dynamic>.from(raw as Map);
    return PaymentDto.fromJson(map[PaymentDto.paymentIdKey], map);
  }

  @override
  Future<List<Payment>> getPaymentsByUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final list = _box.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .where((map) => map[PaymentDto.userIdKey] == userId)
        .map(
          (map) =>
              PaymentDto.fromJson(map[PaymentDto.paymentIdKey] as String, map),
        )
        .toList();

    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }
}
