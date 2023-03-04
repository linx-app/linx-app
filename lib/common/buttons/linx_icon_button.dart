import 'package:flutter/material.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/constants/colors.dart';

class LinxIconButton extends StatelessWidget {
  final IconData? iconData;
  final Image? icon;
  final Size size;
  final VoidCallback onPressed;

  const LinxIconButton({
    super.key,
    this.iconData,
    this.icon,
    this.size = const Size(24, 24),
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (iconData == null && icon == null) return Empty();

    if (icon != null) {
      return SizedBox(
        height: size.height,
        width: size.width,
        child: InkWell(
          onTap: onPressed,
          child: Image.asset(
            "assets/sort.png",
            color: LinxColors.subtitleGrey,
          ),
        ),
      );
    } else {
      return IconButton(
        icon: Icon(iconData!),
        onPressed: onPressed,
      );
    }
  }
}
