import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/buttons/linx_text_button.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/onboarding/presentation/onboarding_sponsorship_package_controller.dart';
import 'package:linx/features/onboarding/ui/model/onboarding_nav.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';

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

  OnboardingSponsorshipPackageScreen({
    required super.onScreenCompleted,
  }) : super(pageTitle: "Create custom packages", isStepRequired: false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(onboardingSponsorshipPackageControllerProvider);
    var length = state.packages.length;

    for (var i = 0; i < length; i++) {
      var package = state.packages[i];
      _packageNameControllers[i].text = package.name;
      _ownBenefitsControllers[i].text = package.ownBenefit;
      _partnerBenefitsControllers[i].text = package.partnerBenefit;
    }

    return Column(
      children: [
        buildOnboardingStepTitle(context),
        for (var i = 0; i < length; i++)
          _buildPackageForm(i, length),
        _buildAddAnotherButton(ref, length),
      ],
    );
  }

  @override
  bool onNextPressed(WidgetRef ref) {
    var notifier =
        ref.read(onboardingSponsorshipPackageControllerProvider.notifier);
    var packageNames =
        _packageNameControllers.map((e) => e.value.text).toList();
    var ownBenefits = _ownBenefitsControllers.map((e) => e.value.text).toList();
    var partnerBenefits =
        _partnerBenefitsControllers.map((e) => e.value.text).toList();

    notifier.updateSponsorshipPackages(
      packageNames,
      ownBenefits,
      partnerBenefits,
    );

    onScreenCompleted(OnboardingNav.next);

    return true;
  }

  Container _buildAddAnotherButton(WidgetRef ref, int length) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: LinxTextButton(
        label: "Add another",
        onPressed: () => { _onAddAnotherPressed(ref, length) },
        tint: LinxColors.green,
        iconData: Icons.add,
        weight: FontWeight.w600,
      ),
    );
  }

  void _onAddAnotherPressed(WidgetRef ref, int length) {
    ref.read(onboardingSponsorshipPackageControllerProvider.notifier)
        .onAddAnotherPressed();
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

  @override
  void onScreenPushed(WidgetRef ref) {
    ref.read(onboardingSponsorshipPackageControllerProvider.notifier).fetchSponsorshipPackages();
  }
}
