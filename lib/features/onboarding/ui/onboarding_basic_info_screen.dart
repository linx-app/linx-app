import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/features/onboarding/presentation/onboarding_basic_info_controller.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';

class OnboardingBasicInfoScreen extends OnboardingView {
  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _locationController = TextEditingController();

  @override
  final VoidCallback onScreenCompleted;

  @override
  final String pageTitle = "Who are you?";

  OnboardingBasicInfoScreen({required this.onScreenCompleted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        buildOnboardingStepTitle(context),
        _buildTextField("Name", _nameController),
        _buildTextField("Phone number", _phoneNumberController),
        _buildTextField('Location', _locationController)
      ],
    );
  }

  @override
  void onBackPressed() {}

  @override
  bool onNextPressed(WidgetRef ref) {
    var notifier = ref.read(onboardingBasicInfoControllerProvider.notifier);
    notifier.onPageComplete(
      _nameController.text,
      _phoneNumberController.text,
      _locationController.text,
    );
    onScreenCompleted();
    return true;
  }

  Container _buildTextField(String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
      child: LinxTextField(
        label: label,
        controller: controller,
      ),
    );
  }
}
