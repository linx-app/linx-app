import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/data/auth_repository.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';

class LogOutService {
  static final provider = Provider(
    (ref) => LogOutService(
      ref.read(AuthRepository.provider),
      ref.read(UserRepository.provider),
      ref.read(SessionRepository.provider),
    ),
  );

  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final SessionRepository _sessionRepository;

  LogOutService(this._authRepository, this._userRepository, this._sessionRepository);

  Future<void> execute() async {
    var userId = _sessionRepository.userId;
    await _sessionRepository.deleteUser();
    await _userRepository.removeFCMToken(userId);
    await _authRepository.logOut();
  }
}
