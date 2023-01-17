import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/utils/ui_extensions.dart';

abstract class OnboardingView extends ConsumerWidget {
  late String pageTitle;
  late VoidCallback onScreenCompleted;
  bool isStepRequired = true;

  bool onNextPressed(WidgetRef ref) => true;

  Future<bool> onNextPressedAsync(WidgetRef ref) async => await Future(() => true);

  void onBackPressed();

  @protected
  Container buildOnboardingStepTitle(BuildContext context) {
    return Container(
      width: context.width(),
      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
      child: Text(pageTitle, style: LinxTextStyles.title),
    );
  }
}
