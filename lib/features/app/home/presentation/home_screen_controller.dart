import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/home/domain/match_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/user_service.dart';

final homeScreenControllerProvider =
    StateNotifierProvider<HomeScreenController, HomeScreenUiState>((ref) {
  return HomeScreenController(
    ref.read(UserService.provider),
    ref.read(MatchService.provider),
  );
});

class HomeScreenController extends StateNotifier<HomeScreenUiState> {
  final UserService userService;
  final MatchService matchService;

  HomeScreenController(
    this.userService,
    this.matchService,
  ) : super(HomeScreenUiState());

  void initialize(LinxUser currentUser) async {
    var matches = await matchService
        .fetchUsersWithMatchingInterests(currentUser.interests);
    var percentages = matches.map((e) {
      return _calculateMatchPercentage(currentUser, e);
    }).toList();

    if (matches.length < 5) {
      state = HomeScreenUiState(
        topMatches: matches.take(matches.length).toList(),
        topMatchPercentages: percentages.take(percentages.length).toList(),
      );
    } else {
      state = HomeScreenUiState(
        topMatches: matches.take(5).toList(),
        topMatchPercentages: percentages.take(5).toList(),
        nextMatches: matches.getRange(5, matches.length).toList(),
        nextMatchPercentages: percentages.getRange(5, percentages.length).toList(),
      );
    }
  }

  double _calculateMatchPercentage(LinxUser a, LinxUser b) {
    return (a.interests.intersection(b.interests).length /
            a.interests.length) *
        100;
  }
}

class HomeScreenUiState {
  final List<LinxUser> topMatches;
  final List<LinxUser> nextMatches;
  final List<double> topMatchPercentages;
  final List<double> nextMatchPercentages;

  HomeScreenUiState({
    this.topMatches = const [],
    this.nextMatches = const [],
    this.topMatchPercentages = const [],
    this.nextMatchPercentages = const [],
  });
}
