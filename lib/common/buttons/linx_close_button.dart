import 'package:flutter/material.dart';

class LinxCloseButton extends StatelessWidget {
  final Color? color;
  final double? size;
  final VoidCallback? onXPressed;

  const LinxCloseButton({super.key, this.color, this.onXPressed, this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
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
