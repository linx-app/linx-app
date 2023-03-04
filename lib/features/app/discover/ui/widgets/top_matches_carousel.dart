import 'package:flutter/material.dart';
import 'package:linx/features/app/core/ui/widgets/profile_card.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

List<ProfileCard> buildTopMatchesCarouselPages({
  required BuildContext context,
  required List<LinxUser> users,
  required List<double> percentages,
  required List<List<SponsorshipPackage>> packages,
  required Function(int) onMainButtonPressed,
}) {
  if (users.isEmpty || percentages.isEmpty) return [];
  List<ProfileCard> pages = [];

  for (int i = 0; i < users.length; i++) {
    pages.add(
      ProfileCard(
        mainButtonText: "See details",
        matchPercentage: percentages[i].toInt(),
        user: users[i],
        mainText: users[i].biography,
        onMainButtonPressed: () => onMainButtonPressed(i),
      ),
    );
  }

  return pages;
}