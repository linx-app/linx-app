import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/data/auth_repository.dart';
import 'package:linx/features/authentication/domain/models/auth_response.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';
import 'package:linx/features/user/domain/model/user_type.dart';

class SignUpService {
  static final provider = Provider((ref) {
    return SignUpService(
      ref.read(AuthRepository.provider),
      ref.read(SessionRepository.provider),
      ref.read(UserRepository.provider),
    );
  });

  final AuthRepository _authRepository;
  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  SignUpService(
      this._authRepository, this._sessionRepository, this._userRepository);

  Future<AuthResponse> createUserWithEmailAndPassword(
    String email,
    String password,
    UserType userType,
  ) async {
    AuthResponse res = await _authRepository.createUserWithEmailAndPassword(
      email,
      password,
      userType.name,
    );

    if (res is AuthSuccess) {
      await _userRepository.initializeUser(
        uid: res.userId,
        email: email,
        type: userType.name,
      );
      var user = await _userRepository.fetchUserProfile(res.userId);
      _sessionRepository.saveUser(user);
    }

    return res;
  }
}
