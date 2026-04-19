import 'package:flutter/material.dart';
import 'package:velo_toulose/models/notification.dart';
import 'package:velo_toulose/models/pass.dart';
import 'package:velo_toulose/models/ride.dart';

class NotificationViewModel extends ChangeNotifier {
  // List of all notifications 
  final List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => _notifications;

  // Store ride data for each notification to show receipt details
  final Map<String, Ride> _rideData = {};

  // Store whether user had a pass for each notification
  final Map<String, bool> _hasPassData = {};

  // unread notifications
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  /// Get the ride data for a notification
  Ride? getRideForNotification(String notificationId) {
    return _rideData[notificationId];
  }

  /// Check if the user had a pass for this notification
  bool hadPassForNotification(String notificationId) {
    return _hasPassData[notificationId] ?? false;
  }

  /// Called when a ride ends creates a payment receipt notification
  void addRideReceipt(Ride ride, {bool hasPass = false}) {
    final duration = ride.duration;

    // Build a simple receipt message
    String message;
    if (hasPass) {
      message = 'Ride completed in ${duration}s. Covered by your pass!';
    } else if (duration <= Ride.freeSeconds) {
      message = 'Ride completed in ${duration}s. Total: Free!';
    } else {
      final cost = ride.cost;
      final overtime = duration - Ride.freeSeconds;
      message = 'Ride completed in ${duration}s. '
          'Overtime: ${overtime}s × €0.05 = €${cost.toStringAsFixed(2)}';
    }

    final notification = AppNotification(
      notificationId: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      userId: ride.userId,
      type: 'payment_receipt',
      message: message,
      sentAt: DateTime.now(),
    );

    // Add to the top of the list
    _notifications.insert(0, notification);
    // Store ride data so receipt screen can use it
    _rideData[notification.notificationId] = ride;
    _hasPassData[notification.notificationId] = hasPass;
    notifyListeners();
  }

  /// Called when a user buys a pass
  void addPassPurchase(Pass pass, String userId) {
    final typeName = pass.type.name; // daily, weekly, annual
    final message = 'You purchased a $typeName pass for \u20ac${pass.price.toStringAsFixed(2)}.';

    final notification = AppNotification(
      notificationId: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      type: 'pass_purchase',
      message: message,
      sentAt: DateTime.now(),
    );

    _notifications.insert(0, notification);
    notifyListeners();
  }

  /// Mark a single notification as read
  void markAsRead(String notificationId) {
    final index = _notifications.indexWhere(
      (n) => n.notificationId == notificationId,
    );
    if (index != -1) {
      _notifications[index] = _notifications[index].markAsRead();
      notifyListeners();
    }
  }

  /// Mark all notifications as read
  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].markAsRead();
      }
    }
    notifyListeners();
  }
}
