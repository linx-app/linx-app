import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/buttons/back_button.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/features/authentication/domain/models/user_type.dart';
import 'package:linx/features/authentication/ui/signup_screen.dart';
import 'package:linx/utils/ui_extensions.dart';

final onboardingProgressStateProvider = StateProvider((ref) => 1);

class OnboardingScreen extends ConsumerWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onNextPressed;
  final Widget body;
  final bool isStepRequired;
  final double _stepWeight = 1 / 8;
  final String stepTitle;
  final TextStyle _onboardingStepTextStyle = const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      color: LinxColors.onboardingStepGrey);

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
    int totalSteps = getTotalSteps(ref.watch(userTypeToggleStateProvider));
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
              child: Row(children: [LinxBackButton(onPressed: onBackPressed)]),
            ),
          ),
          LinearProgressIndicator(
            value: step * _stepWeight,
            color: LinxColors.progressGrey,
            backgroundColor: LinxColors.transparent,
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: context.width(),
                    padding: padding,
                    child: _getStepCount(step: step, totalSteps: totalSteps),
                  ),
                  Container(
                    width: context.width(),
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
                    child: _getStepTitle(),
                  ),
                  body,
                ],
              ),
            ),
          ),
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

  int getTotalSteps(UserType type) {
    if (type == UserType.club) {
      return 7;
    } else {
      return 6;
    }
  }

  Text _getStepTitle() {
    return Text(
      stepTitle,
      style: LinxTextStyles.title,
    );
  }

  Text _getStepCount({required int step, required int totalSteps}) {
    if (isStepRequired) {
      return Text(
        "STEP $step OF $totalSteps",
        style: _onboardingStepTextStyle,
      );
    } else {
      return Text(
        "STEP $step OF $totalSteps (OPTIONAL)",
        style: _onboardingStepTextStyle,
      );
    }
  }
}
