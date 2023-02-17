import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/chat/chat_home_screen.dart';
import 'package:linx/features/app/home/ui/home_screen.dart';
import 'package:linx/features/app/pitches/pitches_screen.dart';
import 'package:linx/features/app/search/search_home_sreen.dart';

final _bottomNavigationStateProvider = StateProvider<int>((ref) => 0);

class AppBottomNavigationScreen extends ConsumerWidget {
  
  List<Widget> _pages = [
    HomeScreen(),
    SearchHomeScreen(),
    PitchesScreen(),
    ChatHomeScreen()
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedIndex = ref.watch(_bottomNavigationStateProvider);

    return BaseScaffold(
      bottomNav: BottomNavigationBar(
        unselectedLabelStyle: _getLabelTextStyle(false),
        selectedLabelStyle: _getLabelTextStyle(true),
        selectedItemColor: _getSelectedColor(true),
        unselectedItemColor: _getSelectedColor(false),
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (index) => _onItemTapped(index, ref),
        items: [
          BottomNavigationBarItem(
              icon: _iconWidget(
                  path: "leaf.png",
                  isSelected: selectedIndex == 0
              ),
              label: "Discover",
          ),
          BottomNavigationBarItem(
            icon: _iconWidget(
                path: "search.png",
                isSelected: selectedIndex == 1
            ),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: _iconWidget(
                path: "pitch.png",
                isSelected: selectedIndex == 2
            ),
            label: "Pitches",
          ),
          BottomNavigationBarItem(
            icon: _iconWidget(
                path: "chat.png",
                isSelected: selectedIndex == 3
            ),
            label: "Chat",
          )
        ],
      ),
      body: Center(
        child: _pages.elementAt(selectedIndex)
      ),
    );
  }

  void _onItemTapped(int index, WidgetRef ref) {
    ref.read(_bottomNavigationStateProvider.notifier).state = index;
  }

  Container _iconWidget({required String path, bool isSelected = false}) {
    return Container(
        height: 24,
        width: 24,
        child: Image.asset("assets/$path", color: _getSelectedColor(isSelected))
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
      fontWeight: FontWeight.w500
    );
  }
}