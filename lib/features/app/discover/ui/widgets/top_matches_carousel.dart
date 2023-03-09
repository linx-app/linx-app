import 'package:flutter/material.dart';
import 'package:linx/features/app/core/ui/widgets/profile_card.dart';
import 'package:linx/features/user/domain/model/display_user.dart';

List<ProfileCard> buildTopMatchesCarouselPages({
  required BuildContext context,
  required List<DisplayUser> users,
  required Function(int) onMainButtonPressed,
}) {
  if (users.isEmpty) return [];
  List<ProfileCard> pages = [];

  for (int i = 0; i < users.length; i++) {
    pages.add(
      ProfileCard(
        mainButtonText: "See details",
        user: users[i],
        mainText: users[i].info.biography,
        onMainButtonPressed: () => onMainButtonPressed(i),
      ),
    );
  }

  return pages;
}