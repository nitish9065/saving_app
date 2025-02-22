import 'package:animations/animations.dart';
import 'package:saving/features/auth/provider/auth_page_provider.dart';
import 'package:saving/features/auth/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pages/login_page.dart';

class AuthPage extends ConsumerWidget {
  static String get route => '/auth';

  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showLogin = ref.watch(authPageProvider);
    return PageTransitionSwitcher(
      reverse: showLogin,
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
        return SharedAxisTransition(
          animation: primaryAnimation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
      child: showLogin ? const LoginPage() : const SignupPage(),
    );
  }
}
