import 'package:flutter/material.dart';

class RoundedBorder {
  static RoundedRectangleBorder all(double radius) {
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)));
  }

  static RoundedRectangleBorder clockwise(
    double topLeft,
    double topRight,
    double bottomRight,
    double bottomLeft,
  ) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeft),
        topRight: Radius.circular(topRight),
        bottomLeft: Radius.circular(bottomLeft),
        bottomRight: Radius.circular(bottomRight),
      ),
    );
  }
}
