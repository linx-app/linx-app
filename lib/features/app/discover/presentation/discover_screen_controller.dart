import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/match/domain/match_service.dart';
import 'package:linx/features/authentication/domain/log_out_service.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/core/domain/sponsorship_package_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/user_service.dart';

final discoverScreenControllerProvider =
    StateNotifierProvider.autoDispose<DiscoverScreenController, DiscoverScreenUiState?>(
  (ref) => DiscoverScreenController(
    ref.read(UserService.provider),
    ref.read(MatchService.provider),
    ref.read(SponsorshipPackageService.provider),
    ref.read(LogOutService.provider),
  ),
);

class DiscoverScreenController extends StateNotifier<DiscoverScreenUiState?> {
  final UserService _userService;
  final MatchService _matchService;
  final SponsorshipPackageService _sponsorshipPackageService;
  final LogOutService _logOutService;

  late LinxUser _currentUser;

  DiscoverScreenController(
    this._userService,
    this._matchService,
    this._sponsorshipPackageService,
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
    var percentages = matches.map((e) {
      return _calculateMatchPercentage(_currentUser, e);
    }).toList();

    var allPackages = <List<SponsorshipPackage>>[];
    for (var user in matches) {
      var packages = await _fetchSponsorshipPackages(user);
      allPackages.add(packages);
    }

    if (matches.length < 5) {
      state = DiscoverScreenUiState(
        topMatches: matches.take(matches.length).toList(),
        topMatchPercentages: percentages.take(percentages.length).toList(),
        topPackages: allPackages.take(allPackages.length).toList(),
        currentUser: _currentUser,
      );
    } else {
      state = DiscoverScreenUiState(
        topMatches: matches.take(5).toList(),
        topMatchPercentages: percentages.take(5).toList(),
        nextMatches: matches.getRange(5, matches.length).toList(),
        nextMatchPercentages:
            percentages.getRange(5, percentages.length).toList(),
        topPackages: allPackages.take(5).toList(),
        nextPackages: allPackages.getRange(5, allPackages.length).toList(),
        currentUser: _currentUser,
      );
    }
  }

  void logOut() async {
    _logOutService.execute();
  }

  Future<List<SponsorshipPackage>> _fetchSponsorshipPackages(
      LinxUser user) async {
    if (user.numberOfPackages == 0) {
      return [];
    } else {
      var packages = await _sponsorshipPackageService
          .fetchSponsorshipPackageByUser(user.uid);
      return packages;
    }
  }

  double _calculateMatchPercentage(LinxUser a, LinxUser b) {
    return (a.interests.intersection(b.interests).length / a.interests.length) *
        100;
  }
}

class DiscoverScreenUiState {
  final List<LinxUser> topMatches;
  final List<LinxUser> nextMatches;
  final List<double> topMatchPercentages;
  final List<double> nextMatchPercentages;
  final List<List<SponsorshipPackage>> topPackages;
  final List<List<SponsorshipPackage>> nextPackages;
  final LinxUser currentUser;

  DiscoverScreenUiState({
    this.topMatches = const [],
    this.nextMatches = const [],
    this.topMatchPercentages = const [],
    this.nextMatchPercentages = const [],
    this.topPackages = const [],
    this.nextPackages = const [],
    this.currentUser = const LinxUser(uid: ""),
  });
}
