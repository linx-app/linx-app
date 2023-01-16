import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/onboarding/domain/category_service.dart';
import 'package:linx/features/onboarding/domain/user_info_service.dart';
import 'package:linx/features/onboarding/ui/onboarding_chip_selection_screen.dart';

final onboardingChipSelectionController = StateNotifierProvider<
    OnboardingChipSelectionController, OnboardingChipSelectionUiState>((ref) {
  return OnboardingChipSelectionController(ref.read(CategoryService.provider),
      ref.read(OnboardingUserInfoService.provider));
});

class OnboardingChipSelectionController
    extends StateNotifier<OnboardingChipSelectionUiState> {
  final CategoryService _categoryService;
  final OnboardingUserInfoService _onboardingUserInfoService;

  OnboardingChipSelectionController(
      this._categoryService, this._onboardingUserInfoService)
      : super(OnboardingChipSelectionUiState());

  Future<void> fetchCategories(ChipSelectionScreenType type) async {
    if (state.isEmpty() == true) {
      var categories = await _categoryService.fetchCategories(type);
      state = OnboardingChipSelectionUiState(
          chips: categories, selectedChips: state.selectedChips);
    }
  }

  Future<void> onChipSelected(String label) async {
    var selected = {...state.selectedChips};

    if (selected.contains(label)) {
      selected.remove(label);
    } else {
      selected.add(label);
    }

    state = OnboardingChipSelectionUiState(
      chips: state.chips,
      selectedChips: selected,
    );
  }

  Future<void> updateUserChips(ChipSelectionScreenType type) async {
    await _onboardingUserInfoService.updateUserChips(
      type: type,
      chips: state.selectedChips,
    );
  }
}

class OnboardingChipSelectionUiState {
  final Map<String, List<String>> chips;
  final Set<String> selectedChips;

  OnboardingChipSelectionUiState(
      {this.chips = const {}, this.selectedChips = const {}});

  bool isEmpty() => chips.isEmpty;
}
