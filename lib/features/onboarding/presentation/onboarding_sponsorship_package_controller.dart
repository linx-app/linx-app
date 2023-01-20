import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/user/domain/user_info_service.dart';
import 'package:linx/features/user/domain/user_service.dart';

final onboardingSponsorshipPackageControllerProvider = StateNotifierProvider<
    OnboardingSponsorshipPackageController,
    OnboardingSponsorshipPackageUiState>((ref) {
  return OnboardingSponsorshipPackageController(
    ref.read(UserInfoService.provider),
    ref.read(UserService.provider),
  );
});

class OnboardingSponsorshipPackageController
    extends StateNotifier<OnboardingSponsorshipPackageUiState> {
  final UserInfoService _userInfoService;
  final UserService _userService;

  OnboardingSponsorshipPackageController(this._userInfoService, this._userService)
      : super(OnboardingSponsorshipPackageUiState(packages: [SponsorshipPackage()]));

  Future<void> updateSponsorshipPackages(
    List<String> packageNames,
    List<String> ownBenefits,
    List<String> partnerBenefits,
  ) async {
    List<SponsorshipPackage> packages = [];

    for (var i = 0; i < state.packages.length; i++) {
      packages.add(
        SponsorshipPackage(
          name: packageNames[i],
          ownBenefit: ownBenefits[i],
          partnerBenefit: partnerBenefits[i],
        ),
      );
    }

    await _userInfoService.updateSponsorshipPackages(packages);
  }

  Future<void> fetchSponsorshipPackages() async {
    var user = await _userService.fetchUserProfile();
    state = OnboardingSponsorshipPackageUiState(packages: user.packages);
  }

  Future<void> onAddAnotherPressed() async {
    state = OnboardingSponsorshipPackageUiState(
      packages: [...state.packages, SponsorshipPackage()]
    );
  }
}

class OnboardingSponsorshipPackageUiState {
  final List<SponsorshipPackage> packages;

  OnboardingSponsorshipPackageUiState({this.packages = const []});
}
