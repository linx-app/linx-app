import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/data/session_repository.dart';

class AuthService {
  static final provider = Provider((ref) {
    return AuthService(
        ref.read(SessionRepository.provider)
    );
  });

  final SessionRepository _sessionRepository;

  AuthService(this._sessionRepository);

  Stream<bool> isUserLoggedIn() => _sessionRepository.isUserLoggedIn();

  Future<bool> isFirstTimeInApp() async => _sessionRepository.isFirstTimeInApp();
}
