import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/pitch/data/pitch_repository.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/user_info.dart';

class SendRequestService {
  static final provider = Provider(
    (ref) => SendRequestService(
      ref.read(PitchRepository.provider),
      ref.read(SessionRepository.provider),
      ref.read(UserRepository.provider),
    ),
  );

  final PitchRepository _pitchRepository;
  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  SendRequestService(
    this._pitchRepository,
    this._sessionRepository,
    this._userRepository,
  );

  Future<void> execute(UserInfo receiver, String message) async {
    final senderId = _sessionRepository.userId;
    await _pitchRepository.sendPitch(
      senderId: senderId,
      receiverId: receiver.uid,
      message: message,
    );
    await _userRepository.addReceiverToPitchesTo(senderId, receiver.uid);
    await _userRepository.incrementNumberOfNewPitches(receiver.uid);
  }
}
