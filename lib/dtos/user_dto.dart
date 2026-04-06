
import 'package:velo_toulose/models/user.dart';

class UserDto {
  static const String firstNameKey = 'firstName';
  static const String lastNameKey = 'lastName';
  static const String emailKey = 'email';
  static const String phoneKey = 'phone';
  static const String balanceKey = 'balance';

  static User fromJson(String id, Map<String, dynamic> json) {
    assert(json[firstNameKey] is String);
    assert(json[lastNameKey] is String);
    assert(json[emailKey] is String);
    assert(json[phoneKey] is String);
    assert(json[balanceKey] is num);

    return User(
      userId: id,
      firstName: json[firstNameKey],
      lastName: json[lastNameKey],
      email: json[emailKey],
      phone: json[phoneKey],
      balance: (json[balanceKey] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson(User user) {
    return {
      firstNameKey: user.firstName,
      lastNameKey: user.lastName,
      emailKey: user.email,
      phoneKey: user.phone,
      balanceKey: user.balance,
    };
  }
}
