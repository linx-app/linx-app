import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/constants/routes.dart';
import 'package:linx/features/authentication/ui/signup_screen.dart';
import 'package:linx/features/onboarding/presentation/onboarding_flow_controller.dart';
import 'package:linx/features/onboarding/ui/model/chip_selection_screen_type.dart';
import 'package:linx/features/onboarding/ui/model/onboarding_nav.dart';
import 'package:linx/features/onboarding/ui/onboarding_basic_info_screen.dart';
import 'package:linx/features/onboarding/ui/onboarding_chip_selection_screen.dart';
import 'package:linx/features/onboarding/ui/onboarding_create_profile_screen.dart';
import 'package:linx/features/onboarding/ui/onboarding_review_profile_screen.dart';
import 'package:linx/features/onboarding/ui/onboarding_sponsorship_package_screen.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';
import 'package:linx/features/user/domain/model/user_type.dart';

abstract class OnboardingFlowRouter extends ConsumerWidget {
  UserType? _userType;

  // final LinxStack<OnboardingView> _backstack = LinxStack();
  OnboardingView? _currentScreen = null;

  @protected
  final navigatorKey = GlobalKey<NavigatorState>();

  @protected
  Route onGenerateRoute(RouteSettings settings, WidgetRef ref, VoidCallback onFinishOnboarding) {
    late Widget page;

    switch (settings.name) {
      /** Sign Up Screen **/
      case routeOnboardingSignUp:
        var screen = SignUpScreen(
          onScreenCompleted: (nav) {},
          onSignUpCompleted: _onSignUpComplete,
        );
        // _backstack.push(screen);
        _currentScreen = screen;
        page = screen;
        break;
      /** Basic Info Screen **/
      case routeOnboardingBasicInfo:
        var screen = OnboardingBasicInfoScreen(
          onScreenCompleted: _onBasicInfoComplete,
        );
        _currentScreen = screen;
        // _backstack.push(screen);
        page = screen;
        break;
      /** Chip Selection Screens **/
      case routeOnboardingChipClubDescriptor:
        var screen = OnboardingChipSelectionScreen(
          type: ChipSelectionScreenType.clubDescriptors,
          onScreenCompleted: _onClubDescriptorComplete,
          pageTitle: "What type of\ngroup are you?",
        );
        _currentScreen = screen;
        // _backstack.push(screen);
        page = screen;
        break;
      case routeOnboardingChipClubInterest:
        var screen = OnboardingChipSelectionScreen(
          type: ChipSelectionScreenType.clubInterests,
          onScreenCompleted: _onChipInterestComplete,
          pageTitle: "What are you\nlooking for?",
        );
        _currentScreen = screen;
        // _backstack.push(screen);
        page = screen;
        break;
      case routeOnboardingChipBusinessInterest:
        var screen = OnboardingChipSelectionScreen(
          type: ChipSelectionScreenType.businessInterests,
          onScreenCompleted: _onChipInterestComplete,
          pageTitle: "How do you\nwant to help?",
        );
        _currentScreen = screen;
        // _backstack.push(screen);
        page = screen;
        break;
      /** Create Profile Screen **/
      case routeOnboardingCreateProfile:
        var screen = OnboardingCreateProfileScreen(
          onScreenCompleted: _onCreateProfileComplete,
        );
        // _backstack.push(screen);
        _currentScreen = screen;
        page = screen;
        break;
      /** Sponsorship Screen **/
      case routeOnboardingSponsorshipPackage:
        var screen = OnboardingSponsorshipPackageScreen(
          onScreenCompleted: _onSponsorshipPackageComplete,
        );
        // _backstack.push(screen);
        _currentScreen = screen;
        page = screen;
        break;
      /**  Review Profile Screen **/
      case routeOnboardingReviewProfile:
        var screen = OnboardingReviewProfileScreen(
          onScreenCompleted: (nav) => _onReviewProfileComplete(nav, onFinishOnboarding),
        );
        // _backstack.push(screen);
        _currentScreen = screen;
        page = screen;
        break;
    }

    _currentScreen?.onScreenPushed(ref);
    // _backstack.peek.onScreenPushed(ref);

    return MaterialPageRoute(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }

  @protected
  void onNextPressed(WidgetRef ref) async {
    // var nextReady = _backstack.peek.onNextPressed(ref) == true;
    // var nextReadyAsync = await _backstack.peek.onNextPressedAsync(ref) == true;
    var nextReady = _currentScreen?.onNextPressed(ref) == true;
    var nextReadyAsync = await _currentScreen?.onNextPressedAsync(ref) == true;
    if (nextReady && nextReadyAsync) {
      var isStepRequired = _currentScreen?.isStepRequired == true;
      var notifer = ref.read(onboardingControllerProvider.notifier);
      notifer.onNextPressed(isStepRequired);
    }
  }

  @protected
  void onBackPressed(BuildContext context, WidgetRef ref) {
    // _backstack.pop();

    var notifier = ref.read(onboardingControllerProvider.notifier);

    if (_currentScreen is SignUpScreen) {
      Navigator.of(context).pop();
      notifier.reset();
    } else {
      // navigatorKey.currentState?.pop();
      _currentScreen?.onBackPressed();
      var isStepRequired = _currentScreen?.isStepRequired == true;
      notifier.onBackPressed(isStepRequired);
    }
  }

  void _onSignUpComplete(UserType type) {
    _userType = type;
    navigatorKey.currentState?.popAndPushNamed(routeOnboardingBasicInfo);
  }

  void _onBasicInfoComplete(OnboardingNav nav) {
    if (_userType == null) return;

    String route;

    if (nav == OnboardingNav.next) {
      route = _userType == UserType.club
          ? routeOnboardingChipClubDescriptor
          : routeOnboardingCreateProfile;
    } else {
      route = routeOnboardingSignUp;
    }

    navigatorKey.currentState?.popAndPushNamed(route);
  }

  void _onChipInterestComplete(OnboardingNav nav) {
    var route = nav == OnboardingNav.next
        ? routeOnboardingSponsorshipPackage
        : routeOnboardingCreateProfile;
    navigatorKey.currentState?.popAndPushNamed(route);
  }

  void _onClubDescriptorComplete(OnboardingNav nav) {
    var route = nav == OnboardingNav.next
        ? routeOnboardingCreateProfile
        : routeOnboardingBasicInfo;
    navigatorKey.currentState?.popAndPushNamed(route);
  }

  void _onCreateProfileComplete(OnboardingNav nav) {
    String route;

    if (nav == OnboardingNav.next) {
      route = _userType == UserType.club
          ? routeOnboardingChipClubInterest
          : routeOnboardingChipBusinessInterest;
    } else {
      route = _userType == UserType.club
          ? routeOnboardingChipClubDescriptor
          : routeOnboardingBasicInfo;
    }

    navigatorKey.currentState?.popAndPushNamed(route);
  }

  void _onSponsorshipPackageComplete(OnboardingNav nav) {
    String route;

    if (nav == OnboardingNav.next) {
      route = routeOnboardingReviewProfile;
    } else {
      route = _userType == UserType.club
          ? routeOnboardingChipClubInterest
          : routeOnboardingChipBusinessInterest;
    }

    navigatorKey.currentState?.popAndPushNamed(route);
  }

  void _onReviewProfileComplete(OnboardingNav nav, VoidCallback onFinishOnboarding) {
    if (nav == OnboardingNav.next) {
      onFinishOnboarding();
    } else {
      navigatorKey.currentState?.popAndPushNamed(routeOnboardingSponsorshipPackage);
    }
  }
}
