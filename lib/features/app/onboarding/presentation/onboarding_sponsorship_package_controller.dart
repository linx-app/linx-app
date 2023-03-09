import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/app/core/domain/sponsorship_package_service.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/user_info_service.dart';
import 'package:linx/features/user/domain/user_service.dart';

final onboardingSponsorshipPackageControllerProvider = StateNotifierProvider<
    OnboardingSponsorshipPackageController,
    OnboardingSponsorshipPackageUiState>((ref) {
  return OnboardingSponsorshipPackageController(
    ref.read(UserInfoService.provider),
    ref.read(UserService.provider),
    ref.read(SponsorshipPackageService.provider),
  );
});

class OnboardingSponsorshipPackageController
    extends StateNotifier<OnboardingSponsorshipPackageUiState> {
  final UserInfoService _userInfoService;
  final UserService _userService;
  final SponsorshipPackageService _sponsorshipPackageService;
  late LinxUser _user;

  OnboardingSponsorshipPackageController(
    this._userInfoService,
    this._userService,
    this._sponsorshipPackageService,
  ) : super(OnboardingSponsorshipPackageUiState(packages: [])) {
    fetchSponsorshipPackages();
  }

  Future<void> updateSponsorshipPackages(
    List<String> packageNames,
    List<String> ownBenefits,
    List<String> partnerBenefits,
  ) async {
    List<SponsorshipPackage> packages = [];

    for (var i = 0; i < packageNames.length; i++) {
      if (packageNames[i].isEmpty) continue;
      if (ownBenefits[i].isEmpty) continue;
      if (partnerBenefits[i].isEmpty) continue;

      packages.add(
        SponsorshipPackage(
            name: packageNames[i],
            ownBenefit: ownBenefits[i],
            partnerBenefit: partnerBenefits[i],
            user: _user,
        ),
      );
    }

    await _userInfoService.updateSponsorshipPackageCount(_user.uid, packages.length);
    await _sponsorshipPackageService.updateSponsorshipPackages(packages);
  }

  Future<void> fetchSponsorshipPackages() async {
    _user = await _userService.fetchUserProfile();

    if (_user.numberOfPackages == 0) {
      var firstPackage = SponsorshipPackage(user: _user);
      state = OnboardingSponsorshipPackageUiState(packages: [firstPackage]);
    } else {
      var packages = await _sponsorshipPackageService
          .fetchSponsorshipPackageByUser(_user.uid);
      state = OnboardingSponsorshipPackageUiState(
        packages: [...packages, SponsorshipPackage(user: _user)],
      );
    }
  }

  Future<void> onAddAnotherPressed() async {
    state = OnboardingSponsorshipPackageUiState(
        packages: [...state.packages, SponsorshipPackage(user: _user)]);
  }
}

class OnboardingSponsorshipPackageUiState {
  final List<SponsorshipPackage> packages;

  OnboardingSponsorshipPackageUiState({this.packages = const []});
}
