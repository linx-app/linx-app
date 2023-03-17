import 'package:flutter_riverpod/flutter_riverpod.dart';
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
}

class MatchesScreenUiState {
  final MatchesScreenState state;
  final List<Match> matches;

  MatchesScreenUiState({
    this.matches = const [],
    this.state = MatchesScreenState.loading,
  });
}
