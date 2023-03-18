import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/ui/model/sort_item.dart';
import 'package:linx/features/app/match/domain/model/match.dart';
import 'package:linx/features/app/match/domain/subscribe_to_matches_service.dart';
import 'package:linx/features/app/match/domain/view_match_service.dart';
import 'package:linx/features/app/match/ui/model/matches_screen_state.dart';
import 'package:linx/features/user/domain/subscribe_to_current_user_service.dart';

final matchesScreenControllerProvider = StateNotifierProvider.autoDispose<
    MatchesScreenController, MatchesScreenUiState>(
  (ref) => MatchesScreenController(
    ref.read(SubscribeToMatchesService.provider),
    ref.read(ViewMatchService.provider),
    ref.read(SubscribeToCurrentUserService.provider),
  ),
);

class MatchesScreenController extends StateNotifier<MatchesScreenUiState> {
  final SubscribeToMatchesService _subscribeToMatchesService;
  final ViewMatchService _viewMatchService;
  final SubscribeToCurrentUserService _subscribeToCurrentUserService;

  List<Match> _matches = const [];

  MatchesScreenController(
    this._subscribeToMatchesService,
    this._viewMatchService,
    this._subscribeToCurrentUserService,
  ) : super(MatchesScreenUiState()) {
    _initialize();
  }

  void _initialize() async {
    _subscribeToCurrentUserService.execute().listen((event) {
      _subscribeToMatchesService.execute(event.info).listen((event) {
        _matches = event;
        state = MatchesScreenUiState(
          state: MatchesScreenState.results,
          matches: event,
        );
      });
    });
  }

  void onViewMatch(String matchId) async {
    await _viewMatchService.execute(matchId);
  }

  void onSortPressed(SortItem item) async {
    final temp = _matches;
    switch (item) {
      case SortItem.match:
        temp.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SortItem.alphabetical:
        temp.sort((a, b) =>
            a.user.info.displayName.compareTo(b.user.info.displayName));
        break;
    }
    print("Sorted!");
    state = MatchesScreenUiState(
      state: MatchesScreenState.results,
      matches: temp,
    );
  }

  void onSearchMatches(String search) async {
    if (search.isEmpty) {
      state = MatchesScreenUiState(
        state: MatchesScreenState.results,
        matches: _matches,
      );
    } else {
      final filtered = _matches.where((e) {
        final info = e.user.info;
        final name = info.displayName.toLowerCase().contains(search);
        final descriptors = info.descriptors.contains(search);
        final interests = info.interests.contains(search);
        final location = info.location.toLowerCase().contains(search);
        return name || descriptors || interests || location;
      }).toList();

      state = MatchesScreenUiState(
        state: MatchesScreenState.results,
        matches: filtered,
      );
    }
  }
}

class MatchesScreenUiState {
  final MatchesScreenState state;
  final List<Match> matches;

  MatchesScreenUiState({
    this.matches = const [],
    this.state = MatchesScreenState.loading,
  });
}
