import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/buttons/toggle_button.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/utils/ui_extensions.dart';

final toggleButtonListSelectedProvider = StateProvider((ref) {
  final indexSelected = ref.watch(toggleButtonIndexSelectedProvider);
  return indexSelected == 0 ? [true, false] : [false, true];
});

final toggleButtonIndexSelectedProvider = StateProvider((ref) => 0);

class LinxToggleButtons extends ConsumerWidget {
  final ToggleButton firstButton;
  final ToggleButton secondButton;
  final Function(int)? onNewTogglePressed;

  const LinxToggleButtons({
    super.key,
    required this.firstButton,
    required this.secondButton,
    this.onNewTogglePressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedList = ref.watch(toggleButtonListSelectedProvider);

    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: const BoxDecoration(
        color: LinxColors.black_5,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: ToggleButtons(
        fillColor: LinxColors.transparent,
        borderColor: LinxColors.transparent,
        selectedColor: LinxColors.transparent,
        selectedBorderColor: LinxColors.transparent,
        splashColor: LinxColors.transparent,
        isSelected: selectedList,
        constraints: BoxConstraints(
          minHeight: 10.0,
          minWidth: (context.width() - 58.0) / 2,
        ),
        onPressed: (int index) {
          if (selectedList[index] != true) {
            onNewTogglePressed?.call(index);
          }
          _onUserToggledPressed(index, ref);
        },
        children: [firstButton, secondButton],
      ),
    );
  }

  void _onUserToggledPressed(int index, WidgetRef ref) {
    ref.read(toggleButtonIndexSelectedProvider.notifier).state = index;
  }
}
