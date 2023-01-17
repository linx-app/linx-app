import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/linx_chip.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/onboarding/ui/model/chip_selection_screen_type.dart';
import 'package:linx/features/onboarding/presentation/onboarding_chip_selection_controller.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';
import 'package:linx/utils/ui_extensions.dart';

class OnboardingChipSelectionScreen extends OnboardingView {
  final ChipSelectionScreenType type;

  final Function(ChipSelectionScreenType) onChipSelectionComplete;

  OnboardingChipSelectionScreen({
    required this.type,
    required this.onChipSelectionComplete,
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
    var state = ref.watch(onboardingChipSelectionController);
    return Column(
      children: [
        buildOnboardingStepTitle(context),
        ..._buildSections(context, state, ref)
      ],
    );
  }

  @override
  void onBackPressed() {}

  @override
  bool onNextPressed(WidgetRef ref) {
    ref.read(onboardingChipSelectionController.notifier).updateUserChips(type);
    onChipSelectionComplete(type);
    return true;
  }

  void _onChipSelected(String label, WidgetRef ref) {
    var notifier = ref.read(onboardingChipSelectionController.notifier);
    notifier.onChipSelected(label);
  }

  List<Container> _buildSections(
    BuildContext context,
    OnboardingChipSelectionUiState state,
    WidgetRef ref,
  ) {
    List<Container> sections = [];
    state.chips.forEach((key, value) {
      sections.add(_buildSection(context, key, value, ref));
    });
    return sections;
  }

  Container _buildSection(
    BuildContext context,
    String category,
    List<String> values,
    WidgetRef ref,
  ) {
    var selected = ref.watch(onboardingChipSelectionController).selectedChips;
    Iterable<LinxChip> chips = values.map(
      (label) => LinxChip(
        label: label,
        onChipSelected: (label) => _onChipSelected(label, ref),
        isSelected: selected.contains(label),
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