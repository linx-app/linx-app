import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/match/domain/match_service.dart';
import 'package:linx/features/app/search/domain/model/user_search_page.dart';
import 'package:linx/features/app/search/domain/search_users_service.dart';
import 'package:linx/features/authentication/domain/log_out_service.dart';
import 'package:linx/features/app/core/ui/model/search_state.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/features/user/domain/user_service.dart';

final discoverScreenControllerProvider = StateNotifierProvider.autoDispose<
    DiscoverScreenController, DiscoverScreenUiState>(
  (ref) => DiscoverScreenController(
    ref.read(UserService.provider),
    ref.read(MatchService.provider),
    ref.read(LogOutService.provider),
    ref.read(SearchUsersService.provider),
  ),
);

class DiscoverScreenController extends StateNotifier<DiscoverScreenUiState> {
  final UserService _userService;
  final MatchService _matchService;
  final LogOutService _logOutService;
  final SearchUsersService _searchUsersService;

  late List<LinxUser> _matches;
  late UserInfo _currentUser;

  DiscoverScreenController(
    this._userService,
    this._matchService,
    this._logOutService,
    this._searchUsersService,
  ) : super(DiscoverScreenUiState()) {
    initialize();
  }

  void initialize() async {
    _currentUser = await _userService.fetchUserInfo();
    _fetchMatches();
  }

  void _fetchMatches() async {
    _matches =
        await _matchService.fetchUsersWithMatchingInterests(_currentUser);
    _loadMatches();
  }

  void _load() => state = DiscoverScreenUiState(
        state: SearchState.loading,
        isCurrentUserClub: _currentUser.isClub(),
      );

  void onSearchInitiated() {
    state = DiscoverScreenUiState(
      state: SearchState.searching,
      recents: _currentUser.searches,
      isCurrentUserClub: _currentUser.isClub(),
    );
  }

  void onSearchCompleted(String search) async {
    _load();
    if (search.isEmpty) {
      _loadMatches();
    } else {
      final results = await _searchUsersService.execute(_currentUser, search);
      _currentUser = await _userService.fetchUserInfo();

      final length = results.users.length;
      final subtitle = "Results for \"$search\" ($length)";

      state = DiscoverScreenUiState(
        state: SearchState.results,
        results: results,
        subtitle: subtitle,
        isCurrentUserClub: _currentUser.isClub(),
      );
    }
  }

  void _loadMatches() {
    if (_matches.length < 5) {
      state = DiscoverScreenUiState(
        state: SearchState.initial,
        topMatches: _matches.take(_matches.length).toList(),
        isCurrentUserClub: _currentUser.isClub(),
      );
    } else {
      state = DiscoverScreenUiState(
        state: SearchState.initial,
        topMatches: _matches.take(5).toList(),
        nextMatches: _matches.getRange(5, _matches.length).toList(),
        isCurrentUserClub: _currentUser.isClub(),
      );
    }
  }

  void logOut() async {
    _logOutService.execute();
  }
}

class DiscoverScreenUiState {
  final SearchState state;
  final List<LinxUser> topMatches;
  final List<LinxUser> nextMatches;
  final bool isCurrentUserClub;
  final List<String> recents;
  final UserSearchPage? results;
  final String subtitle;

  DiscoverScreenUiState({
    this.state = SearchState.initial,
    this.topMatches = const [],
    this.nextMatches = const [],
    this.isCurrentUserClub = true,
    this.recents = const [],
    this.subtitle = "",
    this.results,
  });
}
