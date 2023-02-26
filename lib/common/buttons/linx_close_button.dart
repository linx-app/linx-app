import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';

class LinxCloseButton extends StatelessWidget {
  final Color? color;
  final double? size;
  final VoidCallback? onXPressed;

  const LinxCloseButton({super.key, this.color, this.onXPressed, this.size});

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      color: LinxColors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () => onXPressed?.call(),
        splashColor: color,
        child: Icon(
          Icons.close,
          size: size,
          color: color,
        ),
      ),
    );
  }
}
