import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';

class LinxTextField extends StatelessWidget {
  final String label;
  final double _textFieldInputPadding = 10.0;
  final double _textSize = 17.0;
  final double _helperTextSize = 12.0;
  final int? minLines;
  final int? maxLines;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool shouldObscureText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? errorText;

  final borderRadius = const BorderRadius.all(Radius.circular(8.0));

  const LinxTextField({
    super.key,
    required this.label,
    required this.controller,
    this.suffixIcon,
    this.shouldObscureText = false,
    this.validator,
    this.minLines,
    this.maxLines,
    this.errorText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        prefixIconColor: LinxColors.grey,
        hintText: label,
        hintStyle: _inputTextStyle(LinxColors.black_60),
        enabledBorder: _border(LinxColors.transparent),
        focusColor: LinxColors.black_5,
        focusedBorder: _border(LinxColors.black_80),
        fillColor: LinxColors.black_5,
        filled: true,
        contentPadding: EdgeInsets.all(_textFieldInputPadding),
        errorText: errorText,
        errorBorder: _border(LinxColors.red),
        focusedErrorBorder: _border(LinxColors.red),
        errorStyle: _errorTextStyle(),
        errorMaxLines: 3,
      ),
      showCursor: true,
      cursorColor: LinxColors.grey,
      style: _inputTextStyle(LinxColors.black_80),
      obscureText: shouldObscureText,
      minLines: minLines,
      maxLines: maxLines,
    );
  }

  OutlineInputBorder _border(Color color) =>
      OutlineInputBorder(
        borderSide: BorderSide(color: color),
        borderRadius: borderRadius,
      );

  TextStyle _errorTextStyle() =>
      TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: _helperTextSize,
        color: LinxColors.red,
      );

  TextStyle _inputTextStyle(Color color) =>
      TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: _textSize,
        color: color,
      );
}
