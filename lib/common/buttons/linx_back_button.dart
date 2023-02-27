import 'package:flutter/material.dart';
import 'package:linx/common/buttons/linx_text_button.dart';
import 'package:linx/constants/colors.dart';

class LinxBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LinxBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return LinxTextButton(
      label: "Back",
      onPressed: onPressed,
      iconData: Icons.chevron_left,
      tint: LinxColors.backButtonGrey,
    );
  }
}