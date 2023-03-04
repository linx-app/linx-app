import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/routes.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/features/authentication/ui/login_screen.dart';
import 'package:linx/features/authentication/ui/widgets/linx_logo.dart';
import 'package:linx/features/debug/widget_testing_screen.dart';
import 'package:linx/features/app/onboarding/ui/onboarding_flow_screen.dart';
import 'package:linx/utils/ui_extensions.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseScaffold(
      backgroundColor: LinxColors.white,
      body: Column(
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            height: context.height() * 0.20,
            child: const LinxLogo(),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/landing_graphic.png", width: context.width() * 0.85),
                Container(
                  width: context.width(),
                  padding: const EdgeInsets.all(24),
                  child: const Text(
                    "Connect with clubs or businesses in your area.",
                    style: LinxTextStyles.subtitle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                RoundedButton(
                  style: greenButtonStyle(),
                  onPressed: () {
                    onLogInPressed(context);
                  },
                  text: "Log In",
                ),
                RoundedButton(
                  style: greyButtonStyle(),
                  onPressed: () => onSignUpPressed(context),
                  text: "Sign Up",
                ),
                if (kDebugMode)
                  RoundedButton(
                    style: greyButtonStyle(),
                    onPressed: () => _onWidgetTestingPressed(context),
                    text: "Widget Testing Page"
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onLogInPressed(BuildContext context) {
    var page = MaterialPageRoute(builder: (context) => LogInScreen());
    Navigator.push(context, page);
  }

  void onSignUpPressed(BuildContext context) {
    var screen = OnboardingFlowScreen(initialRoute: routeOnboardingSignUp);
    var page = MaterialPageRoute(builder: (context) => screen);
    Navigator.push(context, page);
  }

  void _onWidgetTestingPressed(BuildContext context) {
    var page = MaterialPageRoute(builder: (context) => WidgetTestingScreen());
    Navigator.push(context, page);
  }
}
