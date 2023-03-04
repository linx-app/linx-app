import 'package:flutter/material.dart';
import 'package:linx/common/linx_text_field.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const SearchBar({super.key, required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: LinxTextField(
        label: label,
        controller: controller,
        prefixIcon: _buildSearchIcon(),
      ),
    );
  }

  Icon _buildSearchIcon() {
    return Icon(Icons.search);
  }
}
