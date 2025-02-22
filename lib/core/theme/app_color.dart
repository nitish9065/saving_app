import 'package:flutter/material.dart';

class AppColor {
  const AppColor._();

  static const Color blackColor = Colors.black;
  static const Color blackColorFaded = Colors.black54;
  static const Color whiteColor = Colors.white;
  static const Color borderColor = Color.fromRGBO(200, 200, 200, 1);

  /// Color: #FF808080
  static const Color grey = Color(0xFF808080);
  static Color primary = const Color(0xFF005CEE).withValues(alpha: 0.95);
  static Color primaryFaded = primary.withValues(alpha: 0.7);

  /// Color: #FFD3D3D3
  static const Color lightBg = Color(0xFFD3D3D3);
  static const Color redColor = Color(0xFFF67952);
  static const Color yellowColor = Color.fromARGB(255, 243, 251, 1);
  static const Color transparent = Colors.transparent;

  static const Color green = Color.fromARGB(255, 0, 135, 5);
}
