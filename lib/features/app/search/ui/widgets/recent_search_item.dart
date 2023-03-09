import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';

class RecentSearchItem extends StatelessWidget {
  final String search;
  final VoidCallback onPressed;

  const RecentSearchItem({
    super.key,
    required this.search,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(0, 6, 24, 6),
              child: Image.asset(
                "search.png",
                height: 20,
                width: 20,
              ),
            ),
            Expanded(
              child: Text(
                search,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: LinxColors.subtitleGrey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
