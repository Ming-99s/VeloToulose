import 'package:flutter/material.dart';
import 'package:velo_toulose/core/utils/id_generator.dart';
import 'package:velo_toulose/models/notification.dart';
import 'package:velo_toulose/models/pass.dart';
import 'package:velo_toulose/models/ride.dart';
import 'package:velo_toulose/repositories/abstract/notification_repository.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationRepository _repository;

  NotificationViewModel(this._repository);

  List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  // store ride + pass data per notification for RideSummaryScreen
  final Map<String, Ride> _rideData = {};
  final Map<String, bool> _hasPassData = {};

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  Ride? getRideForNotification(String notificationId) =>
      _rideData[notificationId];

  bool hadPassForNotification(String notificationId) =>
      _hasPassData[notificationId] ?? false;

  // load notifications for current user only
  Future<void> loadNotifications(String userId) async {
    _notifications = await _repository.getNotificationsByUser(userId);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications = [];
    _rideData.clear();
    _hasPassData.clear();
    notifyListeners();
  }

  // called when a ride ends
  Future<void> addRideReceipt(Ride ride, {required bool hasPass}) async {
    final duration = ride.duration;
    const int freeMinutes = 30;

    String message;
    if (hasPass) {
      message = 'Ride completed in ${duration}min. Covered by your pass!';
    } else if (!ride.isOvertime()) {
      message = 'Ride completed in ${duration}min. Total: Free!';
    } else {
      final cost = ride.cost;
      final overtime = duration - freeMinutes;
      message =
          'Ride completed in ${duration}min. Overtime: ${overtime}min × €0.05 = €${cost.toStringAsFixed(2)}';
    }

    final notification = AppNotification(
      notificationId: IdGenerator.notification(),
      userId: ride.userId,
      type: 'payment_receipt',
      message: message,
      sentAt: DateTime.now(),
    );

    await _repository.saveNotification(notification);

    // store ride data for RideSummaryScreen
    _rideData[notification.notificationId] = ride;
    _hasPassData[notification.notificationId] = hasPass;

    await loadNotifications(ride.userId);
  }

  // called when a user buys a pass
  Future<void> addPassPurchase(Pass pass, String userId) async {
    final message =
        'You purchased a ${pass.type.name} pass for €${pass.price.toStringAsFixed(2)}.';

    final notification = AppNotification(
      notificationId: IdGenerator.notification(),
      userId: userId,
      type: 'pass_purchase',
      message: message,
      sentAt: DateTime.now(),
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
