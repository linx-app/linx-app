import 'package:flutter/material.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

class ProfileCard extends StatelessWidget {
  final int matchPercentage;
  final LinxUser user;
  final void Function(LinxUser)? onSeeDetailsPressed;

  const ProfileCard({
    super.key,
    required this.matchPercentage,
    required this.user,
    this.onSeeDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedBorder.all(10),
      margin: const EdgeInsets.only(left: 24),
      elevation: 10,
      child: SizedBox(
        width: 270,
        child: Column(
          children: [
            _profileImage(),
            _matchText(),
            _nameText(),
            _locationText(),
            _biographyText(),
            _buttonRow(),
          ],
        ),
      ),
    );
  }

  Container _profileImage() {
    return Container(
      height: 155,
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        "$matchPercentage% match",
        style: const TextStyle(
            color: LinxColors.green,
            fontWeight: FontWeight.w600,
            fontSize: 12.0),
      ),
    );
  }

  Container _nameText() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        user.displayName,
        style: const TextStyle(
            color: LinxColors.subtitleGrey,
            fontWeight: FontWeight.w600,
            fontSize: 17.0),
      ),
    );
  }

  Container _locationText() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          user.location,
          style:
              const TextStyle(color: LinxColors.locationTextGrey, fontSize: 12),
        ));
  }

  Container _biographyText() {
    return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          "${user.biography}\n\n\n\n",
          style: const TextStyle(color: LinxColors.chipTextGrey, fontSize: 12),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ));
  }

  Container _buttonRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: RoundedButton(
        style: greenButtonStyle(),
        onPressed: _onSeeDetailsPressed,
        text: "See details",
      ),
    );
  }

  void _onSeeDetailsPressed() => (onSeeDetailsPressed ?? () {}).call(user);
}
