import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/core/ui/widgets/profile_card.dart';
import 'package:linx/features/app/core/ui/widgets/profile_modal_card.dart';
import 'package:linx/features/app/core/ui/widgets/small_profile_card.dart';
import 'package:linx/features/app/request/domain/model/request.dart';

List<ProfileCard> buildRequestsCarouselPages({
  required BuildContext context,
  required List<Request> requests,
  required Function(int) onMainButtonPressed,
}) {
  if (requests.isEmpty) return [];

  List<ProfileCard> pages = [];

  for (int i = 0; i < requests.length; i++) {
    pages.add(
      ProfileCard(
        mainButtonText: "See pitch",
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
  required Function(int) onPressed,
}) {
  if (requests.isEmpty) return [];
  List<SmallProfileCard> cards = [];

  for (int i = 0; i < requests.length; i++) {
    cards.add(
      SmallProfileCard(
          data: SmallProfileCardData.fromLinxUser(requests[i].sender),
          onPressed: () => onPressed(i),
      ),
    );
  }

  return cards;
}

List<ProfileModalCard> buildRequestsModalCards({
  required List<Request> requests,
  required VoidCallback onXPressed,
  required Function(int) onMainButtonPressed,
}) {
  var pages = <ProfileModalCard>[];

  for (int i = 0; i < requests.length; i++) {
    pages.add(
      ProfileModalCard(
        user: requests[i].sender,
        request: requests[i],
        onXPressed: onXPressed,
        mainButtonText: "I'm interested",
        onMainButtonPressed: () => onMainButtonPressed(i),
      ),
    );
  }

  return pages;
}

SnackBar buildMatchConfirmationSnackbar(String clubDisplayName) {
  return SnackBar(
    content: Container(
      alignment: Alignment.centerLeft,
      height: 50,
      child: Row(
        children: [
          Image.asset("assets/confirmation.png", height: 48, width: 48),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Matched with $clubDisplayName",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: LinxColors.black,
                      fontSize: 15),
                ),
                const Text(
                  "They will be notified.",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: LinxColors.black,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    backgroundColor: LinxColors.background,
    elevation: 10,
  );
}
