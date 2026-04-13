enum SlotStatus {
  free,
  occupied;

  static SlotStatus fromString(String value) {
    return SlotStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SlotStatus.free,
    );
  }

  String toJson() => name;
}
