import 'package:hive_flutter/hive_flutter.dart';
import 'package:velo_toulose/dtos/notification_dto.dart';
import 'package:velo_toulose/models/notification.dart';
import 'package:velo_toulose/repositories/abstract/notification_repository.dart';

class NotificationRepositoryMock implements NotificationRepository {
  Box get _box => Hive.box('notifications_box');

  @override
  Future<List<AppNotification>> getNotificationsByUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _box.values
        .map((e) {
          final map = Map<String, dynamic>.from(e as Map);
          return NotificationDto.fromJson(map['notificationId'], map);
        })
        .where((n) => n.userId == userId)
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<void> saveNotification(AppNotification notification) async {
    await Future.delayed(const Duration(milliseconds: 100));
    await _box.put(
      notification.notificationId,
      NotificationDto.toJson(notification),
    );
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final raw = _box.get(notificationId);
    if (raw == null) return;
    final map = Map<String, dynamic>.from(raw as Map);
    final notification = NotificationDto.fromJson(notificationId, map);
    await _box.put(
      notificationId,
      NotificationDto.toJson(notification.markAsRead()),
    );
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    for (final key in _box.keys) {
      final raw = _box.get(key);
      if (raw == null) continue;
      final map = Map<String, dynamic>.from(raw as Map);
      if (map[NotificationDto.userIdKey] == userId &&
          map[NotificationDto.isReadKey] == false) {
        final notification = NotificationDto.fromJson(key as String, map);
        await _box.put(key, NotificationDto.toJson(notification.markAsRead()));
      }
    }
  }
}
