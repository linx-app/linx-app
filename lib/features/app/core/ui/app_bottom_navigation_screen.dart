import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/chat/chat_home_screen.dart';
import 'package:linx/features/app/core/presentation/app_bottom_nav_screen_controller.dart';
import 'package:linx/features/app/core/presentation/model/in_app_state.dart';
import 'package:linx/features/app/discover/presentation/discover_screen_controller.dart';
import 'package:linx/features/app/discover/ui/discover_screen.dart';
import 'package:linx/features/app/match/ui/matches_screen.dart';
import 'package:linx/features/app/pitch/ui/pitches_screen.dart';
import 'package:linx/features/app/request/presentation/request_screen_controller.dart';
import 'package:linx/features/app/request/ui/request_screen.dart';
import 'package:linx/features/app/search/presentation/search_screen_controller.dart';
import 'package:linx/features/app/search/ui/search_screen.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';

final _bottomNavigationStateProvider = StateProvider<int>((ref) => 0);

class AppBottomNavigationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(_bottomNavigationStateProvider);
    final uiState = ref.watch(appBottomNavScreenControllerProvider);

    if (uiState.state == InAppState.loading) {
      return LinxLoadingSpinner();
    } else {
      final user = uiState.currentUser!;
      final bottomNavItems = user.info.isClub()
          ? _getClubBottomNavBarItems(selectedIndex)
          : _getBusinessBottomNavBarItems(selectedIndex);
      final body = _buildBody(ref, user, selectedIndex);

      return BaseScaffold(
        bottomNav: BottomNavigationBar(
          unselectedLabelStyle: _getLabelTextStyle(false),
          selectedLabelStyle: _getLabelTextStyle(true),
          selectedItemColor: _getSelectedColor(true),
          unselectedItemColor: _getSelectedColor(false),
          type: BottomNavigationBarType.fixed,
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(index, ref),
          items: bottomNavItems,
        ),
        body: Center(child: body),
      );
    }
  }

  Widget _buildBody(WidgetRef ref, LinxUser user, int selectedIndex) {
    final isClub = user.info.isClub();
    final thirdScreen = isClub ? PitchesScreen() : MatchesScreen();
    List<Widget> pages = [
      _buildFirstScreen(ref, user, isClub),
      _buildSecondScreen(ref, user, isClub),
      thirdScreen,
      ChatHomeScreen(),
    ];
    final body = pages.elementAt(selectedIndex);
    return body;
  }

  void _onItemTapped(int index, WidgetRef ref) {
    ref.read(_bottomNavigationStateProvider.notifier).state = index;
  }

  List<BottomNavigationBarItem> _getClubBottomNavBarItems(int selectedIndex) {
    return [
      BottomNavigationBarItem(
        icon: _iconWidget(path: "leaf.png", isSelected: selectedIndex == 0),
        label: "Discover",
      ),
      BottomNavigationBarItem(
        icon: _iconWidget(path: "search.png", isSelected: selectedIndex == 1),
        label: "Search",
      ),
      BottomNavigationBarItem(
        icon: _iconWidget(path: "pitch.png", isSelected: selectedIndex == 2),
        label: "Pitches",
      ),
      BottomNavigationBarItem(
        icon: _iconWidget(path: "chat.png", isSelected: selectedIndex == 3),
        label: "Chat",
      )
    ];
  }

  List<BottomNavigationBarItem> _getBusinessBottomNavBarItems(
      int selectedIndex) {
    return [
      BottomNavigationBarItem(
        icon: _iconWidget(path: "leaf.png", isSelected: selectedIndex == 0),
        label: "Requests",
      ),
      BottomNavigationBarItem(
        icon: _iconWidget(path: "search.png", isSelected: selectedIndex == 1),
        label: "Discover",
      ),
      BottomNavigationBarItem(
        icon: _iconWidget(path: "match.png", isSelected: selectedIndex == 2),
        label: "Matches",
      ),
      BottomNavigationBarItem(
        icon: _iconWidget(path: "chat.png", isSelected: selectedIndex == 3),
        label: "Chat",
      )
    ];
  }

  SizedBox _iconWidget({required String path, bool isSelected = false}) {
    return SizedBox(
      height: 24,
      width: 24,
      child: Image.asset(
        "assets/$path",
        color: _getSelectedColor(isSelected),
      ),
    );
  }

  Color _getSelectedColor(bool isSelected) {
    Color color;
    if (isSelected) {
      color = LinxColors.green;
    } else {
      color = LinxColors.grey;
    }
    return color;
  }

  TextStyle _getLabelTextStyle(bool isSelected) {
    return TextStyle(
        color: _getSelectedColor(isSelected),
        fontSize: 11.0,
        fontWeight: FontWeight.w500);
  }

  Widget _buildFirstScreen(WidgetRef ref, LinxUser user, bool isClub) {
    if (isClub) {
      final state = ref.watch(discoverScreenControllerProvider);
      final controller = ref.watch(discoverScreenControllerProvider.notifier);
      return DiscoverScreen(state, controller);
    } else {
      final state = ref.watch(requestScreenControllerProvider);
      final controller = ref.watch(requestScreenControllerProvider.notifier);
      return RequestScreen(state, controller);
    }
  }

  Widget _buildSecondScreen(WidgetRef ref, LinxUser user, bool isClub) {
    if (isClub) {
      final state = ref.watch(searchScreenControllerProvider);
      final controller = ref.watch(searchScreenControllerProvider.notifier);
      return SearchScreen(state, controller);
    } else {
      final state = ref.watch(discoverScreenControllerProvider);
      final controller = ref.watch(discoverScreenControllerProvider.notifier);
      return DiscoverScreen(state, controller);
    }
  }
}
