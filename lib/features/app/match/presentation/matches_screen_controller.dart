import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/presentation/app_bottom_nav_screen_controller.dart';
import 'package:linx/features/app/match/domain/subscribe_to_matches_service.dart';
import 'package:linx/features/app/match/domain/model/match.dart';
import 'package:linx/features/app/match/ui/model/matches_screen_state.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

final matchesScreenControllerProvider = StateNotifierProvider.autoDispose<
    MatchesScreenController, MatchesScreenUiState>(
  (ref) => MatchesScreenController(
    ref.read(SubscribeToMatchesService.provider),
    ref.watch(currentUserProvider),
  ),
);

class MatchesScreenController extends StateNotifier<MatchesScreenUiState> {
  final SubscribeToMatchesService _subscribeToMatchesService;
  final LinxUser? _currentUser;

  MatchesScreenController(
    this._subscribeToMatchesService,
    this._currentUser,
  ) : super(MatchesScreenUiState()) {
    _initialize();
  }

  void _initialize() async {
    if (_currentUser == null) return;
    _subscribeToMatchesService.execute(_currentUser!.info).listen((event) {
      state = MatchesScreenUiState(
        state: MatchesScreenState.results,
        matches: event,
      );
    });
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
