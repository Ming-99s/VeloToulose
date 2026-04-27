import 'package:velo_toulose/core/enum/notification_type.dart';

class AppNotification {
  final String notificationId;
  final String userId;
  final NotificationType type;
  final String message;
  final DateTime sentAt;
  final bool isRead;
  final String? rideId;
  final String? paymentId; 

  const AppNotification({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.message,
    required this.sentAt,
    this.isRead = false,
    this.rideId,
    this.paymentId,
  });

  AppNotification markAsRead() => copyWith(isRead: true);

  AppNotification copyWith({
    String? notificationId,
    String? userId,
    NotificationType? type,
    String? message,
    DateTime? sentAt,
    bool? isRead,
    String? rideId,
    String? paymentId,
  }) {
    return AppNotification(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      message: message ?? this.message,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
      rideId: rideId ?? this.rideId,
      paymentId: paymentId ?? this.paymentId,
    );
  }
}
