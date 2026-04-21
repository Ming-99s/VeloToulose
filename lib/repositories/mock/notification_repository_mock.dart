import 'package:velo_toulose/models/notification.dart';
import 'package:velo_toulose/repositories/abstract/notification_repository.dart';

class NotificationRepositoryMock implements NotificationRepository {
  final List<AppNotification> _notifications = [];

  @override
  Future<List<AppNotification>> getNotificationsByUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // only return notifications for this specific user
    return _notifications
        .where((n) => n.userId == userId)
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<void> saveNotification(AppNotification notification) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _notifications.insert(0, notification);
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final index = _notifications.indexWhere(
      (n) => n.notificationId == notificationId,
    );
    if (index != -1) {
      _notifications[index] = _notifications[index].markAsRead();
    }
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    for (var i = 0; i < _notifications.length; i++) {
      if (_notifications[i].userId == userId && !_notifications[i].isRead) {
        _notifications[i] = _notifications[i].markAsRead();
      }
    }
  }
}
