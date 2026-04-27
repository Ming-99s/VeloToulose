import 'package:velo_toulose/core/enum/notification_type.dart';
import 'package:velo_toulose/models/notification.dart';

class NotificationDto {
  static const String notificationIdKey = 'notificationId';
  static const String userIdKey = 'userId';
  static const String typeKey = 'type';
  static const String messageKey = 'message';
  static const String sentAtKey = 'sentAt';
  static const String isReadKey = 'isRead';
  static const String rideIdKey = 'rideId';
  static const String paymentIdKey = 'paymentId';

  static AppNotification fromJson(String id, Map<String, dynamic> json) {
    assert(json[notificationIdKey] is String);
    assert(json[userIdKey] is String);
    assert(json[typeKey] is String);
    assert(json[messageKey] is String);
    assert(json[sentAtKey] is String);
    assert(json[isReadKey] is bool);
    return AppNotification(
      notificationId: id,
      userId: json[userIdKey] as String,
      type: NotificationType.fromString(json[typeKey] as String),
      message: json[messageKey] as String,
      sentAt: DateTime.parse(json[sentAtKey] as String),
      isRead: json[isReadKey] as bool,
      rideId: json[rideIdKey] as String?,
      paymentId: json[paymentIdKey] as String?,
    );
  }

  static Map<String, dynamic> toJson(AppNotification notification) {
    return {
      notificationIdKey: notification.notificationId,
      userIdKey: notification.userId,
      typeKey: notification.type.toJson(),
      messageKey: notification.message,
      sentAtKey: notification.sentAt.toIso8601String(),
      isReadKey: notification.isRead,
      rideIdKey: notification.rideId,
      paymentIdKey: notification.paymentId,
    };
  }
}
