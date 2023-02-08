import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/routes.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/features/authentication/ui/widgets/linx_logo.dart';

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
            height: 185,
            child: const LinxLogo(),
          ),
          Expanded(
            child: Column(
              children: [
                Image.asset("assets/landing_graphic.png"),
                Container(
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
    Navigator.pushNamed(context, routeLogIn);
  }

  void onSignUpPressed(BuildContext context) {
    Navigator.pushNamed(context, routeOnboardingStart);
  }

  void _onWidgetTestingPressed(BuildContext context) {
    Navigator.pushNamed(context, routeDebugWidgetTesting);
  }
}
