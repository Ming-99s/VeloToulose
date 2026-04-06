enum PaymentType {
  unlockFee,
  overtimeFee,
  passPurchase;

  static PaymentType fromString(String value) {
    return PaymentType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PaymentType.unlockFee,
    );
  }

  String toJson() => name;
}
