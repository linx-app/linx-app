import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/onboarding/ui/model/onboarding_nav.dart';
import 'package:linx/features/image_upload/ui/image_uploader.dart';
import 'package:linx/features/app/onboarding/presentation/onboarding_create_profile_controller.dart';
import 'package:linx/features/app/onboarding/ui/widgets/onboarding_profile_image.dart';
import 'package:linx/features/app/onboarding/ui/widgets/onboarding_profile_image_carousel.dart';
import 'package:linx/features/app/onboarding/ui/widgets/onboarding_view.dart';
import 'package:linx/utils/ui_extensions.dart';

class OnboardingCreateProfileScreen extends OnboardingView {
  final _carouselCurrentPage = StateProvider((ref) => 0);
  final TextEditingController _bioController = TextEditingController();

  OnboardingCreateProfileScreen({
    required super.onScreenCompleted,
  }): super(pageTitle: "Create profile");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(onboardingCreateProfileController);
    List<Widget> pages = _mapUrlsToPages(state.profileImageUrls, ref);
    _bioController.text = state.biography;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildOnboardingStepTitle(context),
        _buildSectionTitle("Add photos"),
        _buildProfileImageSection(pages, ref),
        _buildSectionTitle("Biography"),
        _buildBiographyForm(),
        _buildSectionTitle("Social media"),
      ],
    );
  }

  void _onFileSelected(File file, WidgetRef ref) {
    ref.read(onboardingCreateProfileController.notifier).onFileSelected(file);
  }

  Container _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title.capitalize(),
        style: const TextStyle(
          color: LinxColors.backButtonGrey,
          fontSize: 17.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<Widget> _mapUrlsToPages(List<String?> profileImageUrls, WidgetRef ref) {
    return profileImageUrls.map((url) {
      if (url == null) {
        return ImageUploader((file) => _onFileSelected(file, ref));
      } else if (url == "Loading") {
        return LinxLoadingSpinner();
      } else {
        return OnboardingProfileImage(url: url);
      }
    }).toList();
  }

  Container _buildBiographyForm() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: LinxTextField(
        label: "Biography",
        controller: _bioController,
        minLines: 4,
        maxLines: 4,
      ),
    );
  }

  OnboardingProfileImageCarousel _buildProfileImageSection(
    List<Widget> pages,
    WidgetRef ref,
  ) {
    return OnboardingProfileImageCarousel(
      padding: const EdgeInsets.symmetric(vertical: 12),
      onPageChanged: (page) {},
      pages: pages,
      controller: PageController(viewportFraction: 0.90),
      dotPosition: ref.watch(_carouselCurrentPage),
    );
  }

  @override
  void onScreenPushed(WidgetRef ref) {
    ref.read(onboardingCreateProfileController.notifier).fetchUserInfo();
  }

  @override
  bool onNextPressed(WidgetRef ref) {
    ref.read(onboardingCreateProfileController.notifier).updateUserInfo(
        _bioController.text
    );
    onScreenCompleted(OnboardingNav.next);
    return true;
  }
}
