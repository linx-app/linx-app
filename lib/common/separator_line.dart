import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/utils/ui_extensions.dart';

class SeparatorLine extends StatelessWidget {
  final Color? color;

  const SeparatorLine({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      width: context.width(),
      height: 1,
      color: color ?? LinxColors.stroke,
    );
  }

}