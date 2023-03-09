import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/domain/user_info_service.dart';
import 'package:linx/features/user/domain/user_service.dart';

final onboardingBasicInfoControllerProvider = StateNotifierProvider<
    OnboardingBasicInfoController,
    OnboardingBasicInfoUiState>((ref) {
  var userInfoService = ref.watch(UserInfoService.provider);
  var userService = ref.watch(UserService.provider);
  return OnboardingBasicInfoController(userInfoService, userService);
});

class OnboardingBasicInfoController
    extends StateNotifier<OnboardingBasicInfoUiState> {
  final UserInfoService _onboardingUserInfoService;
  final UserService _userService;

  OnboardingBasicInfoController(
      this._onboardingUserInfoService,
      this._userService,
  ) : super(OnboardingBasicInfoUiState());

  Future<void> onPageComplete(String name,
      String phoneNumber,
      String location,) async {
    await _onboardingUserInfoService.updateUserInfo(
      name: name,
      phoneNumber: phoneNumber,
      location: location,
    );
  }

  Future<void> fetchBasicInfo() async {
    var user = await _userService.fetchUserInfo();
    state = OnboardingBasicInfoUiState(
      name: user.displayName,
      phoneNumber: user.phoneNumber,
      location: user.location
    );
  }
}

class OnboardingBasicInfoUiState {
  final String name;
  final String phoneNumber;
  final String location;

  OnboardingBasicInfoUiState({
    this.name = "",
    this.phoneNumber = "",
    this.location = "",
  });
}
