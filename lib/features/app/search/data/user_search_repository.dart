import 'package:algolia/algolia.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/algolia/algolia_provider.dart';
import 'package:linx/features/app/search/data/model/paginated_user_search_result.dart';
import 'package:linx/features/user/data/model/user_dto.dart';

class UserSearchRepository {
  static final provider = Provider.autoDispose(
      (ref) => UserSearchRepository(ref.read(algoliaProvider)));

  final Algolia _searcher;

  UserSearchRepository(this._searcher);

  Future<PaginatedUserSearchResult> search(String search) async {
    final query = _searcher.instance.index("user_search").query(search);
    final results = await query.getObjects();
    var users = results.hits
        .map((e) => UserDTO.fromNetwork(e.objectID, e.data))
        .toList();
    final isLastPage = results.page >= results.nbPages;
    final nextPageKey = isLastPage ? null : results.page + 1;
    return PaginatedUserSearchResult(users, results.page, nextPageKey);
  }
}
