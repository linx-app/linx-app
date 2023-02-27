import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/home/domain/fetch_requests_service.dart';
import 'package:linx/features/app/home/domain/match_service.dart';
import 'package:linx/features/app/home/domain/model/request.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/core/domain/sponsorship_package_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_type.dart';
import 'package:linx/features/user/domain/user_service.dart';

final homeScreenControllerProvider =
    StateNotifierProvider<HomeScreenController, HomeScreenUiState>((ref) {
  return HomeScreenController(
    ref.read(MatchService.provider),
    ref.read(FetchRequestsService.provider),
    ref.read(SponsorshipPackageService.provider),
    ref.read(UserService.provider)
  );
});

class HomeScreenController extends StateNotifier<HomeScreenUiState> {
  final UserService _userService;
  final MatchService _matchService;
  final FetchRequestsService _fetchRequestsService;
  final SponsorshipPackageService _sponsorshipPackageService;
  late LinxUser _currentUser;

  HomeScreenController(
    this._matchService,
    this._fetchRequestsService,
    this._sponsorshipPackageService,
    this._userService,
  ) : super(HomeScreenUiState()) {
     initialize();
  }

  void initialize() async {
    _currentUser = await _userService.fetchUserProfile();
    if (_currentUser.type == UserType.club) {
      fetchMatchesForClubs();
    } else {
      fetchRequestsForBusinesses();
    }
  }

  void fetchMatchesForClubs() async {
    var matches = await _matchService
        .fetchUsersWithMatchingInterests(_currentUser.interests);
    var percentages = matches.map((e) {
      return _calculateMatchPercentage(_currentUser, e);
    }).toList();

    var allPackages = <List<SponsorshipPackage>>[];
    for (var user in matches) {
      var packages = await _fetchSponsorshipPackages(user);
      allPackages.add(packages);
    }

    if (matches.length < 5) {
      state = HomeScreenUiState(
        topMatches: matches.take(matches.length).toList(),
        topMatchPercentages: percentages.take(percentages.length).toList(),
        topPackages: allPackages.take(allPackages.length).toList(),
      );
    } else {
      state = HomeScreenUiState(
        topMatches: matches.take(5).toList(),
        topMatchPercentages: percentages.take(5).toList(),
        nextMatches: matches.getRange(5, matches.length).toList(),
        nextMatchPercentages:
            percentages.getRange(5, percentages.length).toList(),
        topPackages: allPackages.take(5).toList(),
        nextPackages: allPackages.getRange(5, allPackages.length).toList(),
      );
    }
  }

  void fetchRequestsForBusinesses() async {
    var requests =
        await _fetchRequestsService.fetchRequestsWithReceiver(_currentUser);
    var percentages = requests.map((e) {
      return _calculateMatchPercentage(_currentUser, e.sender);
    }).toList();

    var allPackages = <List<SponsorshipPackage>>[];
    for (var r in requests) {
      var packages = await _fetchSponsorshipPackages(r.sender);
      allPackages.add(packages);
    }

    if (requests.length < 5) {
      state = HomeScreenUiState(
        topRequests: requests.take(requests.length).toList(),
        topMatchPercentages: percentages.take(percentages.length).toList(),
        topPackages: allPackages.take(allPackages.length).toList(),
      );
    } else {
      state = HomeScreenUiState(
        topRequests: requests.take(5).toList(),
        topMatchPercentages: percentages.take(5).toList(),
        nextRequests: requests.getRange(5, requests.length).toList(),
        nextMatchPercentages:
            percentages.getRange(5, percentages.length).toList(),
        topPackages: allPackages.take(5).toList(),
        nextPackages: allPackages.getRange(5, allPackages.length).toList(),
      );
    }
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

class HomeScreenUiState {
  final List<LinxUser> topMatches;
  final List<LinxUser> nextMatches;
  final List<double> topMatchPercentages;
  final List<double> nextMatchPercentages;
  final List<List<SponsorshipPackage>> topPackages;
  final List<List<SponsorshipPackage>> nextPackages;
  final List<Request> topRequests;
  final List<Request> nextRequests;
  final LinxUser currentUser;

  HomeScreenUiState({
    this.topMatches = const [],
    this.nextMatches = const [],
    this.topMatchPercentages = const [],
    this.nextMatchPercentages = const [],
    this.topRequests = const [],
    this.nextRequests = const [],
    this.topPackages = const [],
    this.nextPackages = const [],
    this.currentUser = const LinxUser(uid: ""),
  });
}
