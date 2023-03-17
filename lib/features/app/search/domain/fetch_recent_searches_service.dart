import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

class FetchRecentSearchesService {
  static final provider = Provider(
    (ref) => FetchRecentSearchesService(
      ref.read(UserRepository.provider),
    ),
  );

  final UserRepository _userRepository;

  FetchRecentSearchesService(this._userRepository);

  Future<List<String>> execute(LinxUser user) async {
    final searches = await _userRepository.fetchRecentSearches(user.info.uid);
    final reversed = searches.reversed.take(5);
    return reversed.toList();
  }
}
