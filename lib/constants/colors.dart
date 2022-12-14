import 'package:flutter/material.dart';

class LinxColors {
  static const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: LinxColors.background,
      onPrimary: LinxColors.black,
      secondary: LinxColors.green,
      onSecondary: LinxColors.white,
      error: Colors.redAccent,
      onError: LinxColors.white,
      background: LinxColors.background,
      onBackground: LinxColors.background,
      surface: LinxColors.white,
      onSurface: LinxColors.black,
      outline: LinxColors.stroke
  );

  static const Color background = Color(0xFFFCFCFC);
  static const Color green = Color(0xFF00AC8E);

  static const Color white = Colors.white;
  static const Color stroke = Color(0xFFDFDFDF);

  static const Color black = Colors.black;
  static const Color black_5 = Color(0x0D0000000);
  static const Color black_60 = Color(0x990000000);

  static const Color grey = Color(0xFF666666);
}