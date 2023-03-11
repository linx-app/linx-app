import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/match/domain/fetch_matches_service.dart';
import 'package:linx/features/app/match/domain/model/match.dart';
import 'package:linx/features/app/pitch/domain/fetch_outgoing_requests_service.dart';
import 'package:linx/features/app/pitch/ui/model/pitches_screen_state.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/user_service.dart';

final pitchesScreenControllerProvider = StateNotifierProvider.autoDispose<
    PitchesScreenController, PitchesScreenUiState>(
  (ref) => PitchesScreenController(
    ref.read(FetchMatchesService.provider),
    ref.read(UserService.provider),
    ref.read(FetchOutgoingRequestsService.provider),
  ),
);

class PitchesScreenController extends StateNotifier<PitchesScreenUiState> {
  final FetchMatchesService _fetchMatchesService;
  final FetchOutgoingRequestsService _fetchOutgoingRequestsService;
  final UserService _userService;

  late LinxUser _currentUser;
  late List<Match> _incoming;
  late List<Request> _outgoing;

  PitchesScreenController(
    this._fetchMatchesService,
    this._userService,
    this._fetchOutgoingRequestsService,
  ) : super(PitchesScreenUiState()) {
    initialize();
  }

  void initialize() async {
    _currentUser = await _userService.fetchUser();
    _incoming = await _fetchMatchesService.execute(_currentUser.info);
    _outgoing = await _fetchOutgoingRequestsService.execute(_currentUser);
    _setStateOutgoing();
  }

  void onTogglePressed(int index) {
    index == 0 ? _setStateOutgoing() : _setStateIncoming();
  }

  void _setStateOutgoing() {
    state = PitchesScreenUiState(
      state: PitchesScreenState.outgoing,
      outgoingPitches: _outgoing,
    );
  }

  void _setStateIncoming() {
    state = PitchesScreenUiState(
      state: PitchesScreenState.incoming,
      incomingMatches: _incoming,
    );
  }
}

class PitchesScreenUiState {
  final PitchesScreenState state;
  final List<Match> incomingMatches;
  final List<Request> outgoingPitches;

  PitchesScreenUiState({
    this.state = PitchesScreenState.loading,
    this.incomingMatches = const [],
    this.outgoingPitches = const [],
  });
}
