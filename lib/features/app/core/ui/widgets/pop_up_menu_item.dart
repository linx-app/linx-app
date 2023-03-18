import 'package:flutter/material.dart';
import 'package:linx/common/empty.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/app/core/ui/model/sort_item.dart';

PopupMenuItem<SortItem> buildMenuItem(
  SortItem item,
  SortItem selected,
  String line1,
  String line2,
) {
  final check = item == selected
      ? const Icon(Icons.check, color: LinxColors.green)
      : Empty();

  const line1Style = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 17,
    color: LinxColors.subtitleGrey,
  );

  const line2Style = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 15,
    color: LinxColors.subtitleGrey,
  );

  return PopupMenuItem(
    value: item,
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(line1, style: line1Style),
              Text(line2, style: line2Style),
            ],
          ),
        ),
        check,
      ],
    ),
  );
}
