
class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String password;
  final String? passid;

  const User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.password,
    this.passid,
  });

  String get fullName => '$firstName $lastName';

  bool get hasActivPass => passid != null;

  User copyWith({
    String? userId,
    Uri? image,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? password,
    String? passid,
    bool clearPass = false,
  }) {
    return User(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      passid: clearPass ? null : passid ?? this.passid,
    );
  }
}
