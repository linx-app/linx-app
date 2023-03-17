import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/chat/presentation/chat_list_screen_controller.dart';
import 'package:linx/features/app/chat/ui/chat_list_screen.dart';
import 'package:linx/features/app/chat/ui/chat_screen.dart';
import 'package:linx/features/app/core/presentation/app_bottom_nav_screen_controller.dart';
import 'package:linx/features/app/core/presentation/model/in_app_state.dart';
import 'package:linx/features/app/core/ui/widgets/new_match_bottom_sheet.dart';
import 'package:linx/features/app/discover/presentation/discover_screen_controller.dart';
import 'package:linx/features/app/discover/ui/discover_screen.dart';
import 'package:linx/features/app/match/presentation/matches_screen_controller.dart';
import 'package:linx/features/app/match/ui/matches_screen.dart';
import 'package:linx/features/app/pitch/presentation/pitches_screen_controller.dart';
import 'package:linx/features/app/pitch/ui/pitches_screen.dart';
import 'package:linx/features/app/request/presentation/request_screen_controller.dart';
import 'package:linx/features/app/request/ui/request_screen.dart';
import 'package:linx/features/app/search/presentation/search_screen_controller.dart';
import 'package:linx/features/app/search/ui/search_screen.dart';
import 'package:linx/features/notifications/domain/model/fcm_notification.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/model/user_info.dart';

final _bottomNavigationStateProvider = StateProvider<int>((ref) => 0);

class AppBottomNavigationScreen extends ConsumerWidget {
  final _notificationBadgeStyle = const TextStyle(
      fontSize: 10, fontWeight: FontWeight.w500, color: LinxColors.white);
  final TextEditingController _discoverSearchController =
      TextEditingController();
  final TextEditingController _searchSearchController = TextEditingController();

  void dispose() {
    _discoverSearchController.dispose();
    _searchSearchController.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(_bottomNavigationStateProvider);
    final uiState = ref.watch(appBottomNavScreenControllerProvider);

    if (uiState.state == InAppState.loading) {
      return LinxLoadingSpinner();
    } else {
      final user = uiState.currentUser!;
      _handleNotifications(context, ref, uiState.notification);
      final bottomNavItems = user.info.isClub()
          ? _getClubBottomNavBarItems(selectedIndex, user)
          : _getBusinessBottomNavBarItems(selectedIndex, user);
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
    List<Widget> pages = [
      _buildFirstScreen(ref, user, isClub),
      _buildSecondScreen(ref, user, isClub),
      _buildThirdScreen(ref, user, isClub),
      _buildFourthScreen(ref, user, isClub),
    ];
    final body = pages.elementAt(selectedIndex);
    return body;
  }

  void _onItemTapped(int index, WidgetRef ref) {
    ref.read(_bottomNavigationStateProvider.notifier).state = index;
  }

  List<BottomNavigationBarItem> _getClubBottomNavBarItems(
    int selectedIndex,
    LinxUser user,
  ) {
    final newMatches = user.info.newMatches;
    final newChats = user.info.newChats.length;

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
        icon: _iconWidget(
          path: "pitch.png",
          isSelected: selectedIndex == 2,
          newAmount: newMatches.length,
        ),
        label: "Pitches",
      ),
      BottomNavigationBarItem(
        icon: _iconWidget(
          path: "chat.png",
          isSelected: selectedIndex == 3,
          newAmount: newChats,
        ),
        label: "Chat",
      )
    ];
  }

  List<BottomNavigationBarItem> _getBusinessBottomNavBarItems(
    int selectedIndex,
    LinxUser user,
  ) {
    final newPitches = user.info.numberOfNewPitches;
    final newChats = user.info.newChats.length;

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
        icon: _iconWidget(
          path: "match.png",
          isSelected: selectedIndex == 2,
          newAmount: newPitches,
        ),
        label: "Matches",
      ),
      BottomNavigationBarItem(
        icon: _iconWidget(
          path: "chat.png",
          isSelected: selectedIndex == 3,
          newAmount: newChats,
        ),
        label: "Chat",
      )
    ];
  }

  SizedBox _iconWidget({
    required String path,
    bool isSelected = false,
    int newAmount = 0,
  }) {
    final badge = newAmount == 0
        ? Empty()
        : Container(
            alignment: Alignment.topRight,
            child: CircleAvatar(
              radius: 8,
              backgroundColor: LinxColors.red,
              child: Center(
                child: Text("$newAmount", style: _notificationBadgeStyle),
              ),
            ),
          );
    return SizedBox(
      height: 24,
      width: 24,
      child: Stack(
        children: [
          Center(
            child: Image.asset(
              "assets/$path",
              color: _getSelectedColor(isSelected),
            ),
          ),
          badge,
        ],
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
      return DiscoverScreen(state, controller, null);
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
      return SearchScreen(state, controller, _searchSearchController);
    } else {
      final state = ref.watch(discoverScreenControllerProvider);
      final controller = ref.watch(discoverScreenControllerProvider.notifier);
      return DiscoverScreen(state, controller, _discoverSearchController);
    }
  }

  Widget _buildThirdScreen(WidgetRef ref, LinxUser user, bool isClub) {
    if (isClub) {
      final state = ref.watch(pitchesScreenControllerProvider);
      final controller = ref.watch(pitchesScreenControllerProvider.notifier);
      return PitchesScreen(state, controller);
    } else {
      final state = ref.watch(matchesScreenControllerProvider);
      final controller = ref.watch(matchesScreenControllerProvider.notifier);
      return MatchesScreen(state, controller);
    }
  }

  Widget _buildFourthScreen(WidgetRef ref, LinxUser user, bool isClub) {
    final state = ref.watch(chatListScreenControllerProvider);
    final controller = ref.watch(chatListScreenControllerProvider.notifier);
    return ChatListScreen(user, state, controller);
  }

  void _handleNotifications(
    BuildContext context,
    WidgetRef ref,
    FCMNotification? notif,
  ) {
    if (notif == null) return;
    if (notif is NewMessageNotification) {
      if (notif.wasClickedOnBackground) {
        final route = MaterialPageRoute(builder: (_) => ChatScreen());
        Navigator.of(context).push(route);
      }
    } else if (notif is NewMatchNotification) {
      if (notif.wasClickedOnBackground) {
        _onItemTapped(2, ref);
      }
      _showNewMatchBottomSheet(context, notif);
    } else if (notif is NewPitchNotification) {
      if (notif.wasClickedOnBackground) {
        _onItemTapped(2, ref);
      }
    }
  }

  void _showNewMatchBottomSheet(
    BuildContext context,
    NewMatchNotification notif,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Wrap(
        children: [
          NewMatchBottomSheet(
            notification: notif,
            onButtonPressed: () {},
          ),
        ],
      ),
      barrierColor: Colors.black.withOpacity(0.60),
      shape: RoundedBorder.clockwise(10, 10, 0, 0),
    );
  }
}
