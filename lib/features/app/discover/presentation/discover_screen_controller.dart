import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/ui/model/search_state.dart';
import 'package:linx/features/app/match/domain/match_service.dart';
import 'package:linx/features/app/search/domain/fetch_recent_searches_service.dart';
import 'package:linx/features/app/search/domain/model/user_search_page.dart';
import 'package:linx/features/app/search/domain/search_users_service.dart';
import 'package:linx/features/authentication/domain/log_out_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/features/user/domain/subscribe_to_current_user_service.dart';

final discoverScreenControllerProvider = StateNotifierProvider.autoDispose<
    DiscoverScreenController, DiscoverScreenUiState>((ref) {
  return DiscoverScreenController(
    ref.read(MatchService.provider),
    ref.read(LogOutService.provider),
    ref.read(SearchUsersService.provider),
    ref.read(FetchRecentSearchesService.provider),
    ref.read(SubscribeToCurrentUserService.provider),
  );
});

class DiscoverScreenController extends StateNotifier<DiscoverScreenUiState> {
  final MatchService _matchService;
  final LogOutService _logOutService;
  final SearchUsersService _searchUsersService;
  final FetchRecentSearchesService _fetchRecentSearchesService;
  final SubscribeToCurrentUserService _subscribeToCurrentUserService;

  late LinxUser _currentUser;

  List<LinxUser> _matches = const [];

  DiscoverScreenController(
    this._matchService,
    this._logOutService,
    this._searchUsersService,
    this._fetchRecentSearchesService,
    this._subscribeToCurrentUserService,
  ) : super(DiscoverScreenUiState()) {
    initialize();
  }

  void initialize() async {
    _subscribeToCurrentUserService.execute().listen((event) {
      _currentUser = event;
      if (_matches.isEmpty) {
        _matchService.execute(event.info).listen((event) {
          _matches = event;
          _loadMatches();
        });
      }
    });
  }

  void _load() => _setState(newState: SearchState.loading);

  void onSearchInitiated() async {
    final recents = await _fetchRecentSearchesService.execute(_currentUser);
    _setState(newState: SearchState.searching, recents: recents);
  }

  void onSearchCompleted(String search) async {
    _load();
    if (search.isEmpty) {
      _loadMatches();
    } else {
      final results = await _searchUsersService.execute(
        _currentUser.info,
        search,
      );
      final length = results.users.length;
      final subtitle = "Results for \"$search\" ($length)";

      _setState(
        newState: SearchState.results,
        page: results,
        subtitle: subtitle,
      );
    }
  }

  void _loadMatches() {
    if (_matches.length < 5) {
      _setState(
        newState: SearchState.initial,
        topMatches: _matches.take(_matches.length).toList(),
        nextMatches: const [],
      );
    } else {
      _setState(
        newState: SearchState.initial,
        topMatches: _matches.take(5).toList(),
        nextMatches: _matches.getRange(5, _matches.length).toList(),
      );
    }
  }

  void logOut() async {
    _logOutService.execute();
  }

  void _setState({
    SearchState? newState,
    List<LinxUser>? topMatches,
    List<LinxUser>? nextMatches,
    UserSearchPage? page,
    List<String>? recents,
    String? subtitle,
  }) {
    state = DiscoverScreenUiState(
      state: newState ?? state.state,
      topMatches: topMatches ?? state.topMatches,
      nextMatches: nextMatches ?? state.nextMatches,
      isCurrentUserClub: _currentUser.info.isClub(),
      results: page ?? state.results,
      recents: recents ?? state.recents,
      subtitle: subtitle ?? state.subtitle,
    );
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
