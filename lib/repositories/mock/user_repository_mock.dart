import 'package:hive_flutter/hive_flutter.dart';
import 'package:velo_toulose/core/utils/id_generator.dart';
import 'package:velo_toulose/dtos/user_dto.dart';
import 'package:velo_toulose/models/user.dart';
import 'package:velo_toulose/repositories/abstract/user_repository.dart';

class UserRepositoryMock implements UserRepository {
  static const _boxName = 'users_box';

  // Always safe since box is opened in main() before this is used
  Box get _box => Hive.box(_boxName);

  List<User> get _users {
    return _box.values.map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      return UserDto.fromJson(map['userId'], map);
    }).toList();
  }

  Future<void> _saveUser(User user) async {
    await _box.put(user.userId, {
      'userId': user.userId,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'password': user.password,
    });
  }

  @override
  Future<User> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800));
    final user = _users.where((u) => u.email == email).firstOrNull;
    if (user == null) throw Exception('No account found with this email');
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
    final exists = _users.any((u) => u.email == email);
    if (exists) throw Exception('An account with this email already exists');
    final newUser = User(
      userId: IdGenerator.user(),
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
    await _saveUser(newUser);
    return newUser;
  }

  @override
  Future<User?> getUserById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final raw = _box.get(id);
    if (raw == null) return null;
    final map = Map<String, dynamic>.from(raw as Map);
    return UserDto.fromJson(map['userId'], map);
  }

  @override
  Future<void> updateUser(User user) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (_box.containsKey(user.userId)) await _saveUser(user);
  }
}
