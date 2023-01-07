import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/constants/colors.dart';

class PasswordTextField extends ConsumerWidget {
  final _passwordObscureTextStateProvider = StateProvider((ref) => true);
  final String label;
  final TextEditingController controller;

  PasswordTextField({
    super.key,
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LinxTextField(
      label: label,
      controller: controller,
      icon: _passwordVisibilityIcon(ref),
      shouldObscureText: ref.watch(_passwordObscureTextStateProvider),
    );
  }

  Widget _passwordVisibilityIcon(WidgetRef ref) {
    bool obscureText = ref.watch(_passwordObscureTextStateProvider);
    IconData icon;
    if (obscureText) {
      icon = Icons.visibility;
    } else {
      icon = Icons.visibility_off;
    }
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        _onVisibilityIconPressed(ref, obscureText);
      },
      color: LinxColors.black,
    );
  }

  void _onVisibilityIconPressed(WidgetRef ref, bool obscureText) {
    ref.read(_passwordObscureTextStateProvider.notifier).state = !obscureText;
  }
}
