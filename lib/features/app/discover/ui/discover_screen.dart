import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/core/ui/profile_modal_screen.dart';
import 'package:linx/features/app/core/ui/widgets/app_title_bar.dart';
import 'package:linx/features/app/core/ui/widgets/home_app_bar.dart';
import 'package:linx/features/app/core/ui/widgets/profile_bottom_sheet.dart';
import 'package:linx/features/app/discover/presentation/discover_screen_controller.dart';
import 'package:linx/features/app/discover/ui/widgets/matches_list.dart';
import 'package:linx/features/app/discover/ui/widgets/top_matches_carousel.dart';
import 'package:linx/features/app/discover/ui/send_a_pitch_screen.dart';
import 'package:linx/features/core/domain/model/sponsorship_package.dart';
import 'package:linx/features/core/ui/search_bar.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_type.dart';
import 'package:linx/utils/ui_extensions.dart';

class DiscoverScreen extends ConsumerWidget {
  final TextEditingController _searchController = TextEditingController();
  final String _searchText = "Search for a business...";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(discoverScreenControllerProvider);

    if (state == null) {
      return const BaseScaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      var isClub = state.currentUser.type == UserType.club;
      var spacer = isClub ? Empty() : SizedBox(height: context.height() * 0.1);
      var screenBar = isClub ? HomeAppBar() : Empty();
      var searchBar = isClub
          ? Empty()
          : SearchBar(controller: _searchController, label: _searchText);

      return BaseScaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              spacer,
              screenBar,
              const AppTitleBar(title: "Discover"),
              searchBar,
              _buildMatchesCarousel(context, ref, state),
              _buildMatchesList(context, ref, state),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildMatchesCarousel(
    BuildContext context,
    WidgetRef ref,
    DiscoverScreenUiState state,
  ) {
    var pages = buildTopMatchesCarouselPages(
      context: context,
      users: state.topMatches,
      percentages: state.topMatchPercentages,
      packages: state.topPackages,
      onMainButtonPressed: (index) {
        _onProfileCardSeeDetailsPressed(context, ref, index, state);
      },
    );

    if (pages.isEmpty) return Empty();

    return Column(
      children: [
        const AppTitleBar(subtitle: "Review Today's Top Matches"),
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

  Widget _buildMatchesList(
      BuildContext context, WidgetRef ref, DiscoverScreenUiState state) {
    var cards = buildMatchesList(
        users: state.nextMatches,
        percentages: state.nextMatchPercentages,
        packages: state.nextPackages,
        onPressed: (index) {
          _onSmallCardPressed(
            context: context,
            user: state.nextMatches[index],
            matchPercentage: state.nextMatchPercentages[index].toInt(),
            packages: state.nextPackages[index],
            ref: ref,
            currentUser: state.currentUser,
          );
        });

    if (cards.isEmpty) return Empty();

    var titleBar = AppTitleBar(
      subtitle: "Find a match",
      icon: Image.asset(
        "assets/sort.png",
        color: LinxColors.subtitleGrey,
      ),
    );

    return Container(
      width: context.width(),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [titleBar, ...cards],
      ),
    );
  }

  void _onProfileCardSeeDetailsPressed(
    BuildContext context,
    WidgetRef ref,
    int initialIndex,
    DiscoverScreenUiState state,
  ) {
    var screen = ProfileModalScreen(
      initialIndex: initialIndex,
      users: state.topMatches,
      requests: const [],
      matchPercentages: state.topMatchPercentages,
      packages: state.topPackages,
      currentUser: state.currentUser,
      onMainButtonPressed: (user, packages, request) {
        _onSendPitchPressed(
          user,
          packages,
          context,
          ref,
          state.currentUser,
        );
      },
    );
    var builder = PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      opaque: false,
    );
    Navigator.of(context).push(builder);
  }

  void _onSendPitchPressed(
    LinxUser receiver,
    List<SponsorshipPackage> packages,
    BuildContext context,
    WidgetRef ref,
    LinxUser currentUser,
  ) {
    var screen = SendAPitchScreen(
      receiver: receiver,
      packages: packages,
    );
    var builder = PageRouteBuilder(pageBuilder: (_, __, ___) => screen);
    Navigator.of(context).push(builder);
  }

  void _onSmallCardPressed({
    required BuildContext context,
    required LinxUser user,
    required int matchPercentage,
    required List<SponsorshipPackage> packages,
    required WidgetRef ref,
    required LinxUser currentUser,
  }) {
    var bottomSheet = SizedBox(
      height: context.height() * 0.80,
      child: ProfileBottomSheet(
        user: user,
        matchPercentage: matchPercentage,
        mainButtonText: "Send pitch" ,
        onXPressed: () => Navigator.maybePop(context),
        packages: packages,
        onMainButtonPressed: () {
          _onSendPitchPressed(
            user,
            packages,
            context,
            ref,
            currentUser,
          );
        },
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
