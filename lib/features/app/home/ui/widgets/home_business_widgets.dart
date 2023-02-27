import 'package:flutter/material.dart';
import 'package:linx/features/app/core/ui/widgets/small_profile_card.dart';
import 'package:linx/features/app/home/domain/model/request.dart';
import 'package:linx/features/app/home/ui/widgets/profile_card.dart';
import 'package:linx/features/app/home/ui/widgets/profile_modal_card.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';

List<ProfileCard> buildRequestsCarouselPages({
  required BuildContext context,
  required List<Request> requests,
  required List<double> percentages,
  required List<List<SponsorshipPackage>> packages,
  required Function(int) onMainButtonPressed,
}) {
  if (requests.isEmpty || percentages.isEmpty) return [];

  List<ProfileCard> pages = [];

  for (int i = 0; i < requests.length; i++) {
    pages.add(
      ProfileCard(
        mainButtonText: "See pitch",
        matchPercentage: percentages[i].toInt(),
        user: requests[i].sender,
        mainText: requests[i].message,
        onMainButtonPressed: () => onMainButtonPressed(i),
      ),
    );
  }

  return pages;
}

List<SmallProfileCard> buildRequestsList({
  required List<Request> requests,
  required List<double> percentages,
  required List<List<SponsorshipPackage>> packages,
  required Function(int) onPressed,
}) {
  if (requests.isEmpty || percentages.isEmpty) return [];
  List<SmallProfileCard> cards = [];

  for (int i = 0; i < requests.length; i++) {
    cards.add(
      SmallProfileCard(
        user: requests[i].sender,
        matchPercentage: percentages[i].toInt(),
        onPressed: () => onPressed(i)
      ),
    );
  }

  return cards;
}

List<ProfileModalCard> buildRequestsModalCards({
  required List<Request> requests,
  required List<double> percentages,
  required List<List<SponsorshipPackage>> packages,
  required VoidCallback onXPressed,
  required Function(int) onMainButtonPressed,
}) {
  var pages = <ProfileModalCard>[];

  for (int i = 0; i < requests.length; i++) {
    pages.add(
      ProfileModalCard(
        user: requests[i].sender,
        request: requests[i],
        matchPercentage: percentages[i].toInt(),
        packages: packages[i],
        onXPressed: onXPressed,
        mainButtonText: "I'm interested",
        onMainButtonPressed: () => onMainButtonPressed(i),
      ),
    );
  }

  return pages;
}
