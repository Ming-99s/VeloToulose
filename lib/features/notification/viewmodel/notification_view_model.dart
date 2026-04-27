import 'package:flutter/material.dart';
import 'package:velo_toulose/core/enum/notification_type.dart';
import 'package:velo_toulose/core/utils/id_generator.dart';
import 'package:velo_toulose/models/notification.dart';
import 'package:velo_toulose/models/pass.dart';
import 'package:velo_toulose/models/payment.dart';
import 'package:velo_toulose/models/ride.dart';
import 'package:velo_toulose/repositories/abstract/notification_repository.dart';
import 'package:velo_toulose/repositories/abstract/payment_repository.dart';

class NotificationViewModel extends ChangeNotifier {
final NotificationRepository _repository;
  final PaymentRepository _paymentRepository;

  NotificationViewModel(this._repository, this._paymentRepository);

  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Future<void> loadNotifications(String userId) async {
    _notifications = await _repository.getNotificationsByUser(userId);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications = [];
    notifyListeners();
  }
String? getRideIdForNotification(String notificationId) {
    try {
      final notification = _notifications.firstWhere(
        (n) => n.notificationId == notificationId,
      );
      return notification.rideId;
    } catch (_) {
      return null;
    }
  }
  Future<Payment?> getPaymentForNotification(String notificationId) async {
    try {
      final notification = _notifications.firstWhere(
        (n) => n.notificationId == notificationId,
      );

      if (notification.paymentId == null) return null;

      return await _paymentRepository.getPaymentById(notification.paymentId!);
    } catch (_) {
      return null;
    }
  }

  Future<Payment?> getPassPaymentForNotification(String notificationId) async {
    try {
      final notification = _notifications.firstWhere(
        (n) => n.notificationId == notificationId,
      );

      if (notification.paymentId == null) return null;

      final payment = await _paymentRepository.getPaymentById(
        notification.paymentId!,
      );

      if (payment == null || payment.passId == null) return null;

      return payment;
    } catch (_) {
      return null;
    }
  }

  Future<void> addRideReceipt(Ride ride, {required bool hasPass, String? paymentId}) async {
    final duration = ride.duration;
    final cost = ride.calculateCost(hasPass: hasPass);
    const int freeMinutes = Ride.freeMinutes;

    String message;
    if (hasPass) {
      message = 'Ride completed in ${duration}min. Covered by your pass!';
    } else if (!ride.isOvertime()) {
      message = 'Ride completed in ${duration}min. Total: Free!';
    } else {
      final overtime = duration - freeMinutes;
      message =
          'Ride completed in ${duration}min. Overtime: ${overtime}min x €0.05 = €${cost.toStringAsFixed(2)}';
    }

    final notification = AppNotification(
      notificationId: IdGenerator.notification(),
      userId: ride.userId,
      type: NotificationType.rideReceipt,
      message: message,
      sentAt: DateTime.now(),
      rideId: ride.rideId,
      paymentId: paymentId,
    );

    await _repository.saveNotification(notification);
    await loadNotifications(ride.userId);
  }

  Future<void> addPaymentReceipt(Payment payment) async {
    final message =
        'Unlock fee of €${payment.amount.toStringAsFixed(2)} charged. Enjoy your ride!';
    final notification = AppNotification(
      notificationId: IdGenerator.notification(),
      userId: payment.userId,
      type: NotificationType.unlockFee,
      message: message,
      sentAt: DateTime.now(),
      paymentId: payment.paymentId,
    );
    await _repository.saveNotification(notification);
    await loadNotifications(payment.userId);
  }

  Future<void> addPassPurchase(Pass pass, String userId, {String? paymentId}) async {
    final message =
        'You purchased a ${pass.type.name} pass for €${pass.price.toStringAsFixed(2)}.';

    final notification = AppNotification(
      notificationId: IdGenerator.notification(),
      userId: userId,
      type: NotificationType.passPurchase,
      message: message,
      sentAt: DateTime.now(),
      paymentId: paymentId,
    );

    await _repository.saveNotification(notification);
    await loadNotifications(userId);
  }

  Future<void> markAsRead(String notificationId, String userId) async {
    await _repository.markAsRead(notificationId);
    await loadNotifications(userId);
  }

  Future<void> markAllAsRead(String userId) async {
    await _repository.markAllAsRead(userId);
    await loadNotifications(userId);
  }
}
