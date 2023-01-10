import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/constants/colors.dart';

class LinxChip extends ConsumerWidget {
  final TextStyle _chipTextStyle = const TextStyle(
    color: LinxColors.chipTextGrey,
    fontWeight: FontWeight.w400,
    fontSize: 12.0,
  );
  final String label;
  final Function(bool, String) onChipSelected;
  final _isSelectedProvider = StateProvider((ref) => false);

  LinxChip({super.key, required this.label, required this.onChipSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isSelected = ref.watch(_isSelectedProvider);
    return FilterChip(
      label: _getChipLabel(),
      labelStyle: _chipTextStyle,
      backgroundColor: LinxColors.chipBackground,
      shape: StadiumBorder(
          side: BorderSide(
              color: _getSelectedColor(isSelected),
              width: _getSelectedWidth(isSelected),
          )
      ),
      onSelected: (selected) => _onSelected(selected, ref),
      labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }

  void _onSelected(bool selected, WidgetRef ref) {
    bool wasSelected = ref.read(_isSelectedProvider);
    ref.read(_isSelectedProvider.notifier).state = !wasSelected;
    onChipSelected(!wasSelected, label);
  }

  Text _getChipLabel() {
    return Text(label, style: _chipTextStyle);
  }

  Color _getSelectedColor(bool isSelected) {
    if (isSelected) {
      return LinxColors.green;
    } else {
      return LinxColors.stroke;
    }
  }

  double _getSelectedWidth(bool isSelected) {
    if (isSelected) {
      return 1.5;
    } else {
      return 1.0;
    }
  }
}