import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/pitch/data/pitch_repository.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';

class ViewRequestService {
  static final provider = Provider((ref) =>
      ViewRequestService(ref.read(PitchRepository.provider),
        ref.read(SessionRepository.provider),
        ref.read(UserRepository.provider),));

  final PitchRepository _pitchRepository;
  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  ViewRequestService(this._pitchRepository, this._sessionRepository,
      this._userRepository,);

  Future<void> execute(Request request) async {
    if (!request.hasBeenViewed) {
      final userId = _sessionRepository.userId;
      await _pitchRepository.changeViewedFlag(request.id);
      await _userRepository.decrementNumberOfNewPitches(userId);
    }
  }
}