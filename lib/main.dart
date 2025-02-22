import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:saving/core/extensions/context_extension.dart';
import 'package:saving/core/models/bank_card.dart';
import 'package:saving/core/models/transaction.dart';
import 'package:saving/core/providers/auth_state_provider.dart';
import 'package:saving/core/providers/loader.dart';
import 'package:saving/core/routes/router_provider.dart';
import 'package:saving/core/state/auth_state.dart';
import 'package:saving/core/theme/app_color.dart';
import 'package:saving/core/theme/app_theme.dart';
import 'package:saving/features/auth/auth_page.dart';

import 'core/models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<void> init() async {
  await Hive.initFlutter();
  Hive.registerAdapter(users());
  Hive.registerAdapter(cards());
  Hive.registerAdapter(transactions());
  await Hive.openBox<BankCard>('cards');
  await Hive.openBox<Transaction>('transactions');
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    if (authState is AuthStateSuccess) {
      final router = ref.watch(routerProvider);
      return MaterialApp.router(
        title: 'Stream',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        routerConfig: router,
        builder: (context, child) {
          return Stack(
            children: [
              child ?? Container(),
              Positioned.fill(
                child: Consumer(
                  builder: (context, ref, child) {
                    final loader = ref.watch(loaderProvider);
                    if (loader) {
                      return const Stack(
                        fit: StackFit.expand,
                        children: [
                          ModalBarrier(
                            color: AppColor.blackColorFaded,
                            dismissible: false,
                          ),
                          Align(
                            child: CircularProgressIndicator(
                              color: AppColor.whiteColor,
                            ),
                          )
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              )
            ],
          );
        },
      );
    }

    return MaterialApp(
      title: 'Stream',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appTheme,
      home: authState is AuthStateGuest ? const AuthPage() : const SplashPage(),
    );
  }
}

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    ref.listenManual(
      authStateProvider,
      (_, next) {
        log('user state changed : $next');
        if (next is AuthStateError) {
          context.showSnackBar(next.error);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SvgPicture.asset(
          'assets/images/splash-logo.svg',
          height: 150,
          width: double.infinity,
        ),
      ),
    );
  }
}
