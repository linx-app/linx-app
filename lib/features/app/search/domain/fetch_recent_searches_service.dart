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
    return await _userRepository.fetchRecentSearches(user.info.uid);
  }
}
