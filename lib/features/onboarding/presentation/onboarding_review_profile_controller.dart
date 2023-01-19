import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/user_service.dart';

final onboardingReviewProfileControllerProvider =
    StateNotifierProvider<OnboardingReviewProfileController, LinxUser>((ref) {
  return OnboardingReviewProfileController(
    ref.read(UserService.provider)
  );
});

class OnboardingReviewProfileController extends StateNotifier<LinxUser> {
  OnboardingReviewProfileController(this._userService) : super(LinxUser(uid: ""));

  final UserService _userService;

  Future<void> fetchUser() async {
    state = await _userService.fetchUserProfile();
  }
}
