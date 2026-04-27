enum NotificationType {
  unlockFee,
  overtimeFee,
  passPurchase,
  rideReceipt;

  String toJson() => switch (this) {
    NotificationType.unlockFee => 'unlock_fee',
    NotificationType.overtimeFee => 'overtime_fee',
    NotificationType.passPurchase => 'pass_purchase',
    NotificationType.rideReceipt => 'ride_receipt',
  };

  static NotificationType fromString(String value) => switch (value) {
    'unlock_fee' => NotificationType.unlockFee,
    'overtime_fee' => NotificationType.overtimeFee,
    'pass_purchase' => NotificationType.passPurchase,
    'ride_receipt' => NotificationType.rideReceipt,
    _ => throw Exception('Unknown notification type: $value'),
  };
}
