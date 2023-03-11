import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/match/domain/fetch_matches_service.dart';
import 'package:linx/features/app/match/domain/model/match.dart';
import 'package:linx/features/app/match/ui/model/matches_screen_state.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/user_service.dart';

final matchesScreenControllerProvider = StateNotifierProvider.autoDispose<
    MatchesScreenController, MatchesScreenUiState>(
  (ref) => MatchesScreenController(
    ref.read(FetchMatchesService.provider),
    ref.read(UserService.provider),
  ),
);

class MatchesScreenController extends StateNotifier<MatchesScreenUiState> {
  final FetchMatchesService _fetchMatchesService;
  final UserService _userService;

  late LinxUser _currentUser;

  MatchesScreenController(
    this._fetchMatchesService,
    this._userService,
  ) : super(MatchesScreenUiState()) {
    _initialize();
  }

  void _initialize() async {
    _currentUser = await _userService.fetchUser();
    final matches = await _fetchMatchesService.execute(_currentUser.info);
    state = MatchesScreenUiState(
      state: MatchesScreenState.results,
      matches: matches,
    );
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
