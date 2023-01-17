import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/user/domain/model/user_type.dart';
import 'package:linx/features/authentication/presentation/signup_controller.dart';
import 'package:linx/features/authentication/ui/widgets/password_text_field.dart';
import 'package:linx/features/authentication/ui/widgets/user_type_toggle_button.dart';
import 'package:linx/features/onboarding/ui/widgets/onboarding_view.dart';
import 'package:linx/utils/ui_extensions.dart';

class SignUpScreen extends OnboardingView {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  final Function(UserType) onSignUpCompleted;
  final List<Widget> _userTypeTexts = <Widget>[
    const UserTypeToggleButton(label: "Club/Team", index: 0),
    const UserTypeToggleButton(label: "Business", index: 1),
  ];

  @override
  late String pageTitle = "Create Account";

  SignUpScreen({required this.onSignUpCompleted});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        buildOnboardingStepTitle(context),
        _buildUserTypeToggle(context, ref),
        _buildEmailTextField(),
        _buildPasswordTextField("Password", _passwordController),
        _buildPasswordTextField("Confirm password", _confirmController)
      ],
    );
  }

  @override
  void onBackPressed() {}

  @override
  Future<bool> onNextPressedAsync(WidgetRef ref) async {
    var notifier = ref.read(signUpControllerProvider.notifier);
    var userType = ref.read(userTypeToggleStateProvider);
    var email = _emailController.text;
    var password = _passwordController.text;
    var confirm = _confirmController.text;
    var signUpSuccess =
        await notifier.initiateSignUp(email, password, confirm, userType);

    onSignUpCompleted(userType);
    return true;
    if (signUpSuccess) {
      onScreenCompleted();
      return true;
    } else {
      return false;
    }
  }

  Container _buildUserTypeToggle(BuildContext context, WidgetRef ref) {
    List<bool> isUserTypeSelected = ref.watch(userTypeToggleStateListProvider);

    return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: const BoxDecoration(
        color: LinxColors.black_5,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: ToggleButtons(
        borderColor: LinxColors.transparent,
        selectedBorderColor: LinxColors.transparent,
        splashColor: LinxColors.transparent,
        isSelected: isUserTypeSelected,
        constraints: BoxConstraints(
          minHeight: 10.0,
          minWidth: (context.width() - 58.0) / 2,
        ),
        onPressed: (int index) {
          _onUserToggledPressed(index, ref);
        },
        children: _userTypeTexts,
      ),
    );
  }

  Container _buildEmailTextField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
      child: LinxTextField(
        label: "Email",
        controller: _emailController,
      ),
    );
  }

  Container _buildPasswordTextField(String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
      child: PasswordTextField(
        label: label,
        controller: controller,
      ),
    );
  }

  void _onUserToggledPressed(int index, WidgetRef ref) {
    ref.read(userTypeToggleStateProvider.notifier).state =
        UserType.values[index];
  }
}
