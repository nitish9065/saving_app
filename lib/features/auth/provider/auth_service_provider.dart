import 'package:hive_flutter/hive_flutter.dart';
import 'package:saving/core/services/auth_service.dart';
import 'package:saving/core/models/user.dart';

import 'package:saving/features/auth/service/auth_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider.autoDispose<AuthService>(
  (ref) {
    return AuthServiceImpl(userBox: Hive.box<User>('users'));
  },
);
