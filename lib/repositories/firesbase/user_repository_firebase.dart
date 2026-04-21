import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:velo_toulose/dtos/user_dto.dart';
import 'package:velo_toulose/models/user.dart';
import 'package:velo_toulose/repositories/abstract/user_repository.dart';

class UserRepositoryFirebase implements UserRepository {
  final fb_auth.FirebaseAuth _auth;
  final FirebaseDatabase _db;

  UserRepositoryFirebase({fb_auth.FirebaseAuth? auth, FirebaseDatabase? db})
    : _auth = auth ?? fb_auth.FirebaseAuth.instance,
      _db = db ?? FirebaseDatabase.instance;

  DatabaseReference get _users => _db.ref('users');

  @override
  Future<User> login(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;
    final snapshot = await _users.child(uid).get();

    if (!snapshot.exists) {
      throw Exception('User profile not found in database');
    }

    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return UserDto.fromJson(uid, data);
  }

  @override
  Future<User> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user!.uid;

    final newUser = User(
      userId: uid,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: '',
      password: '', // never store plain password — Auth handles it
    );

    await _users.child(uid).set(UserDto.toJson(newUser));

    return newUser;
  }

  @override
  Future<User?> getUserById(String id) async {
    final snapshot = await _users.child(id).get();
    if (!snapshot.exists) return null;
    final data = Map<String, dynamic>.from(snapshot.value as Map);
    return UserDto.fromJson(id, data);
  }

  @override
  Future<void> updateUser(User user) async {
    await _users.child(user.userId).update(UserDto.toJson(user));
  }
}
