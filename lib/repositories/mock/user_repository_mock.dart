import 'package:velo_toulose/models/user.dart';
import 'package:velo_toulose/repositories/abstract/user_repository.dart';

class UserRepositoryMock implements UserRepository {
  // fake database of users
  final List<User> _users = [
    User(
      userId: 'u001',
      firstName: 'Pheng',
      lastName: 'Lyming',
      email: 'Lyming4999@gmail.com',
      phone: '012345678',
      password: '1234',
      image: Uri.parse(''),
      
    ),
  ];

  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final user = _users.where((u) => u.email == email).firstOrNull;

    if (user == null) {
      throw Exception('No account found with this email');
    }

    return user;
  }

  @override
  Future<User> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // check if email already exists
    final exists = _users.any((u) => u.email == email);
    if (exists) {
      throw Exception('An account with this email already exists');
    }

    final newUser = User(
      userId: 'u${_users.length + 1}',
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: '',
      password: password,
      image: Uri.parse(''),
    );

    _users.add(newUser);
    return newUser;
  }

  @override
  Future<User?> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _users.where((u) => u.userId == id).firstOrNull;
  }

  @override
  Future<void> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _users.indexWhere((u) => u.userId == user.userId);
    if (index != -1) {
      _users[index] = user;
    }
  }
}
