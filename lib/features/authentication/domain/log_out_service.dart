import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/data/auth_repository.dart';

class LogOutService {
  static final provider = Provider(
    (ref) => LogOutService(
      ref.read(AuthRepository.provider),
    ),
  );

  final AuthRepository _authRepository;

  LogOutService(this._authRepository);

  Future<void> execute() async {
    await _authRepository.logOut();
  }
}
