import 'package:flutter/material.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';

List<BottomNavigationBarItem> buildClubBottomNavBarItems(
  int selectedIndex,
  LinxUser user,
) {
  final newMatches = user.info.newMatches;
  final newChats = user.info.newChats.length;

  return [
    BottomNavigationBarItem(
      icon: _item(
        label: "Discover",
        path: "leaf.png",
        isSelected: selectedIndex == 0,
      ),
      label: "",
    ),
    BottomNavigationBarItem(
      icon: _item(
        label: "Search",
        path: "search.png",
        isSelected: selectedIndex == 1,
      ),
      label: "",
    ),
    BottomNavigationBarItem(
      icon: _item(
        label: "Pitches",
        path: "pitch.png",
        isSelected: selectedIndex == 2,
        newAmount: newMatches.length,
      ),
      label: "",
    ),
    BottomNavigationBarItem(
      icon: _item(
        label: "Chat",
        path: "chat.png",
        isSelected: selectedIndex == 3,
        newAmount: newChats,
      ),
      label: "",
    )
  ];
}

List<BottomNavigationBarItem> buildBusinessBottomNavBarItems(
  int selectedIndex,
  LinxUser user,
) {
  final newPitches = user.info.numberOfNewPitches;
  final newChats = user.info.newChats.length;

  return [
    BottomNavigationBarItem(
      icon: _item(
        label: "Requests",
        path: "leaf.png",
        isSelected: selectedIndex == 0,
        newAmount: newPitches,
      ),
      label: "",
    ),
    BottomNavigationBarItem(
      icon: _item(
        label: "Discover",
        path: "search.png",
        isSelected: selectedIndex == 1,
      ),
      label: "",
    ),
    BottomNavigationBarItem(
      icon: _item(
        label: "Matches",
        path: "match.png",
        isSelected: selectedIndex == 2,
      ),
      label: "",
    ),
    BottomNavigationBarItem(
      icon: _item(
        label: "Chat",
        path: "chat.png",
        isSelected: selectedIndex == 3,
        newAmount: newChats,
      ),
      label: "",
    )
  ];
}

Container _item({
  required String path,
  required String label,
  bool isSelected = false,
  int newAmount = 0,
}) {
  final color = isSelected ? LinxColors.green : LinxColors.grey;
  final badge = _buildNotificationBadge(newAmount);
  final labelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: color,
  );

  return Container(
    padding: const EdgeInsets.only(top: 5),
    child: Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 6, left:6, right: 6),
              child: Image.asset(
                "assets/$path",
                color: color,
                height: 24,
                width: 24,
              ),
            ),
            Positioned(right: 0, child: badge),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 2),
          alignment: Alignment.bottomCenter,
          child: Text(
            label,
            style: labelStyle,
          ),
        ),
      ],
    ),
  );
}

Widget _buildNotificationBadge(
  int newAmount,
) {
  const notificationBadgeStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: LinxColors.white,
  );

  return newAmount == 0
      ? Empty()
      : CircleAvatar(
          radius: 8,
          backgroundColor: LinxColors.red,
          child: Center(
            child: Text("$newAmount", style: notificationBadgeStyle),
          ),
        );
}
