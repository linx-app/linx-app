import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/onboarding/data/category_repository.dart';
import 'package:linx/features/onboarding/ui/onboarding_chip_selection_screen.dart';

class CategoryService {
  final ProviderRef<CategoryService> _ref;

  CategoryService(this._ref);

  static final provider =
      Provider<CategoryService>((ref) => CategoryService(ref));

  Future<Map<String, List<String>>> fetchCategories(
    ChipSelectionScreenType screenType,
  ) {
    switch (screenType) {
      case ChipSelectionScreenType.clubDescriptors:
        return _fetchClubDescriptorCategories();
      case ChipSelectionScreenType.clubInterests:
        return _fetchClubInterestCategories();
      case ChipSelectionScreenType.businessInterests:
        return _fetchBusinessInterestCategories();
    }
  }

  Future<Map<String, List<String>>> _fetchClubInterestCategories() async {
    CategoryRepository repository = _ref.read(CategoryRepository.provider);

    List<String> clubInterestsCategories = ["sponsorship", "industries"];

    Map<String, List<String>>? result =
        await repository.fetchCategories(clubInterestsCategories);
    if (result == null) {
      return {};
    } else {
      return result;
    }
  }

  Future<Map<String, List<String>>> _fetchClubDescriptorCategories() async {
    CategoryRepository repository = _ref.read(CategoryRepository.provider);

    List<String> clubDescriptorCategories = ["arts", "sports", "hobbies"];

    Map<String, List<String>>? result =
        await repository.fetchCategories(clubDescriptorCategories);
    if (result == null) {
      return {};
    } else {
      return result;
    }
  }

  Future<Map<String, List<String>>> _fetchBusinessInterestCategories() async {
    CategoryRepository repository = _ref.read(CategoryRepository.provider);

    List<String> buisnessInterestCategories = [
      "sponsorship",
      "arts",
      "sports",
      "hobbies"
    ];

    Map<String, List<String>>? result =
        await repository.fetchCategories(buisnessInterestCategories);
    if (result == null) {
      return {};
    } else {
      return result;
    }
  }
}
