import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:saving/core/providers/auth_state_provider.dart';
import 'package:saving/core/state/auth_state.dart';
import 'package:saving/core/theme/app_color.dart';

class BottomNavigationShell extends StatelessWidget {
  const BottomNavigationShell({
    super.key,
    required this.navigationShell,
  });
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        selectedIconTheme: IconThemeData(color: AppColor.primary, size: 24),
        selectedFontSize: 14.0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColor.primary,
        onTap: (value) {
          navigationShell.goBranch(
            value,
            initialLocation: value == navigationShell.currentIndex,
          );
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.credit_card_outlined),
            activeIcon: Icon(Icons.credit_card_rounded),
            label: 'Cards',
          ),
          BottomNavigationBarItem(
            icon: Consumer(
              builder: (context, ref, child) {
                final appState = ref.watch(authStateProvider);
                if (appState is AuthStateSuccess) {
                  final imageUrl = appState.user.profileUrl;
                  return CircleAvatar(
                    radius: 18.0,
                    backgroundColor: AppColor.grey,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColor.blackColor,
                      foregroundImage: NetworkImage(imageUrl),
                    ),
                  );
                }
                return const CircleAvatar(
                  radius: 14.0,
                  child: Icon(Icons.person),
                );
              },
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
