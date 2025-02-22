import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saving/features/account/pages/account_page.dart';
import 'package:saving/features/auth/auth_page.dart';
import 'package:saving/features/bottom_navigation_shell.dart';
import 'package:saving/features/card/pages/card_detail.dart';
import 'package:saving/features/card/pages/card_page.dart';
import 'package:saving/features/home/pages/add_money_page.dart';
import 'package:saving/features/home/pages/home_page.dart';
import 'package:saving/features/home/pages/transaction_listing_page.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: MyHomePage.route,
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: AuthPage.route,
        name: 'authPage',
        builder: (context, state) => const AuthPage(),
      ),
      StatefulShellRoute.indexedStack(
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: MyHomePage.route,
                name: 'homePage',
                builder: (context, state) => const MyHomePage(),
                routes: [
                  GoRoute(
                    path: AddMoneyPage.route,
                    name: 'addMoneyPage',
                    parentNavigatorKey: navigatorKey,
                    builder: (context, state) => const AddMoneyPage(),
                  ),
                  GoRoute(
                    path: TransactionListingPage.route,
                    name: 'transactionListingPage',
                    builder: (context, state) => const TransactionListingPage(),
                    parentNavigatorKey: navigatorKey,
                  )
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: CardPage.route,
                name: 'cardPage',
                builder: (context, state) => const CardPage(),
                routes: [
                  GoRoute(
                    path: '/:id',
                    name: 'cardDetail',
                    parentNavigatorKey: navigatorKey,
                    builder: (context, state) {
                      final id =
                          int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
                      return CardDetail(id);
                    },
                  )
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AccountPage.route,
                name: 'accountPage',
                builder: (context, state) => const AccountPage(),
              ),
            ],
          )
        ],
        builder: (context, state, navigationShell) {
          return BottomNavigationShell(navigationShell: navigationShell);
        },
      )
    ],
  );
});
