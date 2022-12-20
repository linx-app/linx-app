import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/utils/ui_extensions.dart';

import 'buttons/back_button.dart';

final onboardingProgressStateProvider = StateProvider((ref) => 1);

class OnboardingScreen extends ConsumerWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onNextPressed;
  final Widget body;
  final bool isStepRequired;
  final double _stepWeight = 1 / 8;
  final String stepTitle;

  const OnboardingScreen({
    super.key,
    required this.stepTitle,
    required this.onBackPressed,
    required this.body,
    required this.onNextPressed,
    this.isStepRequired = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int step = ref.watch(onboardingProgressStateProvider);
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0);

    return BaseScaffold(
      body: Column(
        children: [
          SizedBox(
            width: context.width(),
            height: 56.0,
            child: Material(
              elevation: 2.5,
              child: Row(
                children: [
                  LinxBackButton(
                    onPressed: onBackPressed,
                  ),
                ],
              ),
            ),
          ),
          LinearProgressIndicator(
            value: step * _stepWeight,
            color: LinxColors.progressGrey,
            backgroundColor: LinxColors.transparent,
          ),
          Container(
            width: context.width(),
            padding: padding,
            child: _getStepCount(step: step),
          ),
          Container(
            width: context.width(),
            padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
            child: _getStepTitle(),
          ),
          Expanded(flex: 1, child: body),
          Container(
            padding: padding,
            child: RoundedButton(
              style: greenButtonStyle(),
              onPressed: onNextPressed,
              text: "Next",
            ),
          )
        ],
      ),
    );
  }

  Text _getStepTitle() {
    return Text(
      stepTitle,
      style: LinxTextStyles.title,
    );
  }

  Text _getStepCount({required int step}) {
    if (isStepRequired) {
      return Text(
        "STEP $step OF 7",
        style: LinxTextStyles.regular,
        textAlign: TextAlign.left,
      );
    } else {
      return Text(
        "STEP $step OF 7 (OPTIONAL)",
        style: LinxTextStyles.regular,
      );
    }
  }
}
