import 'package:firebase_database/firebase_database.dart';
import 'package:velo_toulose/dtos/notification_dto.dart';
import 'package:velo_toulose/models/notification.dart';
import 'package:velo_toulose/repositories/abstract/notification_repository.dart';

class NotificationRepositoryFirebase implements NotificationRepository {
  final FirebaseDatabase _db;

  NotificationRepositoryFirebase({FirebaseDatabase? db})
    : _db = db ?? FirebaseDatabase.instance;

  DatabaseReference get _notifications => _db.ref('notifications');

  @override
  Future<List<AppNotification>> getNotificationsByUser(String userId) async {
    final snapshot = await _notifications
        .orderByChild('userId')
        .equalTo(userId)
        .get();

    if (!snapshot.exists) return [];

    final map = Map<String, dynamic>.from(snapshot.value as Map);

    final list = map.entries.map((entry) {
      final data = Map<String, dynamic>.from(entry.value as Map);
      return NotificationDto.fromJson(entry.key, data);
    }).toList();

    // Sort newest first (Realtime DB doesn't sort by multiple fields)
    list.sort((a, b) => b.sentAt.compareTo(a.sentAt));
    return list;
  }

  @override
  Future<void> saveNotification(AppNotification notification) async {
    await _notifications
        .child(notification.notificationId)
        .set(NotificationDto.toJson(notification));
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _notifications.child(notificationId).update({
      NotificationDto.isReadKey: true,
    });
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    final snapshot = await _notifications
        .orderByChild('userId')
        .equalTo(userId)
        .get();

    if (!snapshot.exists) return;

    final map = Map<String, dynamic>.from(snapshot.value as Map);

    // Update all unread notifications in parallel
    final futures = map.entries.map((entry) {
      final data = Map<String, dynamic>.from(entry.value as Map);
      if (data[NotificationDto.isReadKey] == false) {
        return _notifications.child(entry.key).update({
          NotificationDto.isReadKey: true,
        });
      }
      return Future.value();
    });

    await Future.wait(futures);
  }
}
