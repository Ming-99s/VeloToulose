class User {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final double balance;

  const User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.balance,
  });

  String get fullName => '$firstName $lastName';

  User copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    double? balance,
  }) {
    return User(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      balance: balance ?? this.balance,
    );
  }
}
