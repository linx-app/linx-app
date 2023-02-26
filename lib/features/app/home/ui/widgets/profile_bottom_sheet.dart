import 'package:flutter/material.dart';
import 'package:linx/common/buttons/linx_close_button.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/common/linx_chip.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class ProfileBottomSheet extends StatelessWidget {
  final LinxUser user;
  final int matchPercentage;
  final VoidCallback? onXPressed;

  const ProfileBottomSheet({
    super.key,
    required this.user,
    required this.matchPercentage,
    this.onXPressed,
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
                  _buildBiographyText(),
                  _buildInterestsChips(),
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
      )
    );
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

  Container _buildBiographyText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        user.biography,
        style: const TextStyle(
          color: LinxColors.chipTextGrey,
          fontSize: 16,
        ),
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
          const Text(
            "Looking for",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: LinxColors.subtitleGrey,
              fontSize: 17,
            ),
          ),
          Wrap(spacing: 4.0, children: [...chips]),
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
