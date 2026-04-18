import 'package:velo_toulose/core/enum/pass_type.dart';
import 'package:velo_toulose/models/pass.dart';

class User {
  final String userId;
  final Uri image;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final Pass? pass; 

  const User({
    required this.userId,
    required this.image,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    this.pass, 
  });

  String get fullName => '$firstName $lastName';

  bool get hasImage => image.toString().isNotEmpty;

  bool get hasActivPass => pass != null && pass!.isValid();

  PassType get planStatus => pass != null ? pass!.type : PassType.payAsYouGo;

  User copyWith({
    String? userId,
    Uri? image,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? password,
    double? balance,
    Pass? pass,
    bool clearPass = false,
  }) {
    return User(
      userId: userId ?? this.userId,
      image: image ?? this.image,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      pass: clearPass ? null : pass ?? this.pass,
    );
  }
}
