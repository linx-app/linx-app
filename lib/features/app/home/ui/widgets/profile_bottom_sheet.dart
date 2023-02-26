import 'package:flutter/material.dart';
import 'package:linx/common/buttons/linx_close_button.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/common/linx_chip.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/home/domain/model/request.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/core/ui/sponsorship_package_carousel.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class ProfileBottomSheet extends StatelessWidget {
  final TextStyle _subHeadingStyle = const TextStyle(
    fontWeight: FontWeight.w600,
    color: LinxColors.subtitleGrey,
    fontSize: 17,
  );
  final TextStyle _regularStyle = const TextStyle(
    color: LinxColors.chipTextGrey,
    fontSize: 16,
  );
  final LinxUser user;
  final int matchPercentage;
  final VoidCallback? onXPressed;
  final Request? request;
  final List<SponsorshipPackage> packages;

  const ProfileBottomSheet({
    super.key,
    required this.user,
    required this.matchPercentage,
    this.request,
    this.onXPressed,
    required this.packages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.height() * 0.80,
      child: Column(
        children: [
          SizedBox(
            height: context.height() * 0.70,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileImage(context),
                  _buildMatchText(),
                  _buildNameText(),
                  _buildLocationText(),
                  _buildDescriptorChips(),
                  _buildRequestText(),
                  _buildBiographyText(),
                  _buildInterestsChips(),
                  _buildSponsorshipPackagesSection(),
                  const SizedBox(height: 32)
                ],
              ),
            ),
          ),
          _buildButtonRow()
        ],
      ),
    );
  }

  Container _buildProfileImage(BuildContext context) {
    return Container(
        height: 232,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.topRight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(user.profileImageUrls.first),
            fit: BoxFit.cover,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: LinxCloseButton(
          color: LinxColors.subtitleGrey,
          size: 24,
          onXPressed: onXPressed,
        ));
  }

  Container _buildMatchText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
      child: Text(
        "$matchPercentage% match",
        style: const TextStyle(
          color: LinxColors.green,
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
        ),
      ),
    );
  }

  Container _buildNameText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        user.displayName,
        style: const TextStyle(
            color: LinxColors.subtitleGrey,
            fontWeight: FontWeight.w600,
            fontSize: 24.0),
      ),
    );
  }

  Container _buildLocationText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        user.location,
        style: const TextStyle(
          color: LinxColors.locationTextGrey,
          fontSize: 16,
        ),
      ),
    );
  }

  Container _buildDescriptorChips() {
    var chips = user.descriptors.map((e) => LinxChip(label: e));
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(20),
      child: Wrap(spacing: 4.0, children: [...chips]),
    );
  }

  Widget _buildRequestText() {
    if (request == null) return Empty();
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text("Pitch", style: _subHeadingStyle),
          ),
          Text(request!.message, style: _regularStyle),
        ],
      ),
    );
  }

  Container _buildBiographyText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text("Biography", style: _subHeadingStyle),
          ),
          Text(user.biography, style: _regularStyle),
        ],
      ),
    );
  }

  Container _buildInterestsChips() {
    var chips = user.interests.map((e) => LinxChip(label: e));

    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Looking for", style: _subHeadingStyle),
          Wrap(spacing: 4.0, children: [...chips]),
        ],
      ),
    );
  }

  Container _buildSponsorshipPackagesSection() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: Text("Packages", style: _subHeadingStyle),
          ),
          SponsorshipPackageCarousel(packages: packages),
        ],
      ),
    );
  }

  Container _buildButtonRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: RoundedButton(
        style: greenButtonStyle(),
        onPressed: () {},
        text: "Send pitch",
      ),
    );
  }
}
