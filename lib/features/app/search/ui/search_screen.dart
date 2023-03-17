import 'package:flutter/material.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/core/ui/model/search_state.dart';
import 'package:linx/features/app/core/ui/search_bar.dart';
import 'package:linx/features/app/core/ui/widgets/app_title_bar.dart';
import 'package:linx/features/app/core/ui/widgets/profile_bottom_sheet.dart';
import 'package:linx/features/app/discover/ui/send_a_pitch_screen.dart';
import 'package:linx/features/app/search/domain/model/search_group.dart';
import 'package:linx/features/app/search/presentation/search_screen_controller.dart';
import 'package:linx/features/app/search/ui/widgets/empty_search_page.dart';
import 'package:linx/features/app/search/ui/widgets/groups_search_page.dart';
import 'package:linx/features/app/search/ui/widgets/recents_search_page.dart';
import 'package:linx/features/app/search/ui/widgets/results_search_page.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/utils/ui_extensions.dart';

class SearchScreen extends StatelessWidget {
  final String _searchText = "Search for a business...";
  final TextEditingController _searchController;
  final SearchScreenUiState _state;
  final SearchScreenController _controller;

  SearchScreen(this._state, this._controller, this._searchController,
      {super.key});

  @override
  Widget build(BuildContext context) {
    Widget body = _buildSearchBody(context);

    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: context.height() * 0.1),
            _buildTitle(),
            SearchBar(
              controller: _searchController,
              label: _searchText,
              onFocusChanged: (focus) => _onSearchBarFocusChanged,
              onXPressed: () {
                _searchController.clear();
                _controller.onSearchCompleted("");
              },
            ),
            body,
          ],
        ),
      ),
    );
  }

  AppTitleBar _buildTitle() {
    return const AppTitleBar(title: "Search", iconData: Icons.filter_list);
  }

  void _onSearchBarFocusChanged(bool hasFocus) {
    if (hasFocus) {
      _controller.onSearchInitiated();
    } else {
      _controller.onSearchCompleted(_searchController.text);
    }
  }

  Widget _buildSearchBody(BuildContext context) {
    switch (_state.state) {
      case SearchState.initial:
        return _buildGroups(_state.groups);
      case SearchState.results:
        return _buildResults(context);
      case SearchState.loading:
        return LinxLoadingSpinner();
      case SearchState.searching:
        return _buildRecentSearches(_state.recentSearches);
    }
  }

  Widget _buildRecentSearches(List<String> recents) {
    return RecentsSearchPage(
      recents: recents,
      onRecentsPressed: (search) => _onSearchInitiated(search),
    );
  }

  Widget _buildGroups(List<SearchGroup> groups) {
    return GroupSearchPage(
      groups: groups,
      onGroupPressed: (group) => _onSearchCategoryPressed(group),
    );
  }

  Widget _buildResults(BuildContext context) {
    if (_state.results!.users.isEmpty) {
      return EmptySearchPage();
    } else {
      return ResultsSearchPage(
        page: _state.results!,
        subtitle: _state.subtitle,
        onSmallCardPressed: (index) => _onProfileCardPressed(
          context: context,
          user: _state.results!.users[index],
        ),
      );
    }
  }

  void _onSearchCategoryPressed(SearchGroup groupSelected) {
    _controller.onSearchGroupSelected(groupSelected);
  }

  void _onSearchInitiated(String search) {
    _controller.onSearchCompleted(search);
    _searchController.text = search;
  }

  void _onProfileCardPressed({
    required BuildContext context,
    required LinxUser user,
  }) {
    var bottomSheet = SizedBox(
      height: context.height() * 0.80,
      child: ProfileBottomSheet(
        user: user,
        mainButtonText: "Send pitch",
        onXPressed: () => Navigator.maybePop(context),
        onMainButtonPressed: () {
          _onSendPitchPressed(user, context);
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

  void _onSendPitchPressed(LinxUser receiver, BuildContext context) {
    final screen = SendAPitchScreen(receiver: receiver);
    final builder = PageRouteBuilder(pageBuilder: (_, __, ___) => screen);
    Navigator.of(context).push(builder);
  }
}
