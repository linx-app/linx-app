import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/buttons/linx_text_button.dart';
import 'package:linx/common/linx_chip.dart';
import 'package:linx/constants/colors.dart';

class WidgetTestingScreen extends ConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var chipSelectionState = StateProvider((ref) => true);

    return BaseScaffold(
        body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Example usage:
                _widgetContainer(
                    LinxChip(
                        label: "LinxChip",
                        onChipSelected: (label) {
                          var currentState = ref.read(chipSelectionState);
                          ref
                              .read(chipSelectionState.notifier)
                              .state = !currentState;
                        },
                        isSelected: ref.read(chipSelectionState)
                    )
                ),
                _widgetContainer(
                    LinxTextButton(
                        label: "LinxTextButton",
                        onPressed: () {
                          _onAction(context, "LinxTextButton");
                        },
                        tint: LinxColors.green
                    )
                )
                // Insert widgets below
              ],
            )
        )
    );
  }

  Container _widgetContainer(Widget widget) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: widget,
    );
  }

  void _onAction(BuildContext context, String name) {
    var snackBar = SnackBar(content: Text("Something happened with $name!"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}