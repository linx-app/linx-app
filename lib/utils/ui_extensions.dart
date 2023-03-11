import 'package:flutter/material.dart';

extension UiExtensions on BuildContext {
  double height() {
    return MediaQuery.of(this).size.height;
  }

  double width() {
    return MediaQuery.of(this).size.width;
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

extension DateTimeExtension on DateTime {
  String toDisplayTime() {
    final now = DateTime.now();
    final diffInDays = now.difference(this).inDays;

    if (diffInDays < 1) {
      return "Today";
    } else if (diffInDays == 1) {
      return "1 day ago";
    } else if (diffInDays < 7) {
      return "$diffInDays days ago";
    } else if (diffInDays < 14) {
      return "1 week ago";
    } else {
      return "${diffInDays % 7} weeks ago";
    }
  }
}
