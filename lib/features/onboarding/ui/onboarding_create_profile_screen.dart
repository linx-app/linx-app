import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/image_upload/ui/image_uploader.dart';
import 'package:linx/features/onboarding/presentation/onboarding_create_profile_controller.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_profile_image.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_profile_image_carousel.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';
import 'package:linx/utils/ui_extensions.dart';

class OnboardingCreateProfileScreen extends OnboardingView {
  @override
  late final VoidCallback onScreenCompleted;

  @override
  final String pageTitle = "Create your profile";
  final _carouselCurrentPage = StateProvider((ref) => 0);
  final TextEditingController _bioController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> pages = _mapUrlsToPages(ref);

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

  @override
  void onBackPressed() {
    // TODO: implement onBackPressed
  }

  @override
  bool onNextPressed(WidgetRef ref) {
    return true;
  }

  void _onFileSelected(File file, WidgetRef ref) {
    ref.read(onboardingCreateProfileController.notifier).onFileSelected(file);
  }

  Container _buildSectionTitle(String title) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
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

  Center _buildLoadingPage() {
    return const Center(
      widthFactor: 1,
      heightFactor: 1,
      child: CircularProgressIndicator(
        backgroundColor: LinxColors.background,
        color: LinxColors.green,
      ),
    );
  }

  List<Widget> _mapUrlsToPages(WidgetRef ref) {
    return ref.watch(onboardingCreateProfileController).map((url) {
      if (url == null) {
        return ImageUploader((file) => _onFileSelected(file, ref));
      } else if (url == "Loading") {
        return _buildLoadingPage();
      } else {
        return OnboardingProfileImage(url: url);
      }
    }).toList();
  }

  Container _buildBiographyForm() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
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
}
