import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/domain/user_info_service.dart';

final onboardingBasicInfoControllerProvider = StateNotifierProvider<OnboardingBasicInfoController, OnboardingBasicInfoUiState>((ref) {
  var service = ref.watch(UserInfoService.provider);
  return OnboardingBasicInfoController(service);
});

class OnboardingBasicInfoController
    extends StateNotifier<OnboardingBasicInfoUiState> {
  final UserInfoService _onboardingUserInfoService;

  OnboardingBasicInfoController(this._onboardingUserInfoService)
      : super(OnboardingBasicInfoUiState());

  Future<void> onPageComplete(
    String name,
    String phoneNumber,
    String location,
  ) async {
    await _onboardingUserInfoService.updateUserInfo(
      name: name,
      phoneNumber: phoneNumber,
      location: location,
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
