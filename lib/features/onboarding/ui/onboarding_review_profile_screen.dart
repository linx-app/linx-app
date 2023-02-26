import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/linx_chip.dart';
import 'package:linx/common/sponsorship_package_card.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/onboarding/presentation/onboarding_review_profile_controller.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_profile_image.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_profile_image_carousel.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

class OnboardingReviewProfileScreen extends OnboardingView {
  final _imageCarouselPageProvider = StateProvider((ref) => 0.0);

  OnboardingReviewProfileScreen({
    required super.onScreenCompleted,
  }) : super(pageTitle: "Review profile");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(onboardingReviewProfileControllerProvider);

    var descriptorChips = state.user.descriptors.map((e) {
      return LinxChip(
        label: e,
        onChipSelected: (str) {},
        isSelected: false,
      );
    });

    var interestChips = state.user.interests.map((e) {
      return LinxChip(
        label: e,
        onChipSelected: (str) {},
        isSelected: false,
      );
    });

    return Column(
      children: [
        buildOnboardingStepTitle(context),
        _buildProfileImageSection(ref, state.user),
        ..._buildWhoAreYouSection(state.user),
        _buildChipsSection(descriptorChips),
        _buildBiographySection(state.user.biography),
        _buildSectionTitle("Looking for"),
        _buildChipsSection(interestChips),
        _buildSectionTitle("Packages"),
        _buildPackagesSection(state.packages),
        SizedBox(height: 32)
      ],
    );
  }

  OnboardingProfileImageCarousel _buildProfileImageSection(
    WidgetRef ref,
    LinxUser user,
  ) {
    var dotPosition = ref.read(_imageCarouselPageProvider.notifier);
    List<Widget> pages = user.profileImageUrls.map((url) {
      return OnboardingProfileImage(
        url: url,
        alignment: Alignment.topRight,
        child: IconButton(
          iconSize: 22,
          icon: const Icon(
            Icons.edit,
            color: LinxColors.white,
          ),
          onPressed: _onEditPhotoOrBiographyPressed,
        ),
      );
    }).toList();

    return OnboardingProfileImageCarousel(
      onPageChanged: (page) {
        dotPosition.state = page.toDouble();
      },
      dotPosition: ref.watch(_imageCarouselPageProvider).toInt(),
      pages: pages,
      controller: PageController(viewportFraction: 0.925),
    );
  }

  List<Widget> _buildWhoAreYouSection(LinxUser user) {
    return [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Text(
                user.displayName,
                style: LinxTextStyles.subtitle,
              ),
            ),
            IconButton(
              iconSize: 22,
              icon: const Icon(
                Icons.edit,
                color: LinxColors.editIconButtonGrey,
              ),
              onPressed: _onEditWhoAreYouPressed,
            )
          ],
        ),
      ),
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          user.location,
          style: const TextStyle(
            color: LinxColors.locationTextGrey,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
      // TODO: social media
    ];
  }

  Container _buildChipsSection(Iterable<LinxChip> chips) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.centerLeft,
      child: Wrap(children: [...chips]),
    );
  }

  Container _buildBiographySection(String biography) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Flexible(
            child: Text(
              biography,
              style: LinxTextStyles.regular,
            ),
          ),
        ],
      ),
    );
  }

  Container _buildSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: const TextStyle(
                  color: LinxColors.subtitleGrey,
                  fontWeight: FontWeight.w600,
                  fontSize: 17),
            ),
          ),
          IconButton(
            iconSize: 22,
            icon: const Icon(
              Icons.edit,
              color: LinxColors.editIconButtonGrey,
            ),
            onPressed: _onEditWhoAreYouPressed,
          )
        ],
      ),
    );
  }

  SingleChildScrollView _buildPackagesSection(
      List<SponsorshipPackage> packages) {
    var packageCards = packages.map((e) => SponsorshipPackageCard(package: e));

    return SingleChildScrollView(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      child: Row(children: [...packageCards]),
    );
  }

  void _onEditWhoAreYouPressed() {}

  void _onEditPhotoOrBiographyPressed() {}

  @override
  void onScreenPushed(WidgetRef ref) {
    ref.read(onboardingReviewProfileControllerProvider.notifier).fetchUser();
  }
}
