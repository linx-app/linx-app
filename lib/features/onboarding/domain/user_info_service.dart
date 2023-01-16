import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/data/session_repository.dart';
import 'package:linx/features/onboarding/ui/onboarding_chip_selection_screen.dart';
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

  Future<void> updateUserChips({
    required ChipSelectionScreenType type,
    required Set<String> chips,
  }) async {
    var uid = await _sessionRepository.getUserId();
    switch (type) {
      case ChipSelectionScreenType.clubInterests:
      case ChipSelectionScreenType.businessInterests:
        await _userRepository.updateUserInterests(uid, chips);
        break;
      case ChipSelectionScreenType.clubDescriptors:
        await _userRepository.updateUserDescriptors(uid, chips);
        break;
    }
  }
}
