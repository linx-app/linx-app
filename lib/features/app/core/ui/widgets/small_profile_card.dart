import 'package:flutter/material.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

class SmallProfileCard extends StatelessWidget {
  final LinxUser user;
  final int matchPercentage;
  final VoidCallback? onPressed;

  const SmallProfileCard({
    super.key,
    required this.user,
    required this.matchPercentage,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedBorder.all(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onPressed?.call() ,
        child: Row(
          children: [
            _buildProfileImage(),
            _buildTextColumn(),
            _buildChevronIcon(),
          ],
        ),
      ),
    );
  }

  Container _buildProfileImage() {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(user.profileImageUrls.first),
          fit: BoxFit.cover,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
    );
  }

  Expanded _buildTextColumn() {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNameText(),
            _buildLocationText(),
            _buildDescriptorText(),
            _buildMatchText(),
          ],
        ),
      ),
    );
  }

  Text _buildNameText() {
    return Text(
      user.displayName,
      style: const TextStyle(
          color: LinxColors.subtitleGrey,
          fontWeight: FontWeight.w600,
          fontSize: 15.0),
    );
  }

  Text _buildLocationText() {
    return Text(
      user.location,
      style: const TextStyle(
        color: LinxColors.locationTextGrey,
        fontWeight: FontWeight.w600,
        fontSize: 13.0,
      ),
    );
  }

  Text _buildDescriptorText() {
    return Text(
      user.descriptors.first,
      style: const TextStyle(
        color: LinxColors.locationTextGrey,
        fontSize: 13.0,
      ),
    );
  }

  Text _buildMatchText() {
    return Text(
      "$matchPercentage% match",
      style: const TextStyle(color: LinxColors.green, fontSize: 13.0),
    );
  }

  Container _buildChevronIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: const Icon(
        Icons.chevron_right,
        size: 24.0,
        color: LinxColors.locationTextGrey,
      ),
    );
  }
}
