import 'package:flutter/material.dart';
import 'package:linx/common/buttons/linx_icon_button.dart';
import 'package:linx/common/linx_text_field.dart';

class MessageTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSendPressed;

  const MessageTextField({
    super.key,
    required this.controller,
    required this.onSendPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: LinxTextField(
        label: "Type a message...",
        controller: controller,
        suffixIcon: LinxIconButton(
          icon: Image.asset("assets/send_message.png", scale: 4),
          onPressed: onSendPressed,
        ),
        minLines: 1,
        maxLines: 3,
      ),
    );
  }
}
