import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/core/ui/widgets/app_title_bar.dart';
import 'package:linx/features/app/core/ui/widgets/profile_bottom_sheet.dart';
import 'package:linx/features/app/discover/ui/send_a_pitch_screen.dart';
import 'package:linx/features/app/search/domain/model/search_group.dart';
import 'package:linx/features/app/search/presentation/search_screen_controller.dart';
import 'package:linx/features/app/search/ui/widgets/empty_search_page.dart';
import 'package:linx/features/app/search/ui/widgets/groups_search_page.dart';
import 'package:linx/features/app/search/ui/widgets/recents_search_page.dart';
import 'package:linx/features/app/search/ui/widgets/results_search_page.dart';
import 'package:linx/features/core/ui/model/search_state.dart';
import 'package:linx/features/core/ui/search_bar.dart';
import 'package:linx/features/user/domain/model/display_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class SearchScreen extends ConsumerWidget {
  final TextEditingController _searchController = TextEditingController();
  final String _searchText = "Search for a business...";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(searchScreenControllerProvider);

    Widget body = _buildSearchBody(context, ref, uiState);

    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: context.height() * 0.1),
            _buildTitle(),
            SearchBar(
                controller: _searchController,
                label: _searchText,
                onFocusChanged: (focus) => _onSearchBarFocusChanged(ref, focus),
                onXPressed: () {
                  _searchController.clear();
                  ref
                      .read(searchScreenControllerProvider.notifier)
                      .onSearchCompleted("");
                }),
            body,
          ],
        ),
      ),
    );
  }

  AppTitleBar _buildTitle() {
    return const AppTitleBar(title: "Search", iconData: Icons.filter_list);
  }

  void _onSearchBarFocusChanged(WidgetRef ref, bool hasFocus) {
    final notifier = ref.read(searchScreenControllerProvider.notifier);
    if (hasFocus) {
      notifier.onSearchInitiated();
    } else {
      notifier.onSearchCompleted(_searchController.text);
    }
  }

  Widget _buildSearchBody(
    BuildContext context,
    WidgetRef ref,
    SearchScreenUiState state,
  ) {
    switch (state.state) {
      case SearchState.initial:
        return _buildGroups(ref, state.groups);
      case SearchState.results:
        return _buildResults(context, ref, state);
      case SearchState.loading:
        return LinxLoadingSpinner();
      case SearchState.searching:
        return _buildRecentSearches(ref, state.recentSearches);
    }
  }

  Widget _buildRecentSearches(WidgetRef ref, List<String> recents) {
    return RecentsSearchPage(
      recents: recents,
      onRecentsPressed: (search) => _onSearchInitiated(ref, search),
    );
  }

  Widget _buildGroups(WidgetRef ref, List<SearchGroup> groups) {
    return GroupSearchPage(
      groups: groups,
      onGroupPressed: (group) => _onSearchCategoryPressed(ref, group),
    );
  }

  Widget _buildResults(
    BuildContext context,
    WidgetRef ref,
    SearchScreenUiState state,
  ) {
    if (state.results!.users.isEmpty) {
      return EmptySearchPage();
    } else {
      return ResultsSearchPage(
        page: state.results!,
        subtitle: state.subtitle,
        onSmallCardPressed: (index) => _onProfileCardPressed(
          context: context,
          ref: ref,
          user: state.results!.users[index],
        ),
      );
    }
  }

  void _onSearchCategoryPressed(WidgetRef ref, SearchGroup groupSelected) {
    final notifier = ref.read(searchScreenControllerProvider.notifier);
    notifier.onSearchGroupSelected(groupSelected);
  }

  void _onSearchInitiated(WidgetRef ref, String search) {
    final notifier = ref.read(searchScreenControllerProvider.notifier);
    notifier.onSearchCompleted(search);
  }

  void _onProfileCardPressed({
    required BuildContext context,
    required WidgetRef ref,
    required DisplayUser user,
  }) {
    var bottomSheet = SizedBox(
      height: context.height() * 0.80,
      child: ProfileBottomSheet(
        user: user,
        mainButtonText: "Send pitch",
        onXPressed: () => Navigator.maybePop(context),
        onMainButtonPressed: () {
          _onSendPitchPressed(user, context, ref);
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

  void _onSendPitchPressed(
    DisplayUser receiver,
    BuildContext context,
    WidgetRef ref,
  ) {
    final screen = SendAPitchScreen(receiver: receiver);
    final builder = PageRouteBuilder(pageBuilder: (_, __, ___) => screen);
    Navigator.of(context).push(builder);
  }
}
