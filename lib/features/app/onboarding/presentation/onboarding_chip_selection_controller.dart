import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/onboarding/domain/category_service.dart';
import 'package:linx/features/app/onboarding/ui/model/chip_selection_screen_type.dart';
import 'package:linx/features/user/domain/user_interests_descriptors_service.dart';
import 'package:linx/features/user/domain/user_service.dart';

final onboardingChipSelectionController = StateNotifierProvider<
    OnboardingChipSelectionController, OnboardingChipSelectionUiState>((ref) {
  return OnboardingChipSelectionController(
    ref.read(CategoryService.provider),
    ref.read(UserInterestDescriptorService.provider),
    ref.read(UserService.provider),
  );
});

class OnboardingChipSelectionController
    extends StateNotifier<OnboardingChipSelectionUiState> {
  final CategoryService _categoryService;
  final UserInterestDescriptorService _userInterestDescriptorService;
  final UserService _userService;

  OnboardingChipSelectionController(
    this._categoryService,
    this._userInterestDescriptorService,
    this._userService,
  ) : super(OnboardingChipSelectionUiState(
          type: ChipSelectionScreenType.clubInterests,
        ));

  Future<void> fetchCategories(ChipSelectionScreenType type) async {
    if (type != state.type) {
      Map<String, List<String>> categories;
      var user = await _userService.fetchUserProfile();
      Set<String> selected;

      switch (type) {
        case ChipSelectionScreenType.clubDescriptors:
          categories = await _categoryService.fetchClubDescriptorCategories();
          selected = user.descriptors;
          break;
        case ChipSelectionScreenType.clubInterests:
          categories = await _categoryService.fetchClubInterestCategories();
          selected = user.interests;
          break;
        case ChipSelectionScreenType.businessInterests:
          categories = await _categoryService.fetchBusinessInterestCategories();
          selected = user.interests;
          break;
        case ChipSelectionScreenType.businessDescriptors:
          categories =
              await _categoryService.fetchBusinessDescriptorCategories();
          selected = user.descriptors;
          break;
      }

      state = OnboardingChipSelectionUiState(
        type: type,
        chips: categories,
        selectedChips: selected,
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
      type: state.type,
      chips: state.chips,
      selectedChips: selected,
    );
  }

  Future<void> updateUserChips(ChipSelectionScreenType type) async {
    switch (type) {
      case ChipSelectionScreenType.clubInterests:
      case ChipSelectionScreenType.businessInterests:
        await _userInterestDescriptorService.updateUserInterests(
          interests: state.selectedChips,
        );
        break;
      case ChipSelectionScreenType.businessDescriptors:
      case ChipSelectionScreenType.clubDescriptors:
        await _userInterestDescriptorService.updateUserDescriptors(
          descriptors: state.selectedChips,
        );
        break;
    }
  }
}

class OnboardingChipSelectionUiState {
  final ChipSelectionScreenType type;
  final Map<String, List<String>> chips;
  final Set<String> selectedChips;

  OnboardingChipSelectionUiState({
    required this.type,
    this.chips = const {},
    this.selectedChips = const {},
  });

  bool isEmpty() => chips.isEmpty;
}
