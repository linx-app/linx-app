import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/utils/ui_extensions.dart';

class ChatUserSuggestionItem extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  final _style = const TextStyle(
    color: LinxColors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  const ChatUserSuggestionItem({
    super.key,
    required this.name,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Text(name, style: _style)),
          Container(
            width: context.width(),
            height: 1,
            color: LinxColors.stroke,
          )
        ],
      ),
    );
  }
}
