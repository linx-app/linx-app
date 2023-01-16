import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/image_upload/domain/image_upload_service.dart';
import 'package:linx/features/onboarding/domain/profile_image_upload_service.dart';

final onboardingCreateProfileController =
    StateNotifierProvider<OnboardingCreateProfileController, List<String?>>(
        (ref) {
  return OnboardingCreateProfileController(
    ref.read(ImageUploadService.provider),
    ref.read(OnboardingProfileImageUploadService.provider),
  );
});

class OnboardingCreateProfileController extends StateNotifier<List<String?>> {
  final ImageUploadService _imageUploadService;
  final OnboardingProfileImageUploadService _profileImageUploadService;

  OnboardingCreateProfileController(
      this._imageUploadService, this._profileImageUploadService)
      : super([null]);

  Future<void> onFileSelected(File file) async {
    var length = state.length;
    var imageName = "profile_image_${length - 1}";
    _addLoading();
    var url = await _imageUploadService.uploadImage(file, imageName);
    if (url != null) {
      await _profileImageUploadService.uploadProfileImage(url);
      _replaceLoading(url);
    }
  }

  void _addLoading() {
    state = [...state.sublist(0, state.length - 1), "Loading", null];
  }

  void _replaceLoading(String url) {
    state = [
      for (final String? link in state)
        if (link == "Loading") url else link
    ];
  }
}
