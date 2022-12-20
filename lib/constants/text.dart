import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';

abstract class LinxTextStyles {
  static const TextTheme theme = TextTheme(
    headlineMedium: title,
    titleMedium: subtitle,
    bodyMedium: regular,
  );

  static const TextStyle title = TextStyle(
    color: LinxColors.black,
    fontWeight: FontWeight.w500,
    fontSize: 32.0,
  );

  static const TextStyle subtitle = TextStyle(
    color: LinxColors.subtitleGrey,
    fontWeight: FontWeight.w600,
    fontSize: 24.0,
  );

  static const TextStyle regular = TextStyle(
    color: LinxColors.grey,
    fontWeight: FontWeight.w400,
    fontSize: 15.0,
  );

  static TextStyle button({required Color color}) => TextStyle(
    color: color,
    fontWeight: FontWeight.w600,
    fontSize: 15.0,
  );

  static TextStyle textButton({required Color color}) => TextStyle(
    color: color,
    fontWeight: FontWeight.w400,
    fontSize: 15.0
  );
}