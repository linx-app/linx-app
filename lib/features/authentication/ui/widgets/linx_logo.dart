import 'package:flutter/material.dart';

class LinxLogo extends StatelessWidget {
  final double width;
  final double height;

  const LinxLogo({super.key, this.width = 78.0, this.height = 102.0});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/logo_with_name.png",
      height: height,
      width: width,
    );
  }
}
