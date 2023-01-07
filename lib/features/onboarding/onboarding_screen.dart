import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/buttons/back_button.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/features/onboarding/onboarding_controller.dart';
import 'package:linx/features/onboarding/onboarding_view.dart';
import 'package:linx/utils/ui_extensions.dart';

class OnboardingScreen extends ConsumerWidget {
  final double _stepWeight = 1 / 8;
  final TextStyle _onboardingStepTextStyle = const TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      color: LinxColors.onboardingStepGrey);

  OnboardingScreen({super.key});

  late OnboardingController _controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _controller = ref.read(OnboardingController.provider);
    int step = ref.watch(_controller.stepProvider);
    int totalSteps = ref.watch(_controller.totalStepsProvider);
    bool isStepRequired = ref.watch(_controller.stepRequiredProvider);
    OnboardingView currentView = ref.watch(_controller.currentOnboardingView);

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
              child: Row(children: [
                LinxBackButton(onPressed: () => {onBackPressed(context, ref)})
              ]),
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
                    child: _getStepCount(
                      _controller.getStepCountText(
                        step,
                        totalSteps,
                        isStepRequired,
                      ),
                    ),
                  ),
                  Container(
                    width: context.width(),
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
                    child: _getStepTitle(currentView.pageTitle()),
                  ),
                  Container(
                    child: currentView,
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: padding,
            child: RoundedButton(
              style: greenButtonStyle(),
              onPressed: () => onNextPressed(ref),
              text: "Next",
            ),
          )
        ],
      ),
    );
  }

  Text _getStepTitle(String title) {
    return Text(title, style: LinxTextStyles.title);
  }

  Text _getStepCount(String stepCountText) {
    return Text(stepCountText, style: _onboardingStepTextStyle);
  }

  void onNextPressed(WidgetRef ref) {
    ref.read(_controller.currentOnboardingView).onNextPressed();
    _controller.onNextPressed();
  }

  void onBackPressed(BuildContext context, WidgetRef ref) {
    ref.read(_controller.currentOnboardingView).onBackPressed();
    Navigator.pop(context);
  }
}
