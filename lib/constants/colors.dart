import 'package:flutter/material.dart';

abstract class LinxColors {
  static const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: LinxColors.grey,
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
  static const Color black_4 = Color(0x0A000000);
  static const Color black_5 = Color(0x0D000000);
  static const Color black_8 = Color(0x14000000);
  static const Color black_30 = Color(0x4D000000);
  static const Color black_60 = Color(0x99000000);
  static const Color black_80 = Color(0xCC000000);

  static const Color grey = Color(0xFF666666);
  static const Color backButtonGrey = Color(0xFF262626);
  static const Color subtitleGrey = Color(0xFF333333);
  static const Color buttonGrey = Color(0xFFEAEAEA);
  static const Color progressGrey = Color(0xFF1C1C1C);
  static const Color onboardingStepGrey = Color(0xFFBDBDBD);

  static const Color chipTextGrey = Color(0xFF4F4F4F);
  static const Color chipBackground = Color(0xFFF1F1F1);
  static const Color locationTextGrey = Color(0xFF828282);

  static const Color editIconButtonGrey = Color(0xFF929292);

  static const Color transparent = Colors.transparent;

  static const Color red = Color(0xFFEB5757);

  static const Color grey6 = Color(0xFFF2F2F2);

  static const Color messageBubbleGrey = Color(0xFFDADADA);
  static const Color messageBubbleGreen = Color(0xFF29B38A);
}