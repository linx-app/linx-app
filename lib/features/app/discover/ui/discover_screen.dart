import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/core/ui/profile_modal_screen.dart';
import 'package:linx/features/app/core/ui/widgets/app_title_bar.dart';
import 'package:linx/features/app/core/ui/widgets/home_app_bar.dart';
import 'package:linx/features/app/core/ui/widgets/profile_bottom_sheet.dart';
import 'package:linx/features/app/discover/presentation/discover_screen_controller.dart';
import 'package:linx/features/app/discover/ui/send_a_pitch_screen.dart';
import 'package:linx/features/app/discover/ui/widgets/matches_list.dart';
import 'package:linx/features/app/discover/ui/widgets/top_matches_carousel.dart';
import 'package:linx/features/app/search/ui/widgets/empty_search_page.dart';
import 'package:linx/features/app/search/ui/widgets/recents_search_page.dart';
import 'package:linx/features/app/search/ui/widgets/results_search_page.dart';
import 'package:linx/features/app/core/ui/model/search_state.dart';
import 'package:linx/features/app/core/ui/search_bar.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class DiscoverScreen extends ConsumerWidget {
  final TextEditingController _searchController = TextEditingController();
  final String _searchText = "Search for a team or club...";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(discoverScreenControllerProvider);
    final spacer = state.isCurrentUserClub
        ? Empty()
        : SizedBox(height: context.height() * 0.1);
    final screenBar = state.isCurrentUserClub ? HomeAppBar() : Empty();
    final searchBar = state.isCurrentUserClub ? Empty() : _buildSearchBar(ref);
    final body = _buildScreenBody(context, ref, state);

    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            spacer,
            screenBar,
            const AppTitleBar(title: "Discover"),
            searchBar,
            body,
          ],
        ),
      ),
    );
  }

  SearchBar _buildSearchBar(WidgetRef ref) {
    return SearchBar(
      controller: _searchController,
      label: _searchText,
      onFocusChanged: (focus) => _onSearchBarFocusChanged(ref, focus),
      onXPressed: () {
        _searchController.clear();
        ref
            .read(discoverScreenControllerProvider.notifier)
            .onSearchCompleted("");
      },
    );
  }

  void _onSearchBarFocusChanged(WidgetRef ref, bool hasFocus) {
    final notifier = ref.read(discoverScreenControllerProvider.notifier);
    if (hasFocus) {
      notifier.onSearchInitiated();
    } else {
      notifier.onSearchCompleted(_searchController.text);
    }
  }

  Widget _buildMatchesCarousel(
    BuildContext context,
    WidgetRef ref,
    DiscoverScreenUiState state,
  ) {
    final pages = buildTopMatchesCarouselPages(
      context: context,
      users: state.topMatches,
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
    BuildContext context,
    WidgetRef ref,
    DiscoverScreenUiState state,
  ) {
    final cards = buildMatchesList(
      users: state.nextMatches,
      onPressed: (index) {
        _onSmallCardPressed(
          context: context,
          user: state.nextMatches[index],
          ref: ref,
        );
      },
    );

    if (cards.isEmpty) return Empty();

    final titleBar = AppTitleBar(
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
    final screen = ProfileModalScreen(
      initialIndex: initialIndex,
      users: state.topMatches,
      requests: const [],
      isCurrentUserClub: state.isCurrentUserClub,
      onMainButtonPressed: (user) {
        _onSendPitchPressed(user, context, ref);
      },
    );
    final builder = PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      opaque: false,
    );
    Navigator.of(context).push(builder);
  }

  void _onSendPitchPressed(
    LinxUser receiver,
    BuildContext context,
    WidgetRef ref,
  ) {
    final screen = SendAPitchScreen(receiver: receiver);
    final builder = PageRouteBuilder(pageBuilder: (_, __, ___) => screen);
    Navigator.of(context).push(builder);
  }

  void _onSmallCardPressed({
    required BuildContext context,
    required LinxUser user,
    required WidgetRef ref,
  }) {
    final bottomSheet = SizedBox(
      height: context.height() * 0.80,
      child: ProfileBottomSheet(
        user: user,
        mainButtonText: "Send pitch",
        onXPressed: () => Navigator.maybePop(context),
        onMainButtonPressed: () => _onSendPitchPressed(user, context, ref),
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

  Widget _buildScreenBody(
    BuildContext context,
    WidgetRef ref,
    DiscoverScreenUiState state,
  ) {
    switch (state.state) {
      case SearchState.initial:
        return Column(
          children: [
            _buildMatchesCarousel(context, ref, state),
            _buildMatchesList(context, ref, state),
          ],
        );
      case SearchState.results:
        if (state.results!.users.isEmpty) {
          return EmptySearchPage();
        } else {
          return ResultsSearchPage(
            page: state.results!,
            subtitle: state.subtitle,
            onSmallCardPressed: (index) => _onSmallCardPressed(
              context: context,
              user: state.results!.users[index],
              ref: ref,
            ),
          );
        }
      case SearchState.loading:
        return LinxLoadingSpinner();
      case SearchState.searching:
        return RecentsSearchPage(
          recents: state.recents,
          onRecentsPressed: (search) => _onSearchCompleted(ref, search),
        );
    }
  }

  void _onSearchCompleted(WidgetRef ref, String search) {
    _searchController.text = search;
    final notifier = ref.read(discoverScreenControllerProvider.notifier);
    notifier.onSearchCompleted(search);
  }
}
