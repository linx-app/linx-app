import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/text.dart';

class LinxTextButton extends StatelessWidget {
  final String label;
  final IconData? iconData;
  final TextStyle style = LinxTextStyles.textButton(color: LinxColors.backButtonGrey);
  final VoidCallback onPressed;

  LinxTextButton({super.key, required this.label, this.iconData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    if (iconData != null) {
      return TextButton.icon(onPressed: onPressed, icon: _buildIcon(), label: _buildText(),);
    } else {
      return TextButton(onPressed: onPressed, child: _buildText(),);
    }
  }

  Icon _buildIcon() => Icon(iconData, color: LinxColors.backButtonGrey);
  Text _buildText() => Text(label, style: style);
}
