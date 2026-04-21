import 'package:velo_toulose/core/enum/pass_type.dart';
import 'package:velo_toulose/models/pass.dart';

class PassDto {
  static const String userIdKey = 'userId'; // FIX #8: added
  static const String typeKey = 'type';
  static const String startDateKey = 'startDate';
  static const String endDateKey = 'endDate';
  static const String priceKey = 'price';
  static const String isActiveKey = 'isActive';

  static Pass fromJson(String id, Map<String, dynamic> json) {
    return Pass(
      passId: id,
      userId:
          json[userIdKey] as String? ??
          '', // graceful fallback for legacy records
      type: PassType.fromString(json[typeKey] as String),
      startDate: DateTime.parse(json[startDateKey] as String),
      endDate: DateTime.parse(json[endDateKey] as String),
      price: (json[priceKey] as num).toDouble(),
      isActive: json[isActiveKey] as bool,
    );
  }

  static Map<String, dynamic> toJson(Pass pass) {
    return {
      userIdKey: pass.userId,
      typeKey: pass.type.toJson(),
      startDateKey: pass.startDate.toIso8601String(),
      endDateKey: pass.endDate.toIso8601String(),
      priceKey: pass.price,
      isActiveKey: pass.isActive,
    };
  }
}
