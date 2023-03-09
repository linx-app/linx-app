import 'package:flutter/material.dart';
import 'package:linx/features/app/core/ui/widgets/profile_modal_card.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

List<ProfileModalCard> buildTopMatchesModalCards({
  required List<LinxUser> users,
  required VoidCallback onXPressed,
  required Function(int) onMainButtonPressed,
}) {
  var pages = <ProfileModalCard>[];

  for (int i = 0; i < users.length; i++) {
    pages.add(
      ProfileModalCard(
        user: users[i],
        onXPressed: onXPressed,
        mainButtonText: "Send pitch",
        onMainButtonPressed: () => onMainButtonPressed(i),
      ),
    );
  }

  return pages;
}
