import 'package:flutter/material.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/common/text_badge.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/match/domain/model/match.dart';
import 'package:linx/features/app/request/domain/model/request.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class SmallProfileCardData {
  final String title;
  final String imageUrl;
  final String line1Text;
  final String line2Text;
  final String outlineText;
  final bool hasNewBadge;

  SmallProfileCardData(
      {this.title = "",
      this.line1Text = "",
      this.line2Text = "",
      this.imageUrl = "",
      this.outlineText = "",
      this.hasNewBadge = false});

  static SmallProfileCardData fromLinxUser(LinxUser user) {
    return SmallProfileCardData(
      title: user.info.displayName,
      line1Text: user.info.location,
      line2Text: user.info.descriptors.first,
      imageUrl: user.info.profileImageUrls.first,
      outlineText: "${user.matchPercentage}% match",
    );
  }

  static SmallProfileCardData fromMatch(Match match) {
    return SmallProfileCardData(
      title: match.user.info.displayName,
      line1Text: match.user.info.location,
      line2Text: match.user.info.descriptors.first,
      imageUrl: match.user.info.profileImageUrls.first,
      outlineText: "Matched ${match.date.toDisplayTime()}",
      hasNewBadge: match.isNew,
    );
  }

  static SmallProfileCardData fromRequest(Request request) {
    return SmallProfileCardData(
      title: request.receiver.displayName,
      line1Text: request.receiver.location,
      line2Text: request.receiver.descriptors.first,
      imageUrl: request.receiver.profileImageUrls.first,
      outlineText: "Sent ${request.createdAt.toDisplayTime()}",
      hasNewBadge: false, // TODO: has new for request
    );
  }
}

class SmallProfileCard extends StatelessWidget {
  final SmallProfileCardData data;
  final VoidCallback? onPressed;

  const SmallProfileCard({
    super.key,
    required this.data,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Widget badge = data.hasNewBadge ? newTextBadge : Empty();

    return Stack(
      children: [
        Container(
          alignment: Alignment.topRight,
          child: badge,
        ),
        Card(
          shape: RoundedBorder.all(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => onPressed?.call(),
            child: Row(
              children: [
                _buildProfileImage(),
                _buildTextColumn(),
                _buildChevronIcon(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Container _buildProfileImage() {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(data.imageUrl),
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
            _buildTitle(),
            _buildLine1Text(),
            _buildLine2Text(),
            _buildOutlineText(),
          ],
        ),
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      data.title,
      style: const TextStyle(
          color: LinxColors.subtitleGrey,
          fontWeight: FontWeight.w600,
          fontSize: 15.0),
    );
  }

  Text _buildLine1Text() {
    return Text(
      data.line1Text,
      style: const TextStyle(
        color: LinxColors.locationTextGrey,
        fontWeight: FontWeight.w600,
        fontSize: 13.0,
      ),
    );
  }

  Text _buildLine2Text() {
    return Text(
      data.line2Text,
      style: const TextStyle(
        color: LinxColors.locationTextGrey,
        fontSize: 13.0,
      ),
    );
  }

  Text _buildOutlineText() {
    return Text(
      data.outlineText,
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
