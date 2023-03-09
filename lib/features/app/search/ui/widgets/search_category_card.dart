import 'package:flutter/material.dart';
import 'package:linx/common/rounded_border.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/search/domain/model/search_group.dart';
import 'package:linx/utils/ui_extensions.dart';

class SearchCategoryCard extends StatelessWidget {
  final SearchGroup group;
  final VoidCallback onPressed;
  final TextStyle _firstLineStyle = const TextStyle(
    fontWeight: FontWeight.w700,
    color: LinxColors.white,
    fontSize: 16,
  );
  final TextStyle _secondLineStyle = TextStyle(
      fontWeight: FontWeight.w400,
      color: LinxColors.white.withOpacity(0.67),
      fontSize: 14);

  SearchCategoryCard({
    super.key,
    required this.group,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedBorder.all(6),
      color: LinxColors.black,
      margin: const EdgeInsets.fromLTRB(4, 4, 4, 4),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.bottomLeft,
          height: context.height() * 0.15,
          width: context.width() * 0.35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(group.category.capitalize(), style: _firstLineStyle),
              Text("${group.users.length} near you", style: _secondLineStyle),
            ],
          ),
        ),
      ),
    );
  }
}
