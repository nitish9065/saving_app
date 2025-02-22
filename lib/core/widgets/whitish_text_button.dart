import 'package:flutter/material.dart';
import 'package:saving/core/theme/app_color.dart';

class WhitishTextButton extends StatelessWidget {
  const WhitishTextButton({
    super.key,
    this.onTap,
    required this.text,
  });
  final VoidCallback? onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: AppColor.whiteColor.withValues(
          alpha: 0.5,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColor.whiteColor),
      ),
    );
  }
}

class BlurIconButton extends StatelessWidget {
  const BlurIconButton({super.key, this.onTap, required this.iconData});
  final VoidCallback? onTap;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: AppColor.whiteColor.withValues(alpha: 0.5),
        padding: const EdgeInsets.all(4.0),
      ),
      icon: Icon(
        iconData,
        size: 28.0,
      ),
    );
  }
}
