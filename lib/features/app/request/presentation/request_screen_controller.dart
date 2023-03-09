import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/match/domain/create_a_match_service.dart';
import 'package:linx/features/app/pitch/domain/fetch_requests_service.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/authentication/domain/log_out_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/user_service.dart';

final requestScreenControllerProvider =
    StateNotifierProvider.autoDispose<RequestScreenController, RequestScreenUiState?>(
  (ref) => RequestScreenController(
    ref.read(UserService.provider),
    ref.read(FetchRequestsService.provider),
    ref.read(CreateAMatchService.provider),
    ref.read(LogOutService.provider),
  ),
);

class RequestScreenController extends StateNotifier<RequestScreenUiState?> {
  final UserService _userService;
  final FetchRequestsService _fetchRequestsService;
  final CreateAMatchService _createAMatchService;
  final LogOutService _logOutService;

  late LinxUser _currentUser;

  RequestScreenController(
    this._userService,
    this._fetchRequestsService,
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

    if (requests.length < 5) {
      state = RequestScreenUiState(
        topRequests: requests.take(requests.length).toList(),
        currentUser: _currentUser,
      );
    } else {
      state = RequestScreenUiState(
        topRequests: requests.take(5).toList(),
        nextRequests: requests.getRange(5, requests.length).toList(),
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
}

class RequestScreenUiState {
  final List<Request> topRequests;
  final List<Request> nextRequests;
  final LinxUser currentUser;

  RequestScreenUiState({
    this.topRequests = const [],
    this.nextRequests = const [],
    this.currentUser = const LinxUser(uid: ""),
  });
}
