import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/match/domain/create_a_match_service.dart';
import 'package:linx/features/app/pitch/domain/fetch_requests_service.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/authentication/domain/log_out_service.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/core/domain/sponsorship_package_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/user_service.dart';

final requestScreenControllerProvider =
    StateNotifierProvider.autoDispose<RequestScreenController, RequestScreenUiState?>(
  (ref) => RequestScreenController(
    ref.read(UserService.provider),
    ref.read(FetchRequestsService.provider),
    ref.read(SponsorshipPackageService.provider),
    ref.read(CreateAMatchService.provider),
    ref.read(LogOutService.provider),
  ),
);

class RequestScreenController extends StateNotifier<RequestScreenUiState?> {
  final UserService _userService;
  final FetchRequestsService _fetchRequestsService;
  final SponsorshipPackageService _sponsorshipPackageService;
  final CreateAMatchService _createAMatchService;
  final LogOutService _logOutService;

  late LinxUser _currentUser;

  RequestScreenController(
    this._userService,
    this._fetchRequestsService,
    this._sponsorshipPackageService,
    this._createAMatchService,
    this._logOutService,
  ) : super(null) {
    initialize();
  }

  void initialize() async {
    _currentUser = await _userService.fetchUserProfile();
    fetchRequestsForBusinesses();
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
      state = RequestScreenUiState(
        topRequests: requests.take(requests.length).toList(),
        topMatchPercentages: percentages.take(percentages.length).toList(),
        topPackages: allPackages.take(allPackages.length).toList(),
        currentUser: _currentUser,
      );
    } else {
      state = RequestScreenUiState(
        topRequests: requests.take(5).toList(),
        topMatchPercentages: percentages.take(5).toList(),
        nextRequests: requests.getRange(5, requests.length).toList(),
        nextMatchPercentages:
            percentages.getRange(5, percentages.length).toList(),
        topPackages: allPackages.take(5).toList(),
        nextPackages: allPackages.getRange(5, allPackages.length).toList(),
        currentUser: _currentUser,
      );
    }
  }

  void onImInterestedPressed({required LinxUser club}) async {
    _createAMatchService.execute(business: _currentUser, club: club);
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

class RequestScreenUiState {
  final List<double> topMatchPercentages;
  final List<double> nextMatchPercentages;
  final List<List<SponsorshipPackage>> topPackages;
  final List<List<SponsorshipPackage>> nextPackages;
  final List<Request> topRequests;
  final List<Request> nextRequests;
  final LinxUser currentUser;

  RequestScreenUiState({
    this.topMatchPercentages = const [],
    this.nextMatchPercentages = const [],
    this.topRequests = const [],
    this.nextRequests = const [],
    this.topPackages = const [],
    this.nextPackages = const [],
    this.currentUser = const LinxUser(uid: ""),
  });
}
