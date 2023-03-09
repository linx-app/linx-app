import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/buttons/linx_close_button.dart';
import 'package:linx/common/linx_text_field.dart';

class SearchBar extends ConsumerWidget {
  final TextEditingController controller;
  final String label;
  final void Function(bool) onFocusChanged;
  final VoidCallback? onXPressed;

  SearchBar({
    super.key,
    required this.controller,
    required this.label,
    required this.onFocusChanged,
    this.onXPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: LinxTextField(
        label: label,
        controller: controller,
        prefixIcon: _buildSearchIcon(),
        suffixIcon: _buildXIcon(ref),
        onFocusChanged: onFocusChanged,
        maxLines: 1,
      ),
    );
  }

  Icon _buildSearchIcon() {
    return const Icon(Icons.search);
  }

  Widget _buildXIcon(WidgetRef ref) {
    return LinxCloseButton(onXPressed: () => onXPressed?.call());
  }
}
