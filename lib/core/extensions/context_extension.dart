import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  Size get size => MediaQuery.of(this).size;
  double get width => size.width;
  double get height => size.height;

  void removeFocus() => FocusScope.of(this).unfocus();

  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  double get bottomPadding => MediaQuery.of(this).viewInsets.bottom;
}
