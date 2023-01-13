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
import 'package:linx/features/onboarding/ui/onboarding_chip_selection_screen.dart';
import 'package:linx/features/onboarding/ui/onboarding_create_profile_screen.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';
import 'package:linx/utils/ui_extensions.dart';

class OnboardingFlow extends ConsumerWidget {
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

    return WillPopScope(
      onWillPop: () async {
        _onBackPressed(context, ref);
        return false;
      },
      child: BaseScaffold(
        body: Column(
          children: [
            _buildOnboardingAppBar(context, ref),
            _buildProgressIndicator(step, totalSteps),
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

  LinearProgressIndicator _buildProgressIndicator(int step, int totalSteps) {
    return LinearProgressIndicator(
      value: step * (1 / totalSteps),
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
      child: Text(text,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: LinxColors.onboardingStepGrey,
          )),
    );
  }

  void _onNextPressed(WidgetRef ref) async {
    var nextReady = currentScreen?.onNextPressed() == true;
    var nextReadyAsync = await currentScreen?.onNextPressedAsync() == true;
    if (nextReady || nextReadyAsync) {
      _controller.onNextPressed();
    }
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

  void _onBasicInfoComplete() {
    _navigatorKey.currentState?.pushNamed(routeOnboardingChipClubDescriptor);
  }

  void _onChipSelectionComplete() {
    _navigatorKey.currentState?.pushNamed(routeOnboardingCreateProfile);
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
        OnboardingBasicInfoScreen screen =
            OnboardingBasicInfoScreen(onScreenCompleted: _onBasicInfoComplete);
        currentScreen = screen;
        page = screen;
        break;
      case routeOnboardingChipClubDescriptor:
      case routeOnboardingChipClubInterest:
      case routeOnboardingChipBusinessInterest:
        ChipSelectionScreenType type =
            _getChipSelectionScreenTypeFromRoute(settings.name);
        OnboardingChipSelectionScreen screen = OnboardingChipSelectionScreen(
          type: type,
          onScreenCompleted: _onChipSelectionComplete,
        );
        currentScreen = screen;
        page = screen;
        break;
      case routeOnboardingCreateProfile:
        OnboardingCreateProfileScreen screen = OnboardingCreateProfileScreen();
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

  ChipSelectionScreenType _getChipSelectionScreenTypeFromRoute(String? route) {
    switch (route) {
      case routeOnboardingChipClubDescriptor:
        return ChipSelectionScreenType.clubDescriptors;
      case routeOnboardingChipClubInterest:
        return ChipSelectionScreenType.clubInterests;
      case routeOnboardingChipBusinessInterest:
        return ChipSelectionScreenType.businessInterests;
      default:
        throw Exception("Route not found in onboarding flow: $route");
    }
  }
}
