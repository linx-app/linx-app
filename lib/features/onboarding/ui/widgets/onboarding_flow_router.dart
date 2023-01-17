import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/constants/routes.dart';
import 'package:linx/features/authentication/domain/models/user_type.dart';
import 'package:linx/features/authentication/ui/signup_screen.dart';
import 'package:linx/features/onboarding/presentation/onboarding_flow_controller.dart';
import 'package:linx/features/onboarding/ui/onboarding_basic_info_screen.dart';
import 'package:linx/features/onboarding/ui/onboarding_chip_selection_screen.dart';
import 'package:linx/features/onboarding/ui/onboarding_create_profile_screen.dart';
import 'package:linx/features/onboarding/ui/onboarding_review_profile_screen.dart';
import 'package:linx/features/onboarding/ui/onboarding_sponsorship_package_screen.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';
import 'package:linx/utils/linx_stack.dart';

abstract class OnboardingFlowRouter extends ConsumerWidget {
  UserType? _userType;
  final LinxStack<OnboardingView> _backstack = LinxStack();

  @protected
  final navigatorKey = GlobalKey<NavigatorState>();

  @protected
  Route onGenerateRoute(RouteSettings settings) {
    late Widget page;

    switch (settings.name) {
      /** Sign Up Screen **/
      case routeOnboardingSignUp:
        var screen = SignUpScreen(onSignUpCompleted: _onSignUpComplete);
        _backstack.push(screen);
        page = screen;
        break;
      /** Basic Info Screen **/
      case routeOnboardingBasicInfo:
        var screen = OnboardingBasicInfoScreen(onScreenCompleted: _onBasicInfoComplete);
        _backstack.push(screen);
        page = screen;
        break;
      /** Chip Selection Screens **/
      case routeOnboardingChipClubDescriptor:
      case routeOnboardingChipClubInterest:
      case routeOnboardingChipBusinessInterest:
        var type = _getChipSelectionScreenTypeFromRoute(settings.name);
        var screen = OnboardingChipSelectionScreen(
          type: type,
          onChipSelectionComplete: _onChipSelectionComplete,
        );
        _backstack.push(screen);
        page = screen;
        break;
      /** Create Profile Screen **/
      case routeOnboardingCreateProfile:
        var screen = OnboardingCreateProfileScreen(_onCreateProfileComplete);
        _backstack.push(screen);
        page = screen;
        break;
      /** Sponsorship Screen **/
      case routeOnboardingSponsorshipPackage:
        var screen = OnboardingSponsorshipPackageScreen(_onSponsorshipPackageComplete);
        _backstack.push(screen);
        page = screen;
        break;
      case routeOnboardingReviewProfile:
        var screen = OnboardingReviewProfileScreen();
        _backstack.push(screen);
        page = screen;
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
    var nextReady = _backstack.peek.onNextPressed(ref) == true;
    var nextReadyAsync = await _backstack.peek.onNextPressedAsync(ref) == true;
    if (nextReady || nextReadyAsync) {
      var isStepRequired = _backstack.peek.isStepRequired;
      var notifer = ref.read(onboardingControllerProvider.notifier);
      notifer.onNextPressed(isStepRequired);
    }
  }

  @protected
  void onBackPressed(BuildContext context, WidgetRef ref) {
    _backstack.peek.onBackPressed();
    _backstack.pop();

    var notifier = ref.read(onboardingControllerProvider.notifier);

    if (_backstack.length == 0) {
      Navigator.of(context).pop();
      notifier.reset();
    } else {
      navigatorKey.currentState?.pop();
      var isStepRequired = _backstack.peek.isStepRequired;
      notifier.onBackPressed(isStepRequired);
    }
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

  void _onChipSelectionComplete(ChipSelectionScreenType type) {
    if (_userType == null) return;

    String route;

    switch (type) {
      case ChipSelectionScreenType.businessInterests:
      case ChipSelectionScreenType.clubInterests:
        route = routeOnboardingSponsorshipPackage;
        break;
      case ChipSelectionScreenType.clubDescriptors:
        route = routeOnboardingCreateProfile;
        break;
    }

    navigatorKey.currentState?.pushNamed(route);
  }

  void _onCreateProfileComplete() {
    if (_userType == null) return;
    var route = _userType == UserType.club
        ? routeOnboardingChipClubInterest
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