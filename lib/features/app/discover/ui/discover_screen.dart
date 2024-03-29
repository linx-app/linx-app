import 'package:flutter/material.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/core/ui/model/search_state.dart';
import 'package:linx/features/app/core/ui/profile_modal_screen.dart';
import 'package:linx/features/app/core/ui/search_bar.dart';
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
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class DiscoverScreen extends StatelessWidget {
  final String _searchText = "Search for a team or club...";
  final TextEditingController? _searchController;
  final DiscoverScreenUiState _state;
  final DiscoverScreenController _controller;

  DiscoverScreen(this._state, this._controller, this._searchController, {super.key});

  @override
  Widget build(BuildContext context) {
    final spacer = _state.isCurrentUserClub
        ? Empty()
        : SizedBox(height: context.height() * 0.1);
    final screenBar = _state.isCurrentUserClub ? HomeAppBar() : Empty();
    final searchBar = _state.isCurrentUserClub ? Empty() : _buildSearchBar();
    final body = _buildScreenBody(context);

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

  Widget _buildSearchBar() {
    if (_searchController == null) return Empty();
    return SearchBar(
      controller: _searchController!,
      label: _searchText,
      onFocusChanged: (focus) => _onSearchBarFocusChanged(focus),
      onXPressed: () {
        FocusManager.instance.primaryFocus?.unfocus();
        _searchController!.clear();
        _controller.onSearchCompleted("");
      },
    );
  }

  void _onSearchBarFocusChanged(bool hasFocus) {
    if (hasFocus) {
      _controller.onSearchInitiated();
    } else {
      _controller.onSearchCompleted(_searchController!.text);
    }
  }

  Widget _buildMatchesCarousel(
    BuildContext context,
  ) {
    final pages = buildTopMatchesCarouselPages(
      context: context,
      users: _state.topMatches,
      onMainButtonPressed: (index) {
        _onProfileCardSeeDetailsPressed(context, index);
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

  Widget _buildMatchesList(BuildContext context) {
    final cards = buildMatchesList(
      users: _state.nextMatches,
      onPressed: (index) {
        _onSmallCardPressed(context: context, user: _state.nextMatches[index]);
      },
    );

    if (cards.isEmpty) return Empty();

    final titleBar = AppTitleBar(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      subtitle: "Find a match",
      icon: Image.asset(
        "assets/sort.png",
        color: LinxColors.subtitleGrey,
        height: 24,
        width: 24,
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

  void _onProfileCardSeeDetailsPressed(BuildContext context, int initialIndex) {
    final screen = ProfileModalScreen(
      initialIndex: initialIndex,
      users: _state.topMatches,
      requests: const [],
      isCurrentUserClub: _state.isCurrentUserClub,
      onMainButtonPressed: (idx) {
        _onSendPitchPressed(_state.topMatches[idx], context);
      },
    );
    final builder = PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      opaque: false,
    );
    Navigator.of(context).push(builder);
  }

  void _onSendPitchPressed(LinxUser receiver, BuildContext context) {
    final screen = SendAPitchScreen(receiver: receiver);
    final builder = PageRouteBuilder(pageBuilder: (_, __, ___) => screen);
    Navigator.of(context).push(builder);
  }

  void _onSmallCardPressed({
    required BuildContext context,
    required LinxUser user,
  }) {
    final bottomSheet = SizedBox(
      height: context.height() * 0.80,
      child: ProfileBottomSheet(
        user: user,
        mainButtonText: "Send pitch",
        onXPressed: () => Navigator.maybePop(context),
        onMainButtonPressed: () => _onSendPitchPressed(user, context),
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

  Widget _buildScreenBody(BuildContext context) {
    switch (_state.state) {
      case SearchState.initial:
        return Column(
          children: [
            _buildMatchesCarousel(context),
            _buildMatchesList(context),
          ],
        );
      case SearchState.results:
        if (_state.results!.users.isEmpty) {
          return EmptySearchPage();
        } else {
          return ResultsSearchPage(
            page: _state.results!,
            subtitle: _state.subtitle,
            onSmallCardPressed: (index) => _onSmallCardPressed(
              context: context,
              user: _state.results!.users[index],
            ),
          );
        }
      case SearchState.loading:
        return LinxLoadingSpinner();
      case SearchState.searching:
        return RecentsSearchPage(
          recents: _state.recents,
          onRecentsPressed: (search) => _onSearchCompleted(search),
        );
    }
  }

  void _onSearchCompleted(String search) {
    _searchController!.text = search;
    _controller.onSearchCompleted(search);
  }
}
