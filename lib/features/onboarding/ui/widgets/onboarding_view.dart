import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/features/onboarding/ui/model/onboarding_nav.dart';
import 'package:linx/utils/ui_extensions.dart';

abstract class OnboardingView extends ConsumerWidget {
  final String pageTitle;
  final Function(OnboardingNav) onScreenCompleted;
  final bool isStepRequired;

  bool onNextPressed(WidgetRef ref) {
    return true;
  }

  Future<bool> onNextPressedAsync(WidgetRef ref) async {
    return await Future(() => true);
  }

  void onScreenPushed(WidgetRef ref);

  void onBackPressed() {
    onScreenCompleted(OnboardingNav.back);
  }

  OnboardingView({
    required this.onScreenCompleted,
    required this.pageTitle,
    this.isStepRequired = true
  });

  @protected
  Container buildOnboardingStepTitle(BuildContext context) {
    return Container(
      width: context.width(),
      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
      child: Text(pageTitle, style: LinxTextStyles.title),
    );
  }
}
