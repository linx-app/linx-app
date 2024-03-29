import 'package:flutter/material.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/constants/colors.dart';

const double buttonRadius = 50.0;

class RoundedButton extends StatelessWidget {
  final ButtonStyle style;
  final VoidCallback? onPressed;
  final String text;

  // ignore: use_key_in_widget_constructors
  const RoundedButton({
    required this.style,
    this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

ButtonStyle greenButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: LinxColors.green,
    foregroundColor: LinxColors.white,
    shape: RoundedBorder.all(buttonRadius),
    textStyle: LinxTextStyles.button(color: LinxColors.black),
    padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 29.0),
    minimumSize: const Size.fromHeight(40.0),
    shadowColor: Colors.transparent,
  );
}

ButtonStyle greyButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: LinxColors.buttonGrey,
    foregroundColor: LinxColors.black,
    shape: RoundedBorder.all(buttonRadius),
    textStyle: LinxTextStyles.button(color: LinxColors.green),
    padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 29.0),
    minimumSize: const Size.fromHeight(40.0),
    shadowColor: Colors.transparent,
  );
}
