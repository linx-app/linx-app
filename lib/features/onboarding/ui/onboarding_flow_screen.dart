import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/buttons/linx_text_button.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/onboarding/presentation/onboarding_flow_controller.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_flow_router.dart';
import 'package:linx/utils/ui_extensions.dart';

class OnboardingFlowScreen extends OnboardingFlowRouter {
  final String initialRoute;

  OnboardingFlowScreen({required this.initialRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(onboardingControllerProvider);

    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0);

    return WillPopScope(
      onWillPop: () async {
        onBackPressed(context, ref);
        return false;
      },
      child: BaseScaffold(
        body: Column(
          children: [
            _buildOnboardingAppBar(context, ref, state.isStepRequired),
            _buildProgressIndicator(state),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _getStepCountText(context, padding, state),
                    IntrinsicHeight(
                      child: Navigator(
                        key: navigatorKey,
                        initialRoute: initialRoute,
                        onGenerateRoute: onGenerateRoute,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildNextFlowButton(padding, ref)
          ],
        ),
      ),
    );
  }

  SizedBox _buildOnboardingAppBar(
    BuildContext context,
    WidgetRef ref,
    bool isStepRequired,
  ) {
    return SizedBox(
      width: context.width(),
      height: 56.0,
      child: Material(
        elevation: 2.5,
        child: Row(children: [
          _buildBackButton(context, ref),
          if (!isStepRequired) _buildSkipButton(context)
        ]),
      ),
    );
  }

  LinearProgressIndicator _buildProgressIndicator(OnboardingFlowUiState state) {
    return LinearProgressIndicator(
      value: state.step * (1 / state.totalSteps),
      color: LinxColors.progressGrey,
      backgroundColor: LinxColors.transparent,
    );
  }

  Container _buildNextFlowButton(EdgeInsets padding, WidgetRef ref) {
    return Container(
      padding: padding,
      child: RoundedButton(
        style: greenButtonStyle(),
        onPressed: () => onNextPressed(ref),
        text: "Next",
      ),
    );
  }

  Container _buildBackButton(BuildContext context, WidgetRef ref) {
    return Container(
      alignment: Alignment.centerLeft,
      width: context.width() / 2,
      child: LinxTextButton(
        label: "Back",
        onPressed: () => onBackPressed(context, ref),
        iconData: Icons.chevron_left,
        tint: LinxColors.backButtonGrey,
      ),
    );
  }

  Container _buildSkipButton(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      width: context.width() / 2,
      child: LinxTextButton(
        label: "SKIP",
        onPressed: () => onSkipPressed(context),
        tint: LinxColors.backButtonGrey,
      ),
    );
  }

  Container _getStepCountText(
    BuildContext context,
    EdgeInsets padding,
    OnboardingFlowUiState state,
  ) {
    String text;

    if (state.isStepRequired) {
      text = "STEP ${state.step} OF ${state.totalSteps}";
    } else {
      text = "STEP ${state.step} OF ${state.totalSteps} (OPTIONAL)";
    }

    return Container(
      width: context.width(),
      padding: padding,
      child: Text(text,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: LinxColors.onboardingStepGrey,
          )),
    );
  }
}
