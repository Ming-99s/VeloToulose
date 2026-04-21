/// Uses the last 4 hex chars of the current millisecond timestamp.
class IdGenerator {
  static String _hex4() =>
      DateTime.now().millisecondsSinceEpoch.toRadixString(16).substring(9);

  static String ride() => 'ride_${_hex4()}';
  static String payment() => 'pay_${_hex4()}';
  static String notification() => 'notif_${_hex4()}';
  static String pass(String type) => 'pass_${type}_${_hex4()}';
}
