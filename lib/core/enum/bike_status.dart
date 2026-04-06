enum BikeStatus {
  available,
  inUse;

  static BikeStatus fromString(String value) {
    return BikeStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => BikeStatus.available,
    );
  }

  String toJson() => name;
}
