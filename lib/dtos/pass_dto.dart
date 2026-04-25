import 'package:velo_toulose/core/enum/pass_type.dart';
import 'package:velo_toulose/models/pass.dart';

class PassDto {
  static const String passIdKey = 'passId';
  static const String typeKey = 'type';
  static const String userIdKey = 'userId';
  static const String startDateKey = 'startDate';
  static const String endDateKey = 'endDate';
  static const String priceKey = 'price';
  static const String isActiveKey = 'isActive';

  static Pass fromJson(String id, Map<String, dynamic> json) {
    assert(json[typeKey] is String);
    assert(json[userIdKey] is String);
    assert(json[startDateKey] is String);
    assert(json[endDateKey] is String);
    assert(json[priceKey] is num);
    assert(json[isActiveKey] is bool);
    return Pass(
      passId: id,
      userId: json[userIdKey],
      type: PassType.fromString(json[typeKey]),
      startDate: DateTime.parse(json[startDateKey]),
      endDate: DateTime.parse(json[endDateKey]),
      price: (json[priceKey] as num).toDouble(),
      isActive: json[isActiveKey],
    );
  }

  Map<String, dynamic> toJson(Pass pass) {
    return {
      passIdKey: pass.passId,
      userIdKey: pass.userId,
      typeKey: pass.type.toJson(),
      startDateKey: pass.startDate.toIso8601String(),
      endDateKey: pass.endDate.toIso8601String(),
      priceKey: pass.price,
      isActiveKey: pass.isActive,
    };
  }
}
