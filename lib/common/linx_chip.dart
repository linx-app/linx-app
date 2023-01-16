import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/utils/ui_extensions.dart';

class LinxChip extends StatelessWidget {
  final TextStyle _chipTextStyle = const TextStyle(
    color: LinxColors.chipTextGrey,
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
  );
  final String label;
  final Function(String) onChipSelected;
  final bool isSelected;

  LinxChip({super.key, required this.label, required this.onChipSelected, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: _getChipLabel(),
      labelStyle: _chipTextStyle,
      backgroundColor: LinxColors.chipBackground,
      shape: StadiumBorder(
          side: BorderSide(
              color: _getSelectedColor(),
              width: _getSelectedWidth(),
          )
      ),
      onSelected: _onSelected,
      labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }

  void _onSelected(bool selected) => onChipSelected(label);

  Text _getChipLabel() => Text(label.capitalize(), style: _chipTextStyle);

  Color _getSelectedColor() {
    if (isSelected) {
      return LinxColors.green;
    } else {
      return LinxColors.stroke;
    }
  }

  double _getSelectedWidth() {
    if (isSelected) {
      return 1.5;
    } else {
      return 1.0;
    }
  }
}