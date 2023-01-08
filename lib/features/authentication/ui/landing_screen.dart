import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/routes.dart';
import 'package:linx/constants/text.dart';

class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BaseScaffold(
      key: super.key,
      body: Center(
        child: SizedBox(
          width: width - 28.0,
          height: height,
          child: Column(
            children: [
              const Spacer(flex: 3),
              Image.asset(
                "assets/logo_with_name.png",
                height: 102.0,
                width: 78.0,
              ),
              const Spacer(),
              Image.asset("assets/landing_graphic.png"),
              const Spacer(),
              const Text(
                "Connect with clubs or businesses in your area.",
                style: LinxTextStyles.subtitle,
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 3),
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
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
      backgroundColor: LinxColors.white,
    );
  }

  void onLogInPressed(BuildContext context) {
    print("Log In Pressed");
  }

  void onSignUpPressed(BuildContext context) {
    Navigator.pushNamed(context, routeOnboardingStart);
  }
}
