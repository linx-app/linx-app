import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/app/pitch/domain/send_request_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/user_service.dart';

final sendAPitchScreenControllerProvider =
    StateNotifierProvider.autoDispose<SendAPitchScreenController, SendAPitchUiState>(
  (ref) => SendAPitchScreenController(
    ref.read(SendRequestService.provider),
    ref.read(UserService.provider)
  ),
);

class SendAPitchScreenController extends StateNotifier<SendAPitchUiState> {
  final SendRequestService _sendRequestService;
  final UserService _userService;

  SendAPitchScreenController(this._sendRequestService, this._userService)
      : super(SendAPitchUiState.idle);

  Future<void> sendPitch({
    required LinxUser receiver,
    required String message,
  }) async {
    state = SendAPitchUiState.loading;
    var sender = await _userService.fetchUserProfile();
    var request = Request(
      sender: sender,
      receiver: receiver,
      message: message,
      createdAt: DateTime.now(),
    );

    await _sendRequestService.execute(request);

    state = SendAPitchUiState.finished;
  }
}

enum SendAPitchUiState { idle, loading, finished }
