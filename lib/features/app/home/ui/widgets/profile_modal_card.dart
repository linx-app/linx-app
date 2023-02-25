import 'package:flutter/material.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/common/linx_chip.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class ProfileModalCard extends StatelessWidget {
  final LinxUser user;
  final int matchPercentage;

  const ProfileModalCard(
      {super.key, required this.user, required this.matchPercentage});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      child: Container(
        height: 630,
        width: context.width() * 0.65,
        child: Column(
          children: [
            SizedBox(
              height: 550,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _profileImage(),
                    _matchText(),
                    _nameText(),
                    _locationText(),
                    _descriptorChips(),
                    _biographyText(),
                    _interestsChips(),
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
    );
  }

  Container _matchText() {
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

  Container _biographyText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        user.biography,
        style: const TextStyle(color: LinxColors.chipTextGrey, fontSize: 15),
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

  Container _buttonRow() {
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
