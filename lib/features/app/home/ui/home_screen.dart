import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/features/app/home/presentation/home_screen_controller.dart';
import 'package:linx/features/app/home/ui/widgets/profile_card.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_type.dart';
import 'package:linx/utils/ui_extensions.dart';

class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var uiState = ref.watch(homeScreenControllerProvider);
    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHomeAppBar(context, ref),
            _buildHomeTitle(uiState.currentUser?.type, context, ref),
            if (uiState.matches.isNotEmpty && uiState.matchPercentages.isNotEmpty)
              _buildMatchesCarousel(uiState.matches, uiState.matchPercentages)
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

  Container _buildHomeTitle(UserType? type, BuildContext context, WidgetRef ref) {
    return Container(
      width: context.width(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Discover", style: LinxTextStyles.title),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Text(
              "Review Today's Top Matches",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17.0,
                  color: LinxColors.subtitleGrey
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildMatchesCarousel(List<LinxUser> users, List<double> percentages) {
    List<ProfileCard> pages = [];
    for (int i = 0; i < users.length; i++) {
      pages.add(ProfileCard(matchPercentage: percentages[i].toInt(), user: users[i]));
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
          )
        )
      ],
    );
  }
}
