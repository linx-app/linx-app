import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/onboarding/data/category_repository.dart';
import 'package:linx/features/onboarding/ui/onboarding_chip_selection_screen.dart';

class CategoryService {
  static final provider = Provider((ref) {
    return CategoryService(ref.read(CategoryRepository.provider));
  });

  final CategoryRepository _categoryRepository;

  CategoryService(this._categoryRepository);

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
    List<String> clubInterestsCategories = ["sponsorship", "industries"];

    Map<String, List<String>>? result =
        await _categoryRepository.fetchCategories(clubInterestsCategories);
    if (result == null) {
      return {};
    } else {
      return result;
    }
  }

  Future<Map<String, List<String>>> _fetchClubDescriptorCategories() async {
    List<String> clubDescriptorCategories = ["arts", "sports", "hobbies"];

    Map<String, List<String>>? result =
        await _categoryRepository.fetchCategories(clubDescriptorCategories);
    if (result == null) {
      return {};
    } else {
      return result;
    }
  }

  Future<Map<String, List<String>>> _fetchBusinessInterestCategories() async {
    List<String> buisnessInterestCategories = [
      "sponsorship",
      "arts",
      "sports",
      "hobbies"
    ];

    Map<String, List<String>>? result =
        await _categoryRepository.fetchCategories(buisnessInterestCategories);
    if (result == null) {
      return {};
    } else {
      return result;
    }
  }
}
