import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';

class UserInterestDescriptorService {
  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  static final provider = Provider((ref) {
    return UserInterestDescriptorService(
      ref.read(SessionRepository.provider),
      ref.read(UserRepository.provider),
    );
  });

  UserInterestDescriptorService(this._sessionRepository, this._userRepository);

  Future<void> updateUserInterests({required Set<String> interests}) async {
    var uid = await _sessionRepository.userId;
    await _userRepository.updateUserInterests(uid, interests);
  }

  Future<void> updateUserDescriptors({required Set<String> descriptors}) async {
    var uid = await _sessionRepository.userId;
    await _userRepository.updateUserDescriptors(uid, descriptors);
  }
}