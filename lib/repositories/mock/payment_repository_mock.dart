import 'package:velo_toulose/models/payment.dart';
import 'package:velo_toulose/repositories/abstract/payment_repository.dart';

class PaymentRepositoryMock implements PaymentRepository {
  final List<Payment> _payments = [];

  @override
  Future<void> savePayment(Payment payment) async {
    _payments.add(payment);
  }

  @override
  Future<List<Payment>> getPaymentsByUser(String userId) async {
    final list = _payments.where((p) => p.userId == userId).toList();

    // newest first
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }
}
