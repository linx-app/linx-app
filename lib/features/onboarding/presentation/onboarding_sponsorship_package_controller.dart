import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/user/domain/user_info_service.dart';

final onboardingSponsorshipPackageControllerProvider = StateNotifierProvider<
    OnboardingSponsorshipPackageController,
    OnboardingSponsorshipPackageUiState>((ref) {
  return OnboardingSponsorshipPackageController(
    ref.read(UserInfoService.provider),
  );
});

class OnboardingSponsorshipPackageController
    extends StateNotifier<OnboardingSponsorshipPackageUiState> {
  final UserInfoService _userInfoService;

  OnboardingSponsorshipPackageController(this._userInfoService)
      : super(OnboardingSponsorshipPackageUiState());

  Future<void> updateSponsorshipPackages(
    int numberOfPackages,
    List<String> packageNames,
    List<String> ownBenefits,
    List<String> partnerBenefits,
  ) async {
    List<SponsorshipPackage> packages = [];

    for (var i = 0; i < numberOfPackages; i++) {
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
}

class OnboardingSponsorshipPackageUiState {
  final List<SponsorshipPackage> packages;

  OnboardingSponsorshipPackageUiState({this.packages = const []});
}
