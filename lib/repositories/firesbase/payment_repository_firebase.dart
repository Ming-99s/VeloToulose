import 'package:firebase_database/firebase_database.dart';
import 'package:velo_toulose/dtos/payment_dto.dart';
import 'package:velo_toulose/models/payment.dart';
import 'package:velo_toulose/repositories/abstract/payment_repository.dart';

class PaymentRepositoryFirebase implements PaymentRepository {
  final FirebaseDatabase _db;

  PaymentRepositoryFirebase({FirebaseDatabase? db})
    : _db = db ?? FirebaseDatabase.instance;

  DatabaseReference get _payments => _db.ref('payments');

  @override
  Future<void> savePayment(Payment payment) async {
    await _payments.child(payment.paymentId).set(PaymentDto.toJson(payment));
  }

  @override
  Future<List<Payment>> getPaymentsByUser(String userId) async {
    final snapshot = await _payments
        .orderByChild('userId')
        .equalTo(userId)
        .get();

    if (!snapshot.exists) return [];

    final map = Map<String, dynamic>.from(snapshot.value as Map);

    final list = map.entries.map((entry) {
      final data = Map<String, dynamic>.from(entry.value as Map);
      return PaymentDto.fromJson(entry.key, data);
    }).toList();

    // newest first
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }
}
