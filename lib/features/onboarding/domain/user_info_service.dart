import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/data/session_repository.dart';
import 'package:linx/features/user/user_repository.dart';

class OnboardingUserInfoService {
  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  static final provider = Provider((ref) {
    return OnboardingUserInfoService(
      ref.read(SessionRepository.provider),
      ref.read(UserRepository.provider),
    );
  });

  OnboardingUserInfoService(this._sessionRepository, this._userRepository);

  Future<void> updateUserInfo({
    String? name,
    String? phoneNumber,
    String? location,
  }) async {
    var uid = await _sessionRepository.getUserId();
    await _userRepository.updateUserInfo(
      uid: uid,
      name: name,
      phoneNumber: phoneNumber,
      location: location,
    );
  }
}
