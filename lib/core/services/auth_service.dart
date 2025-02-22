import 'package:saving/core/models/user.dart';

abstract class AuthService {
  Future<bool> createAccount({
    required String name,
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>> login(
      {required String email, required String password});

  Future<User?> currentUser({required String token});
}
