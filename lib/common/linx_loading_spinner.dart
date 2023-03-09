import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';

class LinxLoadingSpinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: LinxColors.green,
        backgroundColor: LinxColors.background,
      ),
    );
  }
}
