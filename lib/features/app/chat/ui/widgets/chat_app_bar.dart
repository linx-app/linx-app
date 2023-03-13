import 'package:flutter/material.dart';
import 'package:linx/common/buttons/linx_back_button.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/common/separator_line.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/utils/ui_extensions.dart';

class ChatAppBar extends StatelessWidget {
  final _titleStyle = const TextStyle(
    color: LinxColors.black,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  final String title;

  const ChatAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width(),
      height: context.height() * 0.1,
      child: Material(
        elevation: 1,
        child: Stack(
          children: [
            _buildBackButton(context),
            Container(
              padding: const EdgeInsets.only(bottom: 12),
              alignment: Alignment.bottomCenter,
              child: _buildTitle(),
            ),
            const SeparatorLine(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      width: context.width() / 2,
      child: LinxBackButton(onPressed: () => Navigator.of(context).maybePop()),
    );
  }


  Widget _buildTitle() {
    if (title.isNotEmpty) {
      return Text(title, style: _titleStyle);
    } else {
      return Empty();
    }
  }
}
