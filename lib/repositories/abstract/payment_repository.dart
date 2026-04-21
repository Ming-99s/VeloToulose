import 'package:velo_toulose/models/payment.dart';

abstract class PaymentRepository {
  Future<void> savePayment(Payment payment);
  Future<List<Payment>> getPaymentsByUser(String userId);
}
