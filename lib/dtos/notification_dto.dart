import 'package:velo_toulose/models/notification.dart';

class NotificationDto {
  static const String userIdKey = 'userId';
  static const String typeKey = 'type';
  static const String messageKey = 'message';
  static const String sentAtKey = 'sentAt';
  static const String isReadKey = 'isRead';

  static AppNotification fromJson(String id, Map<String, dynamic> json) {
    assert(json[userIdKey] is String);
    assert(json[typeKey] is String);
    assert(json[messageKey] is String);
    assert(json[sentAtKey] is String);
    assert(json[isReadKey] is bool);

    return AppNotification(
      notificationId: id,
      userId: json[userIdKey],
      type: json[typeKey],
      message: json[messageKey],
      sentAt: DateTime.parse(json[sentAtKey]),
      isRead: json[isReadKey],
    );
  }

  static Map<String, dynamic> toJson(AppNotification notification) {
    return {
      userIdKey: notification.userId,
      typeKey: notification.type,
      messageKey: notification.message,
      sentAtKey: notification.sentAt.toIso8601String(),
      isReadKey: notification.isRead,
    };
  }
}
