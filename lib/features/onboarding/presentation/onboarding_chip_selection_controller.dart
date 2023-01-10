import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/onboarding/domain/category_service.dart';
import 'package:linx/features/onboarding/ui/onboarding_chip_selection_screen.dart';

class OnboardingChipSelectionController {
  final ProviderRef ref;

  static final provider =
      Provider((ref) => OnboardingChipSelectionController(ref: ref));

  final categoriesProvider =
      StateProvider<Map<String, List<String>>>((ref) => {});

  ChipSelectionScreenType? _lastType;

  OnboardingChipSelectionController({required this.ref});

  Future<void> fetchCategories(ChipSelectionScreenType type) async {
    if (_lastType != type || ref.read(categoriesProvider).isEmpty) {
      CategoryService service = ref.read(CategoryService.provider);
      Map<String, List<String>> categories =
          await service.fetchCategories(type);
      ref.read(categoriesProvider.notifier).state = categories;
    }
  }
}
