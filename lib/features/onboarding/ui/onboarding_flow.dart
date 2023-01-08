import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/buttons/back_button.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/routes.dart';
import 'package:linx/features/authentication/ui/signup_screen.dart';
import 'package:linx/features/onboarding/presentation/onboarding_flow_controller.dart';
import 'package:linx/features/onboarding/ui/onboarding_basic_info_screen.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';
import 'package:linx/utils/ui_extensions.dart';

class OnboardingFlow extends ConsumerWidget {
  final double _stepWeight = 1 / 8;
  final TextStyle _onboardingStepTextStyle = const TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: LinxColors.onboardingStepGrey,
  );
  final _navigatorKey = GlobalKey<NavigatorState>();
  final String initialRoute;
  OnboardingView? currentScreen;

  OnboardingFlow({super.key, required this.initialRoute});

  late OnboardingController _controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _controller = ref.read(OnboardingController.provider);
    int step = ref.watch(_controller.stepProvider);
    int totalSteps = ref.watch(_controller.totalStepsProvider);
    bool isStepRequired = ref.watch(_controller.stepRequiredProvider);

    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0);

    return BaseScaffold(
      body: Column(
        children: [
          _buildOnboardingAppBar(context, ref),
          _buildProgressIndicator(step),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _getStepCountText(
                    context,
                    padding,
                    step,
                    totalSteps,
                    isStepRequired,
                  ),
                  IntrinsicHeight(
                    child: Navigator(
                      key: _navigatorKey,
                      initialRoute: initialRoute,
                      onGenerateRoute: _onGenerateRoute,
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildNextFlowButton(padding, ref)
        ],
      ),
    );
  }

  SizedBox _buildOnboardingAppBar(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: context.width(),
      height: 56.0,
      child: Material(
        elevation: 2.5,
        child: Row(children: [
          LinxBackButton(onPressed: () => _onBackPressed(context, ref))
        ]),
      ),
    );
  }

  LinearProgressIndicator _buildProgressIndicator(int step) {
    return LinearProgressIndicator(
      value: step * _stepWeight,
      color: LinxColors.progressGrey,
      backgroundColor: LinxColors.transparent,
    );
  }

  Container _buildNextFlowButton(EdgeInsets padding, WidgetRef ref) {
    return Container(
      padding: padding,
      child: RoundedButton(
        style: greenButtonStyle(),
        onPressed: () => _onNextPressed(ref),
        text: "Next",
      ),
    );
  }

  Container _getStepCountText(
    BuildContext context,
    EdgeInsets padding,
    int step,
    int totalSteps,
    bool isStepRequired,
  ) {
    String text =
        _controller.getStepCountText(step, totalSteps, isStepRequired);
    return Container(
      width: context.width(),
      padding: padding,
      child: Text(text, style: _onboardingStepTextStyle),
    );
  }

  void _onNextPressed(WidgetRef ref) {
    currentScreen?.onNextPressed();
    _controller.onNextPressed();
  }

  void _onBackPressed(BuildContext context, WidgetRef ref) {
    currentScreen?.onBackPressed();

    if (ref.read(_controller.stepProvider) == 1) {
      Navigator.of(context).pop();
      _controller.reset();
    } else {
      _navigatorKey.currentState?.pop();
      _controller.onBackPressed();
    }
  }

  void _onSignUpComplete() {
    _navigatorKey.currentState?.pushNamed(routeOnboardingBasicInfo);
  }

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;

    switch (settings.name) {
      case routeOnboardingSignUp:
        SignUpScreen screen =
            SignUpScreen(onScreenCompleted: _onSignUpComplete);
        currentScreen = screen;
        page = screen;
        break;
      case routeOnboardingBasicInfo:
        OnboardingBasicInfoScreen screen = OnboardingBasicInfoScreen();
        currentScreen = screen;
        page = screen;
        break;
    }

    return MaterialPageRoute(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }
}
