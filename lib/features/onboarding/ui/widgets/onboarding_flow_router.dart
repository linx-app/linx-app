import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/constants/routes.dart';
import 'package:linx/features/authentication/domain/models/user_type.dart';
import 'package:linx/features/authentication/ui/signup_screen.dart';
import 'package:linx/features/onboarding/presentation/onboarding_flow_controller.dart';
import 'package:linx/features/onboarding/ui/onboarding_basic_info_screen.dart';
import 'package:linx/features/onboarding/ui/onboarding_chip_selection_screen.dart';
import 'package:linx/features/onboarding/ui/onboarding_create_profile_screen.dart';
import 'package:linx/features/onboarding/ui/onboarding_sponsorship_package_screen.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';

abstract class OnboardingFlowRouter extends ConsumerWidget {
  @protected
  UserType? _userType;

  @protected
  OnboardingView? _currentScreen;

  @protected
  final navigatorKey = GlobalKey<NavigatorState>();

  @protected
  Route onGenerateRoute(RouteSettings settings) {
    late Widget page;

    switch (settings.name) {
      case routeOnboardingSignUp:
        SignUpScreen screen =
        SignUpScreen(onSignUpCompleted: _onSignUpComplete);
        _currentScreen = screen;
        page = screen;
        break;
      case routeOnboardingBasicInfo:
        OnboardingBasicInfoScreen screen =
        OnboardingBasicInfoScreen(onScreenCompleted: _onBasicInfoComplete);
        _currentScreen = screen;
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
        _currentScreen = screen;
        page = screen;
        break;
      case routeOnboardingCreateProfile:
        OnboardingCreateProfileScreen screen =
        OnboardingCreateProfileScreen(_onCreateProfileComplete);
        _currentScreen = screen;
        page = screen;
        break;
      case routeOnboardingSponsorshipPackage:
        OnboardingSponsorshipPackageScreen screen =
        OnboardingSponsorshipPackageScreen();
        _currentScreen = screen;
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

  @protected
  void onNextPressed(WidgetRef ref) async {
    var nextReady = _currentScreen?.onNextPressed(ref) == true;
    var nextReadyAsync = await _currentScreen?.onNextPressedAsync(ref) == true;
    if (nextReady || nextReadyAsync) {
      var isStepRequired = _currentScreen?.isStepRequired ?? true;
      ref
          .read(onboardingControllerProvider.notifier)
          .onNextPressed(isStepRequired);
    }
  }

  @protected
  void onBackPressed(BuildContext context, WidgetRef ref) {
    _currentScreen?.onBackPressed();
    var state = ref.watch(onboardingControllerProvider);
    var notifier = ref.read(onboardingControllerProvider.notifier);
    if (state.step == 1) {
      Navigator.of(context).pop();
      notifier.reset();
    } else {
      navigatorKey.currentState?.pop();
      print(_currentScreen);
      var isStepRequired = _currentScreen?.isStepRequired ?? true;
      notifier.onBackPressed(isStepRequired);
    }
  }

  @protected
  void onSkipPressed(BuildContext context) {

  }

  void _onSignUpComplete(UserType type) {
    _userType = type;
    navigatorKey.currentState?.pushNamed(routeOnboardingBasicInfo);
  }

  void _onBasicInfoComplete() {
    if (_userType == null) return;
    var route = _userType == UserType.club
        ? routeOnboardingChipClubDescriptor
        : routeOnboardingCreateProfile;
    navigatorKey.currentState?.pushNamed(route);
  }

  void _onChipSelectionComplete() {
    if (_userType == null) return;
    var route = _userType == UserType.club
        ? routeOnboardingCreateProfile
        : routeOnboardingSponsorshipPackage;
    navigatorKey.currentState?.pushNamed(route);
  }

  void _onCreateProfileComplete() {
    if (_userType == null) return;
    var route = _userType == UserType.club
        ? routeOnboardingSponsorshipPackage
        : routeOnboardingChipBusinessInterest;
    navigatorKey.currentState?.pushNamed(route);
  }

  void _onSponsorshipPackageComplete() {
    navigatorKey.currentState?.pushNamed(routeOnboardingReviewProfile);
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