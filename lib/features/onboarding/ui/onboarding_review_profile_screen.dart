import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/linx_chip.dart';
import 'package:linx/common/sponsorship_package_card.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_profile_image.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_profile_image_carousel.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';

class OnboardingReviewProfileScreen extends OnboardingView {
  @override
  final pageTitle = "Review profile";

  final imageCarouselPageProvider = StateProvider((ref) => 0.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        buildOnboardingStepTitle(context),
        _buildProfileImageSection(ref),
        ..._buildWhoAreYouSection(),
        _buildChipsSection(),
        _buildBiographySection(),
        _buildSectionTitle("Looking for"),
        _buildChipsSection(),
        _buildSectionTitle("Packages"),
        _buildPackagesSection(),
        SizedBox(height: 32)
      ],
    );
  }

  @override
  void onBackPressed() {
    // TODO: implement onBackPressed
  }

  OnboardingProfileImageCarousel _buildProfileImageSection(WidgetRef ref) {
    var dotPosition = ref.read(imageCarouselPageProvider.notifier);
    List<Widget> pages = [
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300",
      "https://picsum.photos/200/300"
    ].map((url) {
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
      dotPosition: ref.watch(imageCarouselPageProvider).toInt(),
      pages: pages,
      controller: PageController(viewportFraction: 0.925),
    );
  }

  List<Widget> _buildWhoAreYouSection() {
    return [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                "User display name",
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
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: const Text(
          "User location",
          style: TextStyle(
            color: LinxColors.locationTextGrey,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
      ),
      // TODO: social media
    ];
  }

  Container _buildChipsSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      alignment: Alignment.centerLeft,
      child: Wrap(
        children: [
          LinxChip(
            label: "Chip 1",
            onChipSelected: (str) {},
            isSelected: false,
          ),
        ],
      ),
    );
  }

  Container _buildBiographySection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: const [
          Flexible(
            child: Text(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ",
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

  Container _buildPackagesSection() {
    return Container(
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SponsorshipPackageCard(
              package: SponsorshipPackage(
                  name: "Gold Tier",
                  ownBenefit: "\$1000",
                  partnerBenefit: "Logo"),
            ),
            SponsorshipPackageCard(
              package: SponsorshipPackage(
                  name: "Gold Tier",
                  ownBenefit: "\$1000",
                  partnerBenefit: "Logo"),
            ),
          ],
        ),
      ),
    );
  }

  void _onEditWhoAreYouPressed() {}

  void _onEditPhotoOrBiographyPressed() {}
}
