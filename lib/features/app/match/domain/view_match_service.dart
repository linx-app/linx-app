import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/match/data/match_repository.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';

class ViewMatchService {
  static final provider = Provider(
    (ref) => ViewMatchService(
      ref.read(MatchRepository.provider),
      ref.read(UserRepository.provider),
      ref.read(SessionRepository.provider),
    ),
  );

  final MatchRepository _matchRepository;
  final UserRepository _userRepository;
  final SessionRepository _sessionRepository;

  ViewMatchService(
    this._matchRepository,
    this._userRepository,
    this._sessionRepository,
  );

  Future<void> execute(String matchId) async {
    final userId = _sessionRepository.userId;
    await _matchRepository.changeIsNewStatus(matchId);
    await _userRepository.removeNewMatchId(userId, matchId);
  }
}
