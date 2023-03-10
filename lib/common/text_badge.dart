import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';

class LinxTextBadge extends StatelessWidget {
  final String text;
  final Color fontColor;
  final Color backgroundColor;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? borderRadius;

  const LinxTextBadge({
    super.key,
    required this.text,
    required this.fontColor,
    required this.backgroundColor,
    this.fontWeight,
    this.fontSize,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 0)),
      ),
      padding: const EdgeInsets.all(6),
      child: Text(
        text,
        style: TextStyle(
          color: fontColor,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontSize: fontSize ?? 12.0, //?? means specifying the null value
        ),
      ),
    );
  }
}

LinxTextBadge newTextBadge = const LinxTextBadge(
  text: "NEW",
  fontColor: LinxColors.white,
  backgroundColor: LinxColors.green,
  fontSize: 10.5,
  fontWeight: FontWeight.w700,
  borderRadius: 87.5,
);
