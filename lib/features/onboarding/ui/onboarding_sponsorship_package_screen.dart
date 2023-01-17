import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/buttons/linx_text_button.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';

final _numberOfPackagesProvider = StateProvider((ref) => 1);

class OnboardingSponsorshipPackageScreen extends OnboardingView {
  final List<TextEditingController> _packageNameControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> _ownBenefitsControllers = [
    TextEditingController()
  ];
  final List<TextEditingController> _partnerBenefitsControllers = [
    TextEditingController()
  ];

  @override
  final VoidCallback onScreenCompleted;

  @override
  final String pageTitle = "Create custom packages";

  @override
  bool isStepRequired = false;

  OnboardingSponsorshipPackageScreen(this.onScreenCompleted);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int numberOfPackages = ref.watch(_numberOfPackagesProvider);
    return Column(
      children: [
        buildOnboardingStepTitle(context),
        for (var i = 0; i < numberOfPackages; i++)
          _buildPackageForm(i, numberOfPackages),
        _buildAddAnotherButton(ref, numberOfPackages),
      ],
    );
  }

  @override
  void onBackPressed() {
    // TODO: implement onBackPressed
  }

  @override
  bool onNextPressed(WidgetRef ref) {
    onScreenCompleted();
    return super.onNextPressed(ref);
  }

  Container _buildAddAnotherButton(WidgetRef ref, int numberOfPackages) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: LinxTextButton(
        label: "Add another",
        onPressed: () => { _onAddAnotherPressed(ref, numberOfPackages) },
        tint: LinxColors.green,
        iconData: Icons.add,
        weight: FontWeight.w600,
      ),
    );
  }

  void _onAddAnotherPressed(WidgetRef ref, int numberOfPackages) {
    ref.read(_numberOfPackagesProvider.notifier).state = numberOfPackages + 1;
    _packageNameControllers.add(TextEditingController());
    _ownBenefitsControllers.add(TextEditingController());
    _partnerBenefitsControllers.add(TextEditingController());
  }

  Container _buildPackageForm(int index, int numberOfPackages) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          _buildTextForm(
            title: "Package name",
            hint: "e.g. Gold Tier",
            controller: _packageNameControllers[index],
          ),
          _buildTextForm(
            title: "What you get",
            hint: "e.g.",
            controller: _ownBenefitsControllers[index],
            minLines: 3,
            maxLines: 3,
          ),
          _buildTextForm(
            title: "What your partner gets",
            hint: "e.g.",
            controller: _partnerBenefitsControllers[index],
            minLines: 3,
            maxLines: 3,
          ),
          if (index < numberOfPackages - 1) const Divider(),
        ],
      ),
    );
  }

  Container _buildTextForm({
    required String title,
    required String hint,
    required TextEditingController controller,
    int minLines = 1,
    int maxLines = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
          ),
          LinxTextField(
            label: hint,
            controller: controller,
            minLines: minLines,
            maxLines: maxLines,
          ),
        ],
      ),
    );
  }
}
