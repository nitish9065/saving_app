import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:saving/core/models/user.dart';
import 'package:saving/core/providers/auth_state_provider.dart';
import 'package:saving/core/state/auth_state.dart';
import 'package:saving/features/auth/provider/sign_up_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_service_provider.dart';

part 'sign_up_provider.g.dart';

@riverpod
class SignUp extends _$SignUp {
  @override
  SignUpState build() {
    return SignUpInitialState();
  }

  Future<void> createAccount(String email, String name, String password) async {
    try {
      state = SignUpLoadingState();
      await Future.delayed(const Duration(seconds: 2));
      final isSuccess = await ref
          .read(authServiceProvider)
          .createAccount(email: email, password: password, name: name);
      log('frpm provider is sign up success $isSuccess');
      if (isSuccess) {
        await login(email, password);
      }
      return;
    } catch (error) {
      state = SignUpErrorState(error.toString());
      return;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      state = SignUpLoadingState();
      await Future.delayed(const Duration(seconds: 2));
      final data = await ref
          .read(authServiceProvider)
          .login(email: email, password: password);
      await _onAuthSuccess(data);
    } catch (e) {
      state = SignUpErrorState(e.toString());
      return;
    }
  }

  Future<void> _onAuthSuccess(Map<String, dynamic> json) async {
    final String hashToken = json['token'];
    final user = User.fromJson(json['user'] as Map<String, dynamic>);

    var box = await Hive.openBox<String>('credentials');
    if (!box.containsKey('token')) {
      box.put('token', hashToken);
    }
    ref.read(authStateProvider.notifier).updateState(AuthStateSuccess(user));
  }
}
