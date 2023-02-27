import 'package:flutter/material.dart';
import 'package:linx/features/app/core/ui/widgets/small_profile_card.dart';
import 'package:linx/features/app/home/ui/widgets/profile_card.dart';
import 'package:linx/features/app/home/ui/widgets/profile_modal_card.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

List<ProfileCard> buildMatchesCarouselPages({
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

List<SmallProfileCard> buildMatchesList({
  required List<LinxUser> users,
  required List<double> percentages,
  required List<List<SponsorshipPackage>> packages,
  required Function(int) onPressed,
}) {
  if (users.isEmpty || percentages.isEmpty) return [];
  List<SmallProfileCard> cards = [];

  for (int i = 0; i < users.length; i++) {
    var percentage = percentages[i].toInt();
    cards.add(
      SmallProfileCard(
        user: users[i],
        matchPercentage: percentage,
        onPressed: () => onPressed(i),
      ),
    );
  }

  return cards;
}

List<ProfileModalCard> buildMatchesModalCards({
  required List<LinxUser> users,
  required List<double> percentages,
  required List<List<SponsorshipPackage>> packages,
  required VoidCallback onXPressed,
  required Function(int) onMainButtonPressed,
}) {
  var pages = <ProfileModalCard>[];

  for (int i = 0; i < users.length; i++) {
    pages.add(
      ProfileModalCard(
        user: users[i],
        matchPercentage: percentages[i].toInt(),
        packages: packages[i],
        onXPressed: onXPressed,
        mainButtonText: "Send pitch",
        onMainButtonPressed: () => onMainButtonPressed(i),
      ),
    );
  }

  return pages;
}
