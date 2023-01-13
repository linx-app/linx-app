import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';

class LinxTextField extends StatelessWidget {
  final String label;
  final double _textFieldCornerRadius = 8.0;
  final double _textFieldInputPadding = 10.0;
  final double _textSize = 17.0;
  final int? minLines;
  final int? maxLines;
  final Widget? icon;
  final bool shouldObscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const LinxTextField({
    super.key,
    required this.label,
    required this.controller,
    this.icon,
    this.shouldObscureText = false,
    this.validator,
    this.minLines,
    this.maxLines
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: icon,
        hintText: label,
        hintStyle: _hintTextStyle(),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: LinxColors.transparent),
          borderRadius:
              BorderRadius.all(Radius.circular(_textFieldCornerRadius)),
        ),
        focusColor: LinxColors.black_5,
        fillColor: LinxColors.black_5,
        filled: true,
        contentPadding: EdgeInsets.all(_textFieldInputPadding),
      ),
      showCursor: true,
      cursorColor: LinxColors.grey,
      style: _inputTextStyle(),
      obscureText: shouldObscureText,
      minLines: minLines,
      maxLines: maxLines,
    );
  }

  TextStyle _hintTextStyle() => TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: _textSize,
        color: LinxColors.black_60,
      );

  TextStyle _inputTextStyle() => TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: _textSize,
        color: LinxColors.black_80, // Todo: consult color with Kiera
      );
}
