import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/chat/domain/model/message.dart';
import 'package:linx/features/user/domain/model/user_type.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final UserType currentUserType;
  final _senderTextStyle = const TextStyle(
    color: LinxColors.white,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );
  final _otherTextStyle = const TextStyle(
    color: LinxColors.black,
    fontSize: 15,
    fontWeight: FontWeight.w400,
  );

  const ChatBubble(
      {super.key, required this.message, required this.currentUserType});

  @override
  Widget build(BuildContext context) {
    final isSender = message.sentByUserType == currentUserType;
    final color =
        isSender ? LinxColors.messageBubbleGreen : LinxColors.messageBubbleGrey;
    return BubbleSpecialThree(
      isSender: isSender,
      text: message.content,
      color: color,
      textStyle: isSender ? _senderTextStyle : _otherTextStyle,
    );
  }
}
