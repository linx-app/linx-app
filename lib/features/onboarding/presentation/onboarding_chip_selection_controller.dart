import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/onboarding/domain/category_service.dart';
import 'package:linx/features/onboarding/ui/onboarding_chip_selection_screen.dart';

final onboardingChipSelectionController = StateNotifierProvider<OnboardingChipSelectionController, Map<String, List<String>>>((ref) {
  return OnboardingChipSelectionController(
    ref.read(CategoryService.provider),
  );
});

class OnboardingChipSelectionController
    extends StateNotifier<Map<String, List<String>>> {
  final CategoryService _categoryService;

  OnboardingChipSelectionController(this._categoryService) : super({});

  Future<void> fetchCategories(ChipSelectionScreenType type) async {
    if (state.isEmpty == true) {
      var categories = await _categoryService.fetchCategories(type);
      state = categories;
    }
  }
}
