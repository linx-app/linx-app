import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/authentication/domain/models/user_type.dart';
import 'package:linx/features/authentication/presentation/signup_controller.dart';
import 'package:linx/features/authentication/ui/widgets/password_text_field.dart';
import 'package:linx/features/authentication/ui/widgets/user_type_toggle_button.dart';
import 'package:linx/features/onboarding/onboarding_view.dart';
import 'package:linx/utils/ui_extensions.dart';

class SignUpScreen extends ConsumerWidget implements OnboardingView {
  late SignUpController _controller;

  SignUpScreen({super.key});

  final List<Widget> _userTypeTexts = <Widget>[
    const UserTypeToggleButton(label: "Club/Team", index: 0),
    const UserTypeToggleButton(label: "Business", index: 1),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _controller = ref.read(SignUpController.provider);
    List<bool> isUserTypeSelected = ref.watch(userTypeToggleStateListProvider);

    return Column(
      children: [
        Container(
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
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 10.0),
          child: LinxTextField(
            label: "Email",
            controller: _controller.emailController,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: PasswordTextField(
            label: "Password",
            controller: _controller.passwordController,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: PasswordTextField(
            label: "Confirm Password",
            controller: _controller.confirmController,
          ),
        ),
      ],
    );
  }

  @override
  void onBackPressed() {}

  @override
  void onNextPressed() async {
    _controller.initiateSignUp();
  }

  void _onUserToggledPressed(int index, WidgetRef ref) {
    ref.read(userTypeToggleStateProvider.notifier).state = UserType.values[index];
  }

  @override
  String pageTitle() => "Create Account";
}
