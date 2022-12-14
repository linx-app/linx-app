import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';

TextTheme linxTextTheme() {
  return TextTheme(
    titleMedium: _title(),
    bodyMedium: _regular(),
  );
}

TextStyle _title() {
  return const TextStyle(
    color: LinxColors.black,
    fontWeight: FontWeight.w500,
    fontSize: 32.0,
  );
}

TextStyle _regular() {
  return const TextStyle(
    color: LinxColors.grey,
    fontWeight: FontWeight.w400,
    fontSize: 14.9,
  );
}