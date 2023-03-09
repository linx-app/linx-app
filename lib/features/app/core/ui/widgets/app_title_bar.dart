import 'package:flutter/material.dart';
import 'package:linx/common/buttons/linx_icon_button.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/utils/ui_extensions.dart';

class AppTitleBar extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final IconData? iconData;
  final Image? icon;
  final VoidCallback? onIconPressed;
  final EdgeInsets? padding;

  const AppTitleBar({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.onIconPressed,
    this.iconData,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                _buildSubtitle(),
              ],
            ),
          ),
          LinxIconButton(
            icon: icon,
            iconData: iconData,
            onPressed: () => onIconPressed?.call(),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    if (title == null) return Empty();
    return Text(title!, style: LinxTextStyles.title);
  }

  Widget _buildSubtitle() {
    if (subtitle == null) return Empty();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        subtitle!,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 17.0,
          color: LinxColors.subtitleGrey,
        ),
      ),
    );
  }
}
