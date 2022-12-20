import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/onboarding_screen.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingScreen(
      stepTitle: "Create Account",
      onBackPressed: () { onBackPressed(context); },
      onNextPressed: () { onNextPressed(context); },
      body: const Text("Body"),
    );
  }

  void onBackPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void onNextPressed(BuildContext context) {}
}
