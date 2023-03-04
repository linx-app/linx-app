import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/error_snackbar.dart';
import 'package:linx/common/linx_chip.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/onboarding/presentation/onboarding_chip_selection_controller.dart';
import 'package:linx/features/app/onboarding/ui/model/chip_selection_screen_type.dart';
import 'package:linx/features/app/onboarding/ui/model/onboarding_nav.dart';
import 'package:linx/features/app/onboarding/ui/widgets/onboarding_view.dart';
import 'package:linx/utils/ui_extensions.dart';

class OnboardingChipSelectionScreen extends OnboardingView {
  final ChipSelectionScreenType type;

  OnboardingChipSelectionScreen({
    required this.type,
    required super.onScreenCompleted,
    required super.pageTitle,
  });

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
  bool onNextPressed(WidgetRef ref) {
    ref.read(onboardingChipSelectionController.notifier).updateUserChips(type);
    onScreenCompleted(OnboardingNav.next);
    return true;
  }

  void _onChipSelected(
    String label,
    WidgetRef ref,
    OnboardingChipSelectionUiState state,
    BuildContext context,
  ) {
    var selected = state.selectedChips;

    if (selected.length == 10 && !selected.contains(label)) {
      var snackBarMessage = "You cannot select more than 10 chips";
      var snackBar = ErrorSnackBar(errorMessage: snackBarMessage);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      var notifier = ref.read(onboardingChipSelectionController.notifier);
      notifier.onChipSelected(label);
    }
  }

  List<Container> _buildSections(
    BuildContext context,
    OnboardingChipSelectionUiState state,
    WidgetRef ref,
  ) {
    List<Container> sections = [];
    state.chips.forEach((key, value) {
      sections.add(_buildSection(context, key, value, ref, state));
    });
    return sections;
  }

  Container _buildSection(
    BuildContext context,
    String category,
    List<String> values,
    WidgetRef ref,
    OnboardingChipSelectionUiState state,
  ) {
    var selected = ref.watch(onboardingChipSelectionController).selectedChips;
    Iterable<LinxChip> chips = values.map(
      (label) => LinxChip(
        label: label,
        onChipSelected: (label) => _onChipSelected(label, ref, state, context),
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

  @override
  void onScreenPushed(WidgetRef ref) {
    ref.read(onboardingChipSelectionController.notifier).fetchCategories(type);
  }
}
