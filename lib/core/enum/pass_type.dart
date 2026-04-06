enum PassType {
  payAsYouGo,
  daily,
  weekly,
  annual;

  static PassType fromString(String value) {
    return PassType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => PassType.payAsYouGo,
    );
  }

  String toJson() => name;
}
