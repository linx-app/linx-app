import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/app/core/ui/model/search_state.dart';
import 'package:linx/features/app/search/domain/fetch_recent_searches_service.dart';
import 'package:linx/features/app/search/domain/fetch_same_location_users_service.dart';
import 'package:linx/features/app/search/domain/model/search_group.dart';
import 'package:linx/features/app/search/domain/model/user_search_page.dart';
import 'package:linx/features/app/search/domain/search_users_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/subscribe_to_current_user_service.dart';

final searchScreenControllerProvider = StateNotifierProvider.autoDispose<
    SearchScreenController, SearchScreenUiState>(
  (ref) => SearchScreenController(
    ref.read(FetchRecentSearchesService.provider),
    ref.read(FetchSameLocationUsersService.provider),
    ref.read(SearchUsersService.provider),
    ref.read(SubscribeToCurrentUserService.provider),
  ),
);

class SearchScreenController extends StateNotifier<SearchScreenUiState> {
  final FetchSameLocationUsersService _fetchSameLocationUsers;
  final SearchUsersService _searchUsersService;
  final FetchRecentSearchesService _fetchRecentSearchesService;
  final SubscribeToCurrentUserService _subscribeToCurrentUserService;

  late LinxUser _currentUser;
  late UserSearchPage? _currentPage;
  List<SearchGroup> _groups = const [];

  SearchScreenController(
    this._fetchRecentSearchesService,
    this._fetchSameLocationUsers,
    this._searchUsersService,
    this._subscribeToCurrentUserService,
  ) : super(SearchScreenUiState(state: SearchState.loading)) {
    initialize();
  }

  void initialize() async {
    _subscribeToCurrentUserService.execute().listen((event) async {
      _currentUser = event;
      if (_groups.isEmpty) {
        _groups = await _fetchSameLocationUsers.execute(event.info);
        _setState(newState: SearchState.initial, groups: _groups);
      }
    });
  }

  void _load() => state = SearchScreenUiState(state: SearchState.loading);

  void onSearchGroupSelected(SearchGroup group) {
    _load();

    final users = group.users.toList();
    final subtitle = "Results for \"${group.category}\" (${users.length})";
    final page = UserSearchPage(users: users);

    _setState(newState: SearchState.results, page: page, subtitle: subtitle);
  }

  void onSearchInitiated() async {
    final recents = await _fetchRecentSearchesService.execute(_currentUser);
    _setState(newState: SearchState.searching, recents: recents);
  }

  void onSearchCompleted(String searchField) async {
    _load();
    if (searchField == "") {
      _setState(newState: SearchState.initial);
    } else {
      final page = await _searchUsersService.execute(
        _currentUser.info,
        searchField,
      );
      final length = _currentPage!.users.length;
      final subtitle = "Results for \"$searchField\" ($length)";
      _setState(newState: SearchState.results, page: page, subtitle: subtitle);
    }
  }

  void _setState({
    SearchState? newState,
    List<SearchGroup>? groups,
    UserSearchPage? page,
    List<String>? recents,
    String? subtitle,
  }) {
    state = SearchScreenUiState(
      state: newState ?? state.state,
      groups: groups ?? state.groups,
      results: page ?? state.results,
      recentSearches: recents ?? state.recentSearches,
      subtitle: subtitle ?? state.subtitle,
    );
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
