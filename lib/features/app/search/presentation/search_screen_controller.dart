import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/app/core/presentation/app_bottom_nav_screen_controller.dart';
import 'package:linx/features/app/core/ui/model/search_state.dart';
import 'package:linx/features/app/search/domain/fetch_recent_searches_service.dart';
import 'package:linx/features/app/search/domain/fetch_same_location_users_service.dart';
import 'package:linx/features/app/search/domain/model/search_group.dart';
import 'package:linx/features/app/search/domain/model/user_search_page.dart';
import 'package:linx/features/app/search/domain/search_users_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

final searchScreenControllerProvider = StateNotifierProvider.autoDispose<
    SearchScreenController, SearchScreenUiState>(
  (ref) => SearchScreenController(
    ref.watch(currentUserProvider),
    ref.read(FetchRecentSearchesService.provider),
    ref.read(FetchSameLocationUsersService.provider),
    ref.read(SearchUsersService.provider),
  ),
);

class SearchScreenController extends StateNotifier<SearchScreenUiState> {
  final FetchSameLocationUsersService _fetchSameLocationUsers;
  final SearchUsersService _searchUsersService;
  final FetchRecentSearchesService _fetchRecentSearchesService;
  final LinxUser? _currentUser;

  late UserSearchPage? _currentPage;
  late List<SearchGroup> _groups;

  SearchScreenController(
    this._currentUser,
    this._fetchRecentSearchesService,
    this._fetchSameLocationUsers,
    this._searchUsersService,
  ) : super(SearchScreenUiState(state: SearchState.loading)) {
    initialize();
  }

  void initialize() async {
    if (_currentUser == null) return;
    _groups = await _fetchSameLocationUsers.execute(_currentUser!.info);
    state = SearchScreenUiState(state: SearchState.initial, groups: _groups);
  }

  void _load() => state = SearchScreenUiState(state: SearchState.loading);

  void onSearchGroupSelected(SearchGroup group) {
    _load();

    final users = group.users.toList();
    final subtitle = "Results for \"${group.category}\" (${users.length})";

    state = SearchScreenUiState(
      state: SearchState.results,
      results: UserSearchPage(users: users),
      subtitle: subtitle,
    );
  }

  void onSearchInitiated() async {
    final recents = await _fetchRecentSearchesService.execute(_currentUser!);
    state = SearchScreenUiState(
      state: SearchState.searching,
      recentSearches: recents,
    );
  }

  void onSearchCompleted(String searchField) async {
    _load();
    if (searchField == "") {
      state = SearchScreenUiState(state: SearchState.initial, groups: _groups);
    } else {
      _currentPage =
          await _searchUsersService.execute(_currentUser!.info, searchField);

      final length = _currentPage!.users.length;
      final subtitle = "Results for \"$searchField\" ($length)";

      state = SearchScreenUiState(
        state: SearchState.results,
        results: _currentPage,
        subtitle: subtitle,
      );
    }
  }
}

class SearchScreenUiState {
  final SearchState state;
  final List<SearchGroup> groups;
  final UserSearchPage? results;
  final List<List<SponsorshipPackage>> packages;
  final List<String> recentSearches;
  final String subtitle;

  SearchScreenUiState({
    this.state = SearchState.initial,
    this.groups = const [],
    this.results,
    this.recentSearches = const [],
    this.subtitle = "",
    this.packages = const [],
  });
}
