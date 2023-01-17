import 'package:flutter/material.dart';
import 'package:linx/constants/text.dart';

class LinxTextButton extends StatelessWidget {
  final String label;
  final IconData? iconData;
  final VoidCallback onPressed;
  final Color tint;
  final FontWeight? weight;

  const LinxTextButton({
    super.key,
    required this.label,
    this.iconData,
    required this.onPressed,
    required this.tint,
    this.weight,
  });

  @override
  Widget build(BuildContext context) {
    if (iconData != null) {
      return TextButton.icon(
        onPressed: onPressed,
        icon: _buildIcon(),
        label: _buildText(),
      );
    } else {
      return TextButton(
        onPressed: onPressed,
        child: _buildText(),
      );
    }
  }

  Icon _buildIcon() => Icon(iconData, color: tint);

  Text _buildText() => Text(label, style: _style());

  TextStyle _style() => LinxTextStyles.textButton(color: tint, weight: weight);
}
