import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/features/onboarding/presentation/onboarding_basic_info_controller.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';

class OnboardingBasicInfoScreen extends OnboardingView {
  late OnboardingBasicInfoController _controller;

  @override
  late final VoidCallback onScreenCompleted;

  @override
  final String pageTitle = "Who are you?";

  OnboardingBasicInfoScreen({required this.onScreenCompleted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _controller = ref.read(OnboardingBasicInfoController.provider);

    return Column(
      children: [
        buildOnboardingStepTitle(context),
        Container(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
          child: LinxTextField(
            label: "Name",
            controller: _controller.nameController,
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
          child: LinxTextField(
            label: "Phone number",
            controller: _controller.phoneNumberController,
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
          child: LinxTextField(
            label: "Location",
            controller: _controller.locationController,
          ),
        ),
      ],
    );
  }

  @override
  void onBackPressed() {}

  @override
  void onNextPressed() {
    onScreenCompleted();
  }
}
