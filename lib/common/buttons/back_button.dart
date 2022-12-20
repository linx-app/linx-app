import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/text.dart';

class LinxBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  final Icon backChevron = const Icon(
    Icons.chevron_left,
    color: LinxColors.backButtonGrey,
  );

  final Text backText = Text(
    "Back",
    style: LinxTextStyles.textButton(color: LinxColors.backButtonGrey),
  );

  LinxBackButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: backChevron,
      label: backText,
    );
  }
}
