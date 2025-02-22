import 'package:flutter/material.dart';

class FakeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FakeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Size get preferredSize => const Size.fromHeight(0.0);
}
