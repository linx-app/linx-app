import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';

class ErrorSnackBar extends SnackBar {
  final String errorMessage;

  ErrorSnackBar({super.key, required this.errorMessage})
      : super(
          content: Text(errorMessage),
          backgroundColor: LinxColors.red,
        );
}
