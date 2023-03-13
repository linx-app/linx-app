import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';

class ChatAddressBar extends StatelessWidget {
  final _prefixTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    color: LinxColors.locationTextGrey,
  );

  final _labelTextStyle = const TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: LinxColors.black,
  );

  final _border = const OutlineInputBorder(
      borderSide: BorderSide(color: LinxColors.stroke),
      borderRadius: BorderRadius.all(Radius.zero));

  final TextEditingController? controller;

  const ChatAddressBar({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: _border,
        focusedBorder: _border,
        prefixIcon: Container(
          padding: const EdgeInsets.only(left: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("To:", style: _prefixTextStyle)],
          ),
        ),
      ),
      style: _labelTextStyle,
      cursorColor: LinxColors.black,
      cursorWidth: 1,
      cursorHeight: 24,
      maxLines: 1,
    );
  }
}
