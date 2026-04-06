class AppNotification {
  final String notificationId;
  final String userId;
  final String type;
  final String message;
  final DateTime sentAt;
  final bool isRead;

  const AppNotification({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.message,
    required this.sentAt,
    this.isRead = false,
  });

  AppNotification markAsRead() {
    return copyWith(isRead: true);
  }

  AppNotification copyWith({
    String? notificationId,
    String? userId,
    String? type,
    String? message,
    DateTime? sentAt,
    bool? isRead,
  }) {
    return AppNotification(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      message: message ?? this.message,
      sentAt: sentAt ?? this.sentAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
