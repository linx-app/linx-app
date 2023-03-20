import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/match/domain/model/match.dart';
import 'package:linx/features/app/match/domain/subscribe_to_matches_service.dart';
import 'package:linx/features/app/pitch/domain/subscribe_to_outgoing_pitches_service.dart';
import 'package:linx/features/app/pitch/ui/model/pitches_screen_state.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/user/domain/subscribe_to_current_user_service.dart';

final pitchesScreenControllerProvider = StateNotifierProvider.autoDispose<
    PitchesScreenController, PitchesScreenUiState>(
  (ref) => PitchesScreenController(
    ref.read(SubscribeToMatchesService.provider),
    ref.read(SubscribeToOutgoingPitchesService.provider),
    ref.read(SubscribeToCurrentUserService.provider),
  ),
);

class PitchesScreenController extends StateNotifier<PitchesScreenUiState> {
  final SubscribeToMatchesService _subscribeToMatchesService;
  final SubscribeToOutgoingPitchesService _subscribeToOutgoingPitchesService;
  final SubscribeToCurrentUserService _subscribeToCurrentUserService;

  late List<Match> _incoming;
  late List<Request> _outgoing;

  PitchesScreenController(
    this._subscribeToMatchesService,
    this._subscribeToOutgoingPitchesService,
    this._subscribeToCurrentUserService,
  ) : super(PitchesScreenUiState()) {
    initialize();
  }

  void initialize() async {
    _subscribeToCurrentUserService.execute().listen((event) {
      _subscribeToMatchesService.execute(event.info).listen((event) {
        _incoming = event;
      });
      _subscribeToOutgoingPitchesService.execute(event).listen((event) {
        _outgoing = event;
        _setStateOutgoing();
      });
    });
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
