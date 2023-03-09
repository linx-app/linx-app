import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/match/domain/match_service.dart';
import 'package:linx/features/authentication/domain/log_out_service.dart';
import 'package:linx/features/user/domain/model/display_user.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/user_service.dart';

final discoverScreenControllerProvider =
    StateNotifierProvider.autoDispose<DiscoverScreenController, DiscoverScreenUiState?>(
  (ref) => DiscoverScreenController(
    ref.read(UserService.provider),
    ref.read(MatchService.provider),
    ref.read(LogOutService.provider),
  ),
);

class DiscoverScreenController extends StateNotifier<DiscoverScreenUiState?> {
  final UserService _userService;
  final MatchService _matchService;
  final LogOutService _logOutService;

  late LinxUser _currentUser;

  DiscoverScreenController(
    this._userService,
    this._matchService,
    this._logOutService,
  ) : super(null) {
    initialize();
  }

  void initialize() async {
    _currentUser = await _userService.fetchUserProfile();
    fetchMatches();
  }

  void fetchMatches() async {
    var matches =
        await _matchService.fetchUsersWithMatchingInterests(_currentUser);

    if (matches.length < 5) {
      state = DiscoverScreenUiState(
        topMatches: matches.take(matches.length).toList(),
        currentUser: _currentUser,
      );
    } else {
      state = DiscoverScreenUiState(
        topMatches: matches.take(5).toList(),
        nextMatches: matches.getRange(5, matches.length).toList(),
        currentUser: _currentUser,
      );
    }
  }

  void logOut() async {
    _logOutService.execute();
  }
}

class DiscoverScreenUiState {
  final List<DisplayUser> topMatches;
  final List<DisplayUser> nextMatches;
  final LinxUser currentUser;

  DiscoverScreenUiState({
    this.topMatches = const [],
    this.nextMatches = const [],
    this.currentUser = const LinxUser(uid: ""),
  });
}
