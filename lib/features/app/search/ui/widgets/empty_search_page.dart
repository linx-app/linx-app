import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/utils/ui_extensions.dart';

class EmptySearchPage extends StatelessWidget {
  final _firstLineStyle = const TextStyle(
    color: LinxColors.subtitleGrey,
    fontSize: 17,
    fontWeight: FontWeight.w500,
  );

  final _secondLineStyle = const TextStyle(
    color: LinxColors.subtitleGrey,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height() * 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("empty_search.png", width: context.width() * 0.5),
          Text("No results found", style: _firstLineStyle),
          Text("Try broadening your search", style: _secondLineStyle)
        ],
      ),
    );
  }
}
