import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/app/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/app/core/domain/sponsorship_package_service.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/features/user/domain/user_service.dart';

final onboardingReviewProfileControllerProvider = StateNotifierProvider<
    OnboardingReviewProfileController, OnboardingReviewProfileUiState>((ref) {
  return OnboardingReviewProfileController(
    ref.read(UserService.provider),
    ref.read(SponsorshipPackageService.provider),
  );
});

class OnboardingReviewProfileController
    extends StateNotifier<OnboardingReviewProfileUiState> {
  final UserService _userService;
  final SponsorshipPackageService _sponsorshipPackageService;

  OnboardingReviewProfileController(
    this._userService,
    this._sponsorshipPackageService,
  ) : super(OnboardingReviewProfileUiState());

  Future<void> fetchUser() async {
    var user = await _userService.fetchUserInfo();
    var packages = await _sponsorshipPackageService
        .fetchSponsorshipPackageByUser(user.uid);
    state = OnboardingReviewProfileUiState(user: user, packages: packages);
  }
}

class OnboardingReviewProfileUiState {
  final UserInfo user;
  final List<SponsorshipPackage> packages;

  OnboardingReviewProfileUiState({
    this.user = const UserInfo(uid: ""),
    this.packages = const [],
  });
}
