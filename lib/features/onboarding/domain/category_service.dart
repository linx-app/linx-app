import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/onboarding/data/category_repository.dart';

class CategoryService {
  static final provider = Provider((ref) {
    return CategoryService(ref.read(CategoryRepository.provider));
  });

  final CategoryRepository _categoryRepository;

  CategoryService(this._categoryRepository);

  Future<Map<String, List<String>>> fetchClubInterestCategories() async {
    List<String> clubInterestsCategories = ["sponsorship", "industries"];

    Map<String, List<String>>? result =
        await _categoryRepository.fetchCategories(clubInterestsCategories);
    if (result == null) {
      return {};
    } else {
      return result;
    }
  }

  Future<Map<String, List<String>>> fetchClubDescriptorCategories() async {
    List<String> clubDescriptorCategories = ["arts", "sports", "hobbies"];

    Map<String, List<String>>? result =
        await _categoryRepository.fetchCategories(clubDescriptorCategories);
    if (result == null) {
      return {};
    } else {
      return result;
    }
  }

  Future<Map<String, List<String>>> fetchBusinessInterestCategories() async {
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
