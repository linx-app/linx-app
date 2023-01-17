import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/user/domain/model/user_type.dart';
import 'package:linx/utils/ui_extensions.dart';

final userTypeToggleStateProvider = StateProvider((ref) => UserType.club);

final userTypeToggleStateListProvider = Provider<List<bool>>((ref) {
  final userType = ref.watch(userTypeToggleStateProvider);
  if (userType == UserType.club) {
    return <bool>[true, false];
  } else {
    return <bool>[false, true];
  }
});

const double _doubleWidthPadding = 58.0;

class UserTypeToggleButton extends ConsumerWidget {
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

  const UserTypeToggleButton({
    super.key,
    required this.label,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double buttonMinWidth = (context.width() - _doubleWidthPadding) / 2;
    bool isSelected = ref.watch(userTypeToggleStateProvider).index == index;
    TextStyle style;
    Color backgroundColor;
    BoxBorder? border;

    if (isSelected) {
      style = _selectedTextStyle;
      backgroundColor = LinxColors.white;
      border = const Border.fromBorderSide(
        BorderSide(color: LinxColors.black_4),
      );
    } else {
      style = _unselectedTextStyle;
      backgroundColor = LinxColors.transparent;
    }

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
