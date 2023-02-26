import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/home/domain/model/request.dart';
import 'package:linx/features/app/home/domain/send_request_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

final sendAPitchScreenControllerProvider =
    StateNotifierProvider<SendAPitchScreenController, SendAPitchUiState>(
  (ref) => SendAPitchScreenController(
    ref.read(SendRequestService.provider),
  ),
);

class SendAPitchScreenController extends StateNotifier<SendAPitchUiState> {
  final SendRequestService _sendRequestService;

  SendAPitchScreenController(this._sendRequestService)
      : super(SendAPitchUiState.idle);

  Future<void> sendPitch({
    required LinxUser receiver,
    required LinxUser sender,
    required String message,
  }) async {
    state = SendAPitchUiState.loading;

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
