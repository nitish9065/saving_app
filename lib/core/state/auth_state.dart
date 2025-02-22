import 'package:saving/core/models/user.dart';

sealed class AppState {}

class AuthStateInitial extends AppState {}

class AuthStateBooting extends AppState {}

class AuthStateGuest extends AppState {}

class AuthStateSuccess extends AppState {
  final User user;

  AuthStateSuccess(this.user);

  @override
  String toString() {
    return user.toString();
  }
}

class AuthStateError extends AppState {
  final String error;

  AuthStateError(this.error);
}
