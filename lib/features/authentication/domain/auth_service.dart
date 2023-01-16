import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/data/auth_repository.dart';
import 'package:linx/features/authentication/data/session_repository.dart';
import 'package:linx/features/authentication/domain/models/auth_response.dart';
import 'package:linx/features/authentication/domain/models/user_type.dart';

class AuthService {
  static final provider = Provider((ref) {
    return AuthService(
        ref.read(AuthRepository.provider),
        ref.read(SessionRepository.provider)
    );
  });

  final AuthRepository _authRepository;
  final SessionRepository _sessionRepository;

  AuthService(this._authRepository, this._sessionRepository);

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
    UserType userType,
  ) async {
    AuthResponse res = await _authRepository.createUserWithEmailAndPassword(
      email,
      password,
      userType.name,
    );

    if (res.type() == AuthResponseType.SUCCESS) {
      AuthSuccess success = res as AuthSuccess;
      _sessionRepository.setUserId(success.userId);
      _sessionRepository.setUserType(userType.name);
    } else {
      print("User sign up failed!!");
    }
  }
}
