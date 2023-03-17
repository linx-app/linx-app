import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/match/domain/create_a_match_service.dart';
import 'package:linx/features/app/pitch/domain/fetch_requests_service.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/app/request/domain/view_request_service.dart';
import 'package:linx/features/authentication/domain/log_out_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/features/user/domain/subscribe_to_current_user_service.dart';

final requestScreenControllerProvider = StateNotifierProvider.autoDispose<
    RequestScreenController, RequestScreenUiState?>(
  (ref) => RequestScreenController(
      ref.read(SubscribeToIncomingPitchesService.provider),
      ref.read(CreateAMatchService.provider),
      ref.read(LogOutService.provider),
      ref.read(ViewRequestService.provider),
      ref.read(SubscribeToCurrentUserService.provider)),
);

class RequestScreenController extends StateNotifier<RequestScreenUiState?> {
  final SubscribeToIncomingPitchesService _subscribeToIncomingPitchesService;
  final CreateAMatchService _createAMatchService;
  final LogOutService _logOutService;
  final ViewRequestService _viewRequestService;
  final SubscribeToCurrentUserService _subscribeToCurrentUserService;

  late LinxUser _currentUser;
  late List<Request> _requests;

  RequestScreenController(
    this._subscribeToIncomingPitchesService,
    this._createAMatchService,
    this._logOutService,
    this._viewRequestService,
    this._subscribeToCurrentUserService,
  ) : super(null) {
    _subscribeToCurrentUserService.execute().listen((event) {
      _currentUser = event;
      _subscribeToRequests();
    });
  }

  void _subscribeToRequests() {
    _subscribeToIncomingPitchesService.execute(_currentUser).listen((event) {
      _requests = event;
      _setRequestState();
    });
  }

  void onImInterestedPressed({required UserInfo club}) async {
    _createAMatchService.execute(business: _currentUser.info, club: club);
    _requests.removeWhere((element) => element.sender.info.uid == club.uid);
    _setRequestState();
  }

  void _setRequestState() {
    if (_requests.length < 5) {
      state = RequestScreenUiState(
        topRequests: _requests.take(_requests.length).toList(),
        currentUser: _currentUser.info,
      );
    } else {
      state = RequestScreenUiState(
        topRequests: _requests.take(5).toList(),
        nextRequests: _requests.getRange(5, _requests.length).toList(),
        currentUser: _currentUser.info,
      );
    }
  }

  void logOut() async {
    _logOutService.execute();
  }

  void onRequestViewed(Request request) async {
    await _viewRequestService.execute(request);
  }
}

class RequestScreenUiState {
  final List<Request> topRequests;
  final List<Request> nextRequests;
  final UserInfo currentUser;

  RequestScreenUiState({
    this.topRequests = const [],
    this.nextRequests = const [],
    this.currentUser = const UserInfo(uid: ""),
  });
}
