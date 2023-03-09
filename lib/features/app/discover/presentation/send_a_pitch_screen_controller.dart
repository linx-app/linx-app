import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/pitch/domain/send_request_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

final sendAPitchScreenControllerProvider =
    StateNotifierProvider.autoDispose<SendAPitchScreenController, SendAPitchUiState>(
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
    required String message,
  }) async {
    state = SendAPitchUiState.loading;
    await _sendRequestService.execute(receiver, message);
    state = SendAPitchUiState.finished;
  }
}

enum SendAPitchUiState { idle, loading, finished }
