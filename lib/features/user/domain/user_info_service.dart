import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/data/session_repository.dart';
import 'package:linx/features/user/data/user_repository.dart';

class UserInfoService {
  final SessionRepository _sessionRepository;
  final UserRepository _userRepository;

  static final provider = Provider((ref) {
    return UserInfoService(
      ref.read(SessionRepository.provider),
      ref.read(UserRepository.provider),
    );
  });

  UserInfoService(
    this._sessionRepository,
    this._userRepository,
  );

  Future<void> updateUserInfo({
    String? name,
    String? phoneNumber,
    String? location,
  }) async {
    var uid = await _sessionRepository.userId;
    await _userRepository.updateUserInfo(
      uid: uid,
      name: name,
      phoneNumber: phoneNumber,
      location: location,
    );
  }

  Future<void> updateUserBiography(String biography) async {
    var uid = await _sessionRepository.userId;
    await _userRepository.updateUserBiography(uid, biography);
  }

  Future<void> updateSponsorshipPackageCount(String userId, int count) async {
    await _userRepository.updateUserSponsorshipPackageCount(userId, count);
  }
}
