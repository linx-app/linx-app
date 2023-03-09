import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/buttons/linx_toggle_buttons.dart';
import 'package:linx/common/buttons/toggle_button.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/features/app/onboarding/ui/widgets/onboarding_view.dart';
import 'package:linx/features/authentication/presentation/signup_controller.dart';
import 'package:linx/features/authentication/ui/widgets/password_text_field.dart';
import 'package:linx/features/user/domain/model/user_type.dart';

class SignUpScreen extends OnboardingView {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final Function(UserType) onSignUpCompleted;

  SignUpScreen({
    required super.onScreenCompleted,
    required this.onSignUpCompleted,
  }) : super(pageTitle: "Create account");

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(signUpControllerProvider);
    return Column(
      children: [
        buildOnboardingStepTitle(context),
        _buildUserTypeToggle(context, ref),
        _buildEmailTextField(state.emailError ?? state.signUpError),
        _buildPasswordTextField(
          "Password",
          _passwordController,
          state.passwordError,
        ),
        _buildPasswordTextField(
          "Confirm password",
          _confirmController,
          state.passwordError,
        )
      ],
    );
  }

  @override
  Future<bool> onNextPressedAsync(WidgetRef ref) async {
    final notifier = ref.read(signUpControllerProvider.notifier);
    final userTypeIndex = ref.read(toggleButtonIndexSelectedProvider);
    final userType = UserType.values[userTypeIndex];
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirm = _confirmController.text;
    final signUpSuccess = await notifier.initiateSignUp(
      email,
      password,
      confirm,
      userType,
    );

    if (signUpSuccess) {
      onSignUpCompleted(userType);
      return true;
    } else {
      return false;
    }
  }

  Widget _buildUserTypeToggle(BuildContext context, WidgetRef ref) {
    return const LinxToggleButtons(
      ToggleButton(label: "Club/Team", index: 0),
      ToggleButton(label: "Business", index: 1),
    );
  }

  Container _buildEmailTextField(String? error) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
      child: LinxTextField(
        label: "Email",
        controller: _emailController,
        errorText: error,
      ),
    );
  }

  Container _buildPasswordTextField(
    String label,
    TextEditingController controller,
    String? error,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
      child: PasswordTextField(
        label: label,
        controller: controller,
        errorText: error,
      ),
    );
  }

  @override
  void onScreenPopped() {
    // No-op
  }

  @override
  void onScreenPushed(WidgetRef ref) {
    // No-op
  }
}
