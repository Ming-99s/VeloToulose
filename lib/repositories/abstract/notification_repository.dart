import 'package:velo_toulose/models/notification.dart';

abstract class NotificationRepository {
  Future<List<AppNotification>> getNotificationsByUser(String userId);
  Future<void> saveNotification(AppNotification notification);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
}
