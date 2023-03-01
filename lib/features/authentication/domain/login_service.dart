import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/data/auth_repository.dart';
import 'package:linx/features/authentication/domain/models/auth_response.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';

class LogInService {
  static final provider = Provider((ref) {
    return LogInService(
      ref.read(AuthRepository.provider),
      ref.read(SessionRepository.provider),
      ref.read(UserRepository.provider),
    );
  });

  final AuthRepository _authRepository;
  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  LogInService(
    this._authRepository,
    this._sessionRepository,
    this._userRepository,
  );

  Future<AuthResponse> attemptLogIn(String email, String password) async {
    var res = await _authRepository.signInWithEmailAndPassword(email, password);

    if (res is AuthSuccess) {
      var user = await _userRepository.fetchUserProfile(res.userId);
      await _sessionRepository.saveUser(user);
      await _userRepository.addFCMToken(res.userId);
    }

    return res;
  }
}
