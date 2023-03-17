import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/presentation/app_bottom_nav_screen_controller.dart';
import 'package:linx/features/app/match/domain/subscribe_to_matches_service.dart';
import 'package:linx/features/app/match/domain/model/match.dart';
import 'package:linx/features/app/pitch/domain/subscribe_to_outgoing_pitches_service.dart';
import 'package:linx/features/app/pitch/ui/model/pitches_screen_state.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

final pitchesScreenControllerProvider = StateNotifierProvider.autoDispose<
    PitchesScreenController, PitchesScreenUiState>(
  (ref) => PitchesScreenController(
    ref.watch(currentUserProvider),
    ref.read(SubscribeToMatchesService.provider),
    ref.read(SubscribeToOutgoingPitchesService.provider),
  ),
);

class PitchesScreenController extends StateNotifier<PitchesScreenUiState> {
  final SubscribeToMatchesService _subscribeToMatchesService;
  final SubscribeToOutgoingPitchesService _subscribeToOutgoingPitchesService;
  final LinxUser? _currentUser;

  late List<Match> _incoming;
  late List<Request> _outgoing;

  PitchesScreenController(
    this._currentUser,
    this._subscribeToMatchesService,
    this._subscribeToOutgoingPitchesService,
  ) : super(PitchesScreenUiState()) {
    initialize();
  }

  void initialize() async {
    if (_currentUser == null) return;
    _subscribeToMatchesService.execute(_currentUser!.info).listen((event) {
      _incoming = event;
    });
    _subscribeToOutgoingPitchesService.execute(_currentUser!).listen((event) {
      _outgoing = event;
    });
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
