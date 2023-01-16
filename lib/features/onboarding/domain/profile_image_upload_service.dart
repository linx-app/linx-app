import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/data/session_repository.dart';
import 'package:linx/features/user/user_repository.dart';

class OnboardingProfileImageUploadService {
  static final provider = Provider<OnboardingProfileImageUploadService>((ref) {
    return OnboardingProfileImageUploadService(
        ref.read(SessionRepository.provider),
        ref.read(UserRepository.provider)
    );
  });

  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  OnboardingProfileImageUploadService(this._sessionRepository, this._userRepository);

  Future<void> uploadProfileImage(String url) async {
    var uid = await _sessionRepository.getUserId();
    await _userRepository.updateProfileImages(uid, url);
  }
}