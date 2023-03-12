import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/presentation/app_bottom_nav_screen_controller.dart';
import 'package:linx/features/app/core/ui/model/search_state.dart';
import 'package:linx/features/app/match/domain/match_service.dart';
import 'package:linx/features/app/search/domain/model/user_search_page.dart';
import 'package:linx/features/app/search/domain/search_users_service.dart';
import 'package:linx/features/authentication/domain/log_out_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';

final discoverScreenControllerProvider = StateNotifierProvider.autoDispose<
    DiscoverScreenController, DiscoverScreenUiState>((ref) {
  final currentUser = ref.watch(currentUserProvider);
  return DiscoverScreenController(
    currentUser,
    ref.read(updateCurrentUserProvider),
    ref.read(MatchService.provider),
    ref.read(LogOutService.provider),
    ref.read(SearchUsersService.provider),
  );
});

class DiscoverScreenController extends StateNotifier<DiscoverScreenUiState> {
  final MatchService _matchService;
  final LogOutService _logOutService;
  final SearchUsersService _searchUsersService;
  final LinxUser? _currentUser;
  final Function() _updateCurrentUser;

  late List<LinxUser> _matches;

  DiscoverScreenController(
    this._currentUser,
    this._updateCurrentUser,
    this._matchService,
    this._logOutService,
    this._searchUsersService,
  ) : super(DiscoverScreenUiState()) {
    initialize();
  }

  void initialize() async {
    if (_currentUser == null) return;
    _matches =
        await _matchService.fetchUsersWithMatchingInterests(_currentUser!.info);
    _loadMatches();
  }

  void _load() {
    if (_currentUser == null) return;
    state = DiscoverScreenUiState(
      state: SearchState.loading,
      isCurrentUserClub: _currentUser!.info.isClub(),
    );
  }

  void onSearchInitiated() {
    if (_currentUser == null) return;
    state = DiscoverScreenUiState(
      state: SearchState.searching,
      recents: _currentUser!.info.searches,
      isCurrentUserClub: _currentUser!.info.isClub(),
    );
  }

  void onSearchCompleted(String search) async {
    _load();
    if (_currentUser == null) return;
    if (search.isEmpty) {
      _loadMatches();
    } else {
      final results = await _searchUsersService.execute(_currentUser!.info, search);
      _updateCurrentUser.call();

      final length = results.users.length;
      final subtitle = "Results for \"$search\" ($length)";

      state = DiscoverScreenUiState(
        state: SearchState.results,
        results: results,
        subtitle: subtitle,
        isCurrentUserClub: _currentUser!.info.isClub(),
      );
    }
  }

  void _loadMatches() {
    if (_currentUser == null) return;
    if (_matches.length < 5) {
      state = DiscoverScreenUiState(
        state: SearchState.initial,
        topMatches: _matches.take(_matches.length).toList(),
        isCurrentUserClub: _currentUser!.info.isClub(),
      );
    } else {
      state = DiscoverScreenUiState(
        state: SearchState.initial,
        topMatches: _matches.take(5).toList(),
        nextMatches: _matches.getRange(5, _matches.length).toList(),
        isCurrentUserClub: _currentUser!.info.isClub(),
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
