import 'dart:math';

class IdGenerator {
  static final _rng = Random.secure();

  static int _shortId() => 10 + _rng.nextInt(9990); // 10 – 9999

  static String ride() => 'ride_${_shortId()}';
  static String payment() => 'pay_${_shortId()}';
  static String notification() => 'notif_${_shortId()}';
  static String pass(String type) => 'pass_${type}_${_shortId()}';
  static String station() => 'station_${_shortId()}';
  static String slot() => 'slot_${_shortId()}';
  static String bike() => 'bike_${_shortId()}';
}
