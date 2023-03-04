import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/constants/colors.dart';

class PasswordTextField extends ConsumerWidget {
  final _passwordObscureTextStateProvider = StateProvider((ref) => true);
  final String label;
  final TextEditingController controller;
  final String? errorText;

  PasswordTextField({
    super.key,
    required this.label,
    required this.controller,
    this.errorText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LinxTextField(
      label: label,
      controller: controller,
      suffixIcon: _passwordVisibilityIcon(ref),
      shouldObscureText: ref.watch(_passwordObscureTextStateProvider),
      maxLines: 1,
      errorText: errorText,
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
