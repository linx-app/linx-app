import 'dart:io';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/image_upload/ui/image_uploader.dart';
import 'package:linx/features/onboarding/presentation/onboarding_create_profile_controller.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_profile_image.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';
import 'package:linx/utils/ui_extensions.dart';

class OnboardingCreateProfileScreen extends OnboardingView {
  OnboardingCreateProfileController? _controller;

  @override
  late final VoidCallback onScreenCompleted;

  @override
  final String pageTitle = "Create your profile";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _controller = ref.read(OnboardingCreateProfileController.provider);
    List<Widget> pages =
        _mapUrlsToPages(ref.watch(_controller!.carouselPagesProvider));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildOnboardingStepTitle(context),
        _buildSectionTitle("Add photos"),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          height: 250,
          child: PageView(
            padEnds: true,
            controller: _controller!.carouselController,
            children: [...pages],
            onPageChanged: (page) {
              ref.read(_controller!.carouselCurrentPage.notifier).state = page;
            },
          ),
        ),
        if (pages.length > 1)
          Center(
            child: DotsIndicator(
              dotsCount: pages.
              length,
              position: ref.watch(_controller!.carouselCurrentPage).toDouble(),
            ),
          ),
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
  bool onNextPressed() {
    return true;
  }

  void _onFileSelected(File file) {
    _controller!.onFileSelected(file);
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

  List<Widget> _mapUrlsToPages(List<String?> urls) {
    return urls.map((url) {
      if (url == null) {
        return ImageUploader(_onFileSelected);
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
        controller: _controller!.bioController,
        minLines: 4,
        maxLines: 4,
      ),
    );
  }
}
