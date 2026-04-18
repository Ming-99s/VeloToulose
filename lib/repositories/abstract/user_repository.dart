import 'package:velo_toulose/models/user.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<User> register(
    String firstName,
    String lastName,
    String email,
    String password,
  );
  Future<User?> getUserById(String id);
  Future<void> updateUser(User user);
}
