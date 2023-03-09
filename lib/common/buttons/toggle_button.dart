import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/buttons/linx_toggle_buttons.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/utils/ui_extensions.dart';

class ToggleButton extends ConsumerWidget {
  final double _doubleWidthPadding = 58.0;
  final String label;
  final int index;
  final double _buttonRadius = 8.0;
  final double _buttonMinHeight = 10.0;
  final TextStyle _selectedTextStyle = const TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    color: LinxColors.backButtonGrey,
  );
  final TextStyle _unselectedTextStyle = const TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    color: LinxColors.backButtonGrey,
  );
  final Border _selectedBorder = const Border.fromBorderSide(
    BorderSide(color: LinxColors.black_4),
  );

  const ToggleButton({
    super.key,
    required this.label,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double buttonMinWidth = (context.width() - _doubleWidthPadding) / 2;
    bool isSelected = ref.watch(toggleButtonIndexSelectedProvider) == index;

    TextStyle style = isSelected ? _selectedTextStyle : _unselectedTextStyle;
    Color backgroundColor = isSelected ? LinxColors.white : LinxColors.transparent;
    BoxBorder? border = isSelected ? _selectedBorder : null;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        borderRadius: BorderRadius.all(Radius.circular(_buttonRadius)),
      ),
      constraints: BoxConstraints(
        minHeight: _buttonMinHeight,
        minWidth: buttonMinWidth,
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );
  }
}
