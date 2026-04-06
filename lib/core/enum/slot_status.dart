enum SlotStatus {
  free,
  occupied,
  defective;

  static SlotStatus fromString(String value) {
    return SlotStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SlotStatus.free,
    );
  }

  String toJson() => name;
}
