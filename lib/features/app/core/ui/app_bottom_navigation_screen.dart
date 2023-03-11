import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/chat/chat_home_screen.dart';
import 'package:linx/features/app/core/presentation/app_bottom_nav_screen_controller.dart';
import 'package:linx/features/app/discover/ui/discover_screen.dart';
import 'package:linx/features/app/match/ui/matches_screen.dart';
import 'package:linx/features/app/pitch/ui/pitches_screen.dart';
import 'package:linx/features/app/request/ui/request_screen.dart';
import 'package:linx/features/app/search/ui/search_screen.dart';
import 'package:linx/features/user/domain/model/user_info.dart';
import 'package:linx/features/user/domain/model/user_type.dart';

final _bottomNavigationStateProvider = StateProvider<int>((ref) => 0);

class AppBottomNavigationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedIndex = ref.watch(_bottomNavigationStateProvider);
    var uiState = ref.watch(appBottomNavScreenControllerProvider);

    var bottomNavItems = uiState.currentUser?.type == UserType.club
        ? _getClubBottomNavBarItems(selectedIndex)
        : _getBusinessBottomNavBarItems(selectedIndex);
    var body = _buildBody(uiState.currentUser, selectedIndex);

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

  Widget _buildBody(UserInfo? info, int selectedIndex) {
    Widget body;
    if (info == null) {
      body = LinxLoadingSpinner();
    } else {
      final isClub = info.isClub();
      final firstScreen = isClub ? DiscoverScreen() : RequestScreen();
      final secondScreen = isClub ? SearchScreen() : DiscoverScreen();
      final thirdScreen = isClub ? PitchesScreen() : MatchesScreen();
      List<Widget> pages = [
        firstScreen,
        secondScreen,
        thirdScreen,
        ChatHomeScreen(),
      ];
      body = pages.elementAt(selectedIndex);
    }
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
}
