import 'package:bcrypt/bcrypt.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saving/core/services/auth_service.dart';
import 'package:saving/core/exceptions/api_exception.dart';
import 'package:saving/core/exceptions/app_exception.dart';
import 'package:saving/core/models/user.dart';
import 'package:uuid/v1.dart';

class AuthServiceImpl implements AuthService {
  final Box<User> userBox;

  final String _salt;

  AuthServiceImpl({required this.userBox}) : _salt = BCrypt.gensalt();
  @override
  Future<bool> createAccount(
      {required String name,
      required String email,
      required String password}) async {
    try {
      var user = userBox.get(email);
      if (user != null) {
        throw AppException(
          message: 'Account already exist, please login!',
        );
      }
      final hashedPassword = BCrypt.hashpw(password, _salt);
      user = User(
        id: const UuidV1().toString(),
        name: name,
        profileUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Unknown_person.jpg/542px-Unknown_person.jpg',
        email: email,
        password: hashedPassword,
      );
      await userBox.put(email, user);
      return true;
    } catch (e) {
      throw ApiExcepion.onError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> login(
      {required String email, required String password}) async {
    try {
      var user = userBox.get(email);
      if (user == null) {
        throw AppException(
          message: 'User not found, please create one!',
        );
      }
      final hashedPw = BCrypt.hashpw(password, _salt);
      final isMatching = BCrypt.checkpw(password, hashedPw);
      if (!isMatching) {
        throw AppException(message: 'Invalid credentials!');
      }
      return {'token': email, 'user': user.toJson()};
    } catch (e) {
      throw ApiExcepion.onError(e);
    }
  }

  @override
  Future<User?> currentUser({required String token}) async {
    try {
      var user = userBox.get(token);
      return user;
    } catch (e) {
      throw ApiExcepion.onError(e);
    }
  }
}
