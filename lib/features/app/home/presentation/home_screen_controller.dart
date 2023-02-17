import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/home/domain/match_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/user_service.dart';

final homeScreenControllerProvider = StateNotifierProvider<HomeScreenController, HomeScreenUiState>((ref) {
  return HomeScreenController(
    ref.read(UserService.provider),
    ref.read(MatchService.provider),
  );
});

class HomeScreenController extends StateNotifier<HomeScreenUiState> {
  late LinxUser currentUser;
  final UserService userService;
  final MatchService matchService;

  HomeScreenController(this.userService, this.matchService): super(HomeScreenUiState()) {
    initialize();
  }

  void initialize() async {
    currentUser = await userService.fetchUserProfile();
    var matches = await matchService.fetchUserInterests(currentUser.interests);
    var matchPercentages = matches.map((e) => (currentUser.interests.intersection(e.descriptors).length / currentUser.interests.length) * 100).toList();
    state = HomeScreenUiState(currentUser: currentUser, matches: matches, matchPercentages: matchPercentages);
  }
}

class HomeScreenUiState {
  final LinxUser? currentUser;
  final List<LinxUser> matches;
  final List<double> matchPercentages;

  HomeScreenUiState({this.currentUser, this.matches = const [], this.matchPercentages = const []});
}