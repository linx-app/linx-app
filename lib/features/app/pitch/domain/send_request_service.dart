import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/pitch/data/model/pitch_dto.dart';
import 'package:linx/features/app/pitch/data/pitch_repository.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/domain/model/user_info.dart';

class SendRequestService {
  static final provider = Provider(
    (ref) => SendRequestService(
      ref.read(PitchRepository.provider),
      ref.read(SessionRepository.provider),
    ),
  );

  final PitchRepository _pitchRepository;
  final SessionRepository _sessionRepository;

  SendRequestService(this._pitchRepository, this._sessionRepository);

  Future<void> execute(UserInfo receiver, String message) async {
    final pitch = PitchDTO(
      createdDate: DateTime.now().millisecondsSinceEpoch,
      message: message,
      receiverId: receiver.uid,
      senderId: _sessionRepository.userId,
    );
    await _pitchRepository.sendPitch(pitch);
  }
}
