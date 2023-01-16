import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/linx_chip.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/onboarding/presentation/onboarding_chip_selection_controller.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';
import 'package:linx/utils/ui_extensions.dart';

class OnboardingChipSelectionScreen extends OnboardingView {
  final ChipSelectionScreenType type;

  @override
  late VoidCallback onScreenCompleted;

  OnboardingChipSelectionScreen({
    required this.type,
    required this.onScreenCompleted,
  }) {
    switch (type) {
      case ChipSelectionScreenType.clubDescriptors:
        pageTitle = "What type of\ngroup are you?";
        break;
      case ChipSelectionScreenType.clubInterests:
        pageTitle = "What are you\nlooking for?";
        break;
      case ChipSelectionScreenType.businessInterests:
        pageTitle = "How do you\nwant to help?";
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(onboardingChipSelectionController.notifier).fetchCategories(type);
    Map<String, List<String>> categories =
        ref.watch(onboardingChipSelectionController);

    return Column(
      children: [
        buildOnboardingStepTitle(context),
        ..._buildSections(context, categories)
      ],
    );
  }

  @override
  void onBackPressed() {}

  @override
  bool onNextPressed(WidgetRef ref) {
    onScreenCompleted();
    return true;
  }

  void _onChipSelected(bool selected, String label) {}

  List<Container> _buildSections(
      BuildContext context, Map<String, List<String>> categories) {
    List<Container> sections = [];
    categories.forEach((key, value) {
      sections.add(_buildSection(context, key, value));
    });
    return sections;
  }

  Container _buildSection(
      BuildContext context, String category, List<String> values) {
    Iterable<LinxChip> chips = values.map(
      (e) => LinxChip(
        label: e.capitalize(),
        onChipSelected: _onChipSelected,
      ),
    );

    return Container(
      width: context.width(),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(category),
          SizedBox(width: context.width(), height: 12.0),
          Wrap(spacing: 8.0, children: [...chips]),
        ],
      ),
    );
  }

  Text _buildSectionTitle(String title) {
    return Text(
      title.capitalize(),
      style: const TextStyle(
        color: LinxColors.backButtonGrey,
        fontSize: 17.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

enum ChipSelectionScreenType {
  clubDescriptors,
  clubInterests,
  businessInterests
}
