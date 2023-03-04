import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/match/data/match_repository.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/transformations/user_transformation_extensions.dart';

class MatchService {
  static final provider = Provider((ref) => MatchService(
        ref.read(MatchRepository.provider),
      ));

  final MatchRepository _matchRepository;

  MatchService(this._matchRepository);

  Future<List<LinxUser>> fetchUsersWithMatchingInterests(
    LinxUser user,
  ) async {
    var networkUsers =
        await _matchRepository.fetchUsersWithMatchingInterests(user);
    var domainUsers = networkUsers.map((user) => user.toDomain()).toList();
    domainUsers.sort((a, b) => _compare(user.interests, a, b));
    return domainUsers.take(10).toList();
  }

  int _compare(Set<String> current, LinxUser a, LinxUser b) {
    var aValue = current.intersection(a.descriptors).length;
    var bValue = current.intersection(b.descriptors).length;
    return aValue.compareTo(bValue);
  }
}
