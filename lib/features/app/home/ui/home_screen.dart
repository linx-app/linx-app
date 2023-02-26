import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/features/app/core/ui/widgets/small_profile_card.dart';
import 'package:linx/features/app/home/presentation/home_screen_controller.dart';
import 'package:linx/features/app/home/ui/profile_modal_screen.dart';
import 'package:linx/features/app/home/ui/widgets/profile_card.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_type.dart';
import 'package:linx/utils/ui_extensions.dart';

import 'widgets/profile_bottom_sheet.dart';

class HomeScreen extends ConsumerWidget {
  final LinxUser currentUser;
  final TextStyle _subtitleStyle = const TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 17.0,
    color: LinxColors.subtitleGrey,
  );

  const HomeScreen(this.currentUser, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(homeScreenControllerProvider.notifier).initialize(currentUser);
    var uiState = ref.watch(homeScreenControllerProvider);

    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHomeAppBar(context, ref),
            _buildHomeTitle(context, ref),
            _buildMatchesCarousel(
              context,
              uiState.topMatches,
              uiState.topMatchPercentages,
            ),
            _buildHomeBottomSection(
              context,
              uiState.nextMatches,
              uiState.nextMatchPercentages,
            ),
          ],
        ),
      ),
    );
  }

  Container _buildHomeAppBar(BuildContext context, WidgetRef ref) {
    return Container(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bookmark_border_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person_outline_rounded),
            )
          ],
        ));
  }

  Container _buildHomeTitle(BuildContext context, WidgetRef ref) {
    var isClub = currentUser.type == UserType.club;
    var title = isClub ? "Discover" : "Requests";
    var subtitle = isClub
        ? "Review Today's Top Matches"
        : "Review Today's Sponsorship Requests";
    return Container(
      width: context.width(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: LinxTextStyles.title),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(subtitle, style: _subtitleStyle),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchesCarousel(
    BuildContext context,
    List<LinxUser> users,
    List<double> percentages,
  ) {
    if (users.isEmpty || percentages.isEmpty) return Empty();
    List<ProfileCard> pages = [];

    for (int i = 0; i < users.length; i++) {
      pages.add(
        ProfileCard(
          matchPercentage: percentages[i].toInt(),
          user: users[i],
          onSeeDetailsPressed: (selectedUser) =>
              _onProfileCardSeeDetailsPressed(
                  context, selectedUser, users, percentages),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 360,
          child: PageView(
            padEnds: false,
            clipBehavior: Clip.none,
            controller: PageController(viewportFraction: 0.70),
            children: pages,
          ),
        )
      ],
    );
  }

  void _onProfileCardSeeDetailsPressed(
    BuildContext context,
    LinxUser selectedUser,
    List<LinxUser> allUsers,
    List<double> matchPercentages,
  ) {
    var index = allUsers.indexOf(selectedUser);
    var screen = ProfileModalScreen(index, allUsers, matchPercentages);
    var builder = PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      opaque: false,
    );
    Navigator.of(context).push(builder);
  }

  Container _buildHomeBottomSection(
    BuildContext context,
    List<LinxUser> matches,
    List<double> matchPercentages,
  ) {
    var cards = <SmallProfileCard>[];

    for (int i = 0; i < matches.length; i++) {
      cards.add(
        SmallProfileCard(
          user: matches[i],
          matchPercentage: matchPercentages[i].toInt(),
          onPressed: (user, percentage) =>
              _onSmallCardPressed(context, user, percentage),
        ),
      );
    }

    return Container(
      width: context.width(),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [_buildBottomSectionTitleBar(), ...cards],
      ),
    );
  }

  Container _buildBottomSectionTitleBar() {
    var isClub = currentUser.type == UserType.club;
    var title = isClub ? "Find a match" : "Other requests";
    return Container(
      child: Row(
        children: [
          Expanded(
              child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 17,
              color: LinxColors.subtitleGrey,
            ),
          )),
          SizedBox(
            height: 24,
            width: 24,
            child: InkWell(
              child: Image.asset(
                "assets/sort.png",
                color: LinxColors.subtitleGrey,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onSmallCardPressed(
    BuildContext context,
    LinxUser user,
    int matchPercentage,
  ) {
    var bottomSheet = SizedBox(
      height: context.height() * 0.80,
      child: ProfileBottomSheet(
        user: user,
        matchPercentage: matchPercentage,
        onXPressed: () => Navigator.maybePop(context),
      ),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => bottomSheet,
      barrierColor: LinxColors.black.withOpacity(0.60),
      shape: RoundedBorder.clockwise(10, 10, 0, 0),
    );
  }
}
