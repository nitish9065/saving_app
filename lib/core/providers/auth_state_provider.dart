import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:saving/core/models/user.dart';
import 'package:saving/core/state/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:saving/features/auth/provider/auth_service_provider.dart';

part 'auth_state_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  @override
  AppState build() {
    _init();
    return AuthStateInitial();
  }

  Future<void> _init() async {
    try {
      state = AuthStateBooting();
      await Future.delayed(const Duration(seconds: 2));
      var box = await Hive.openBox<String>('credentials');
      await Hive.openBox<User>('users');
      final hashedToken = box.get('token');
      log('hashed token is $hashedToken');
      if (hashedToken == null) {
        state = AuthStateGuest();
        return;
      }
      var user =
          await ref.read(authServiceProvider).currentUser(token: hashedToken);
      if (user == null) {
        state = AuthStateGuest();
        return;
      }
      state = AuthStateSuccess(user);
    } catch (e) {
      log('Error occuredw hile fetching user from box $e');
      state = AuthStateError('Failed to get user details.');
    }
  }

  void updateState(AppState appState) {
    state = appState;
  }

  Future<void> logout() async {
    try {
      var box = await Hive.openBox<String>('credentials');
      box.delete('token');
      state = AuthStateGuest();
    } catch (e) {
      log('error occured while logging out..');
    }
  }
}
