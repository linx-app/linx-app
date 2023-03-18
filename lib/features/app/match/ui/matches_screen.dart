import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/core/ui/model/sort_item.dart';
import 'package:linx/features/app/core/ui/search_bar.dart';
import 'package:linx/features/app/core/ui/widgets/app_title_bar.dart';
import 'package:linx/features/app/core/ui/widgets/pop_up_menu_item.dart';
import 'package:linx/features/app/core/ui/widgets/profile_bottom_sheet.dart';
import 'package:linx/features/app/core/ui/widgets/small_profile_card.dart';
import 'package:linx/features/app/match/domain/model/match.dart';
import 'package:linx/features/app/match/presentation/matches_screen_controller.dart';
import 'package:linx/features/app/match/ui/model/matches_screen_state.dart';
import 'package:linx/utils/ui_extensions.dart';

final _sortItemSelected = StateProvider((ref) => SortItem.match);

class MatchesScreen extends ConsumerWidget {
  final MatchesScreenUiState _state;
  final MatchesScreenController _controller;
  final TextEditingController _searchController;

  MatchesScreen(this._state, this._controller, this._searchController,
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget body = _buildBody(context);
    _searchController.addListener(() {
      _controller.onSearchMatches(_searchController.text);
    });

    final selectedMenuItem = ref.read(_sortItemSelected);

    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: context.height() * 0.1),
            AppTitleBar(
              title: "Matches",
              subtitle: "Track your matches",
              icon: Image.asset("sort.png", height: 24, width: 24),
              isIconPopUpMenu: true,
              initialSortItem: selectedMenuItem,
              itemBuilder: (context) => _buildSortMenu(
                context,
                selectedMenuItem,
              ),
              onSortPressed: (sortItem) => _onSortPressed(sortItem, ref),
            ),
            SearchBar(
              controller: _searchController,
              label: "Search for a match...",
              onFocusChanged: (bool) {},
            ),
            body,
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
  ) {
    switch (_state.state) {
      case MatchesScreenState.loading:
        return SizedBox(
          height: context.height() * 0.5,
          child: LinxLoadingSpinner(),
        );
      case MatchesScreenState.results:
        return _buildMatchesList(context);
    }
  }

  Widget _buildMatchesList(BuildContext context) {
    final cards = _state.matches.map((e) {
      final data = SmallProfileCardData.fromMatch(e);
      return SmallProfileCard(
        data: data,
        onPressed: () => _onMatchPressed(context, e),
      );
    });

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(children: [...cards]),
    );
  }

  void _onMatchPressed(BuildContext context, Match match) {
    final bottomSheet = SizedBox(
      height: context.height() * 0.80,
      child: ProfileBottomSheet(
        user: match.user,
        mainButtonText: "Send message",
        onXPressed: () => Navigator.maybePop(context),
        onMainButtonPressed: () {
          Navigator.maybePop(context);
          // TODO: Redirect to messages
        },
      ),
    );

    _controller.onViewMatch(match.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => bottomSheet,
      barrierColor: LinxColors.black.withOpacity(0.60),
      shape: RoundedBorder.clockwise(10, 10, 0, 0),
    );
  }

  void _onSortPressed(SortItem item, WidgetRef ref) {
    final notifier = ref.read(_sortItemSelected.notifier);
    notifier.state = item;
    _controller.onSortPressed(item);
  }

  List<PopupMenuEntry<SortItem>> _buildSortMenu(
    BuildContext context,
    SortItem selected,
  ) {
    return [
      buildMenuItem(
        SortItem.match,
        selected,
        "Date",
        "Newest to oldest",
      ),
      buildMenuItem(
        SortItem.alphabetical,
        selected,
        "Alphabetical",
        "A - Z",
      ),
    ];
  }
}
