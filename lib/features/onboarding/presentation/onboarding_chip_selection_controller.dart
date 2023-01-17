import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/onboarding/domain/category_service.dart';
import 'package:linx/features/onboarding/ui/model/chip_selection_screen_type.dart';
import 'package:linx/features/user/domain/user_interests_descriptors_service.dart';

final onboardingChipSelectionController = StateNotifierProvider<
    OnboardingChipSelectionController,
    OnboardingChipSelectionUiState>((ref) {
  return OnboardingChipSelectionController(
    ref.read(CategoryService.provider),
    ref.read(UserInterestDescriptorService.provider),
  );
});

class OnboardingChipSelectionController
    extends StateNotifier<OnboardingChipSelectionUiState> {
  final CategoryService _categoryService;
  final UserInterestDescriptorService _userInterestDescriptorService;

  OnboardingChipSelectionController(this._categoryService,
      this._userInterestDescriptorService)
      : super(OnboardingChipSelectionUiState());

  Future<void> fetchCategories(ChipSelectionScreenType type) async {
    if (state.isEmpty() == true) {
      Map<String, List<String>> categories;

      switch (type) {
        case ChipSelectionScreenType.clubDescriptors:
          categories = await _categoryService.fetchClubDescriptorCategories();
          break;
        case ChipSelectionScreenType.clubInterests:
          categories = await _categoryService.fetchClubInterestCategories();
          break;
        case ChipSelectionScreenType.businessInterests:
          categories = await _categoryService.fetchBusinessInterestCategories();
          break;
      }

      state = OnboardingChipSelectionUiState(
        chips: categories,
        selectedChips: state.selectedChips,
      );
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
    switch (type) {
      case ChipSelectionScreenType.clubInterests:
      case ChipSelectionScreenType.businessInterests:
        await _userInterestDescriptorService.updateUserInterests(interests: state.selectedChips);
        break;
      case ChipSelectionScreenType.clubDescriptors:
        await _userInterestDescriptorService.updateUserDescriptors(descriptors: state.selectedChips);
        break;
    }
  }
}

class OnboardingChipSelectionUiState {
  final Map<String, List<String>> chips;
  final Set<String> selectedChips;

  OnboardingChipSelectionUiState(
      {this.chips = const {}, this.selectedChips = const {}});

  bool isEmpty() => chips.isEmpty;
}
