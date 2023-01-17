import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';

class UserProfileImageService {
  static final provider = Provider((ref) {
    return UserProfileImageService(
        ref.read(SessionRepository.provider),
        ref.read(UserRepository.provider)
    );
  });

  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  UserProfileImageService(this._sessionRepository, this._userRepository);

  Future<void> uploadProfileImage(String url) async {
    var uid = await _sessionRepository.getUserId();
    await _userRepository.updateProfileImages(uid, url);
  }
}