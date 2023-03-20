import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/image_upload/domain/image_upload_service.dart';
import 'package:linx/features/user/domain/user_info_service.dart';
import 'package:linx/features/user/domain/user_profile_image_service.dart';
import 'package:linx/features/user/domain/user_service.dart';

final onboardingCreateProfileController = StateNotifierProvider<
    OnboardingCreateProfileController, OnboardingCreateProfileUiState>((ref) {
  return OnboardingCreateProfileController(
    ref.read(ImageUploadService.provider),
    ref.read(UserProfileImageService.provider),
    ref.read(UserService.provider),
    ref.read(UserInfoService.provider),
  );
});

class OnboardingCreateProfileController
    extends StateNotifier<OnboardingCreateProfileUiState> {
  final ImageUploadService _imageUploadService;
  final UserProfileImageService _userProfileImageService;
  final UserService _userService;
  final UserInfoService _userInfoService;

  OnboardingCreateProfileController(
    this._imageUploadService,
    this._userProfileImageService,
    this._userService,
    this._userInfoService,
  ) : super(OnboardingCreateProfileUiState());

  Future<void> updateUserInfo(String biography) async {
    await _userInfoService.updateUserBiography(biography);
    if (state.profileImageUrls.length == 1) {
      await _userProfileImageService
          .uploadProfileImage("https://picsum.photos/200/500");
    }
  }

  Future<void> fetchUserInfo() async {
    var user = await _userService.fetchUserInfo();
    state = OnboardingCreateProfileUiState(
      profileImageUrls: [...user.profileImageUrls, null],
      biography: user.biography,
    );
  }

  Future<void> onFileSelected(File file) async {
    var length = state.profileImageUrls.length;
    var imageName = "profile_image_${length - 1}";
    _addLoading();
    var url = await _imageUploadService.uploadImage(file, imageName);
    if (url != null) {
      await _userProfileImageService.uploadProfileImage(url);
      _replaceLoading(url);
    }
  }

  void _addLoading() {
    var images = state.profileImageUrls;
    state = OnboardingCreateProfileUiState(
      profileImageUrls: [
        ...images.sublist(0, images.length - 1),
        "Loading",
        null
      ],
      biography: state.biography,
    );
  }

  void _replaceLoading(String url) {
    var images = state.profileImageUrls;
    state = OnboardingCreateProfileUiState(
      profileImageUrls: [
        for (final String? link in images)
          if (link == "Loading") url else link
      ],
      biography: state.biography,
    );
  }
}

class OnboardingCreateProfileUiState {
  final List<String?> profileImageUrls;
  final String biography;

  OnboardingCreateProfileUiState({
    this.profileImageUrls = const <String?>[null],
    this.biography = "",
  });
}
