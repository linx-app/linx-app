import 'package:flutter/material.dart';
import 'package:linx/common/buttons/linx_close_button.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/common/linx_chip.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/core/ui/sponsorship_package_carousel.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class ProfileModalCard extends StatelessWidget {
  final TextStyle _subHeadingStyle = const TextStyle(
    fontWeight: FontWeight.w600,
    color: LinxColors.subtitleGrey,
    fontSize: 17,
  );
  final LinxUser user;
  final Request? request;
  final List<SponsorshipPackage> packages;
  final int matchPercentage;
  final VoidCallback? onXPressed;
  final Function()? onMainButtonPressed;
  final String mainButtonText;

  const ProfileModalCard({
    super.key,
    required this.user,
    required this.matchPercentage,
    required this.packages,
    this.request,
    this.onXPressed,
    this.onMainButtonPressed,
    required this.mainButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedBorder.all(10),
      elevation: 10,
      child: Container(
        height: 630,
        width: context.width() * 0.65,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _profileImage(),
                      _matchText(),
                      _nameText(),
                      _locationText(),
                      _descriptorChips(),
                      _requestText(),
                      _biographyText(),
                      _interestsChips(),
                      _buildSponsorshipPackageSection(),
                      const SizedBox(height: 32),
                    ],
                  ),
              ),
            ),
            _buttonRow(),
          ],
        ),
      ),
    );
  }

  Container _profileImage() {
    return Container(
      height: 210,
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
        size: 24,
        color: LinxColors.grey6,
        onXPressed: onXPressed,
      ),
    );
  }

  _matchText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
      child: Text(
        "$matchPercentage% match",
        style: const TextStyle(
          color: LinxColors.green,
          fontWeight: FontWeight.w600,
          fontSize: 15.0,
        ),
      ),
    );
  }

  Container _nameText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        user.displayName,
        style: const TextStyle(
            color: LinxColors.subtitleGrey,
            fontWeight: FontWeight.w600,
            fontSize: 22.0),
      ),
    );
  }

  Container _locationText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        user.location,
        style: const TextStyle(
          color: LinxColors.locationTextGrey,
          fontSize: 15,
        ),
      ),
    );
  }

  Container _descriptorChips() {
    var chips = user.descriptors.map((e) => LinxChip(label: e));
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(20),
      child: Wrap(spacing: 4.0, children: [...chips]),
    );
  }

  Widget _requestText() {
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
          Text(
            request!.message,
            style:
                const TextStyle(color: LinxColors.chipTextGrey, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Container _biographyText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text("Biography", style: _subHeadingStyle),
          ),
          Text(
            user.biography,
            style:
                const TextStyle(color: LinxColors.chipTextGrey, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Container _interestsChips() {
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

  Widget _buildSponsorshipPackageSection() {
    if (packages.isEmpty) return Empty();
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

  Container _buttonRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: RoundedButton(
        style: greenButtonStyle(),
        onPressed: () => onMainButtonPressed?.call(),
        text: mainButtonText,
      ),
    );
  }
}
