import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saving/core/extensions/context_extension.dart';
import 'package:saving/core/providers/auth_state_provider.dart';
import 'package:saving/core/providers/loader.dart';
import 'package:saving/core/state/auth_state.dart';
import 'package:saving/core/theme/app_color.dart';
import 'package:saving/core/widgets/app_constrained_scroll_view.dart';
import 'package:saving/core/widgets/app_scaffold.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  static String get route => '/account';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = (ref.read(authStateProvider) as AuthStateSuccess).user;
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          user.name,
        ),
      ),
      body: AppConstrainedScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          children: [
            Row(
              spacing: 32.0,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 38.0,
                  backgroundColor: AppColor.grey,
                  child: CircleAvatar(
                    radius: 36.0,
                    backgroundColor: AppColor.blackColor,
                    foregroundImage: NetworkImage(
                      user.profileUrl,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: context.textTheme.headlineSmall,
                    ),
                    Text(
                      user.email,
                      style: context.textTheme.bodyLarge,
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        ref.read(loaderProvider.notifier).showLoader();
                        await Future.delayed(const Duration(seconds: 2));
                        ref.read(authStateProvider.notifier).logout();
                        ref.read(loaderProvider.notifier).hideLoader();
                      },
                      label: const Text('Logout'),
                      icon: const Icon(
                        Icons.logout,
                        color: AppColor.whiteColor,
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
