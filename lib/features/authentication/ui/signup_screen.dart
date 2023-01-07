import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/features/authentication/presentation/signup_controller.dart';
import 'package:linx/features/authentication/ui/widgets/password_text_field.dart';
import 'package:linx/features/onboarding/onboarding_view.dart';
import 'package:linx/utils/ui_extensions.dart';

import '../domain/models/user_type.dart';

const double _doubleWidthPadding = 58.0;

final userTypeToggleStateProvider = StateProvider((ref) => UserType.club);

final _userTypeToggleStateListProvider = Provider<List<bool>>((ref) {
  final userType = ref.watch(userTypeToggleStateProvider);
  if (userType == UserType.club) {
    return <bool>[true, false];
  } else {
    return <bool>[false, true];
  }
});

class SignUpScreen extends ConsumerWidget implements OnboardingView {
  late SignUpController _controller;

  SignUpScreen({super.key});

  final List<Widget> _userTypeTexts = <Widget>[
    const _UserToggleButton(label: "Club/Team", index: 0),
    const _UserToggleButton(label: "Business", index: 1),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _controller = ref.read(SignUpController.provider);
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
            isSelected: ref.watch(_userTypeToggleStateListProvider),
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

class _UserToggleButton extends ConsumerWidget {
  final String label;
  final int index;
  final double _buttonRadius = 8.0;
  final double _buttonMinHeight = 10.0;
  final TextStyle _selectedTextStyle = const TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    color: LinxColors.backButtonGrey,
  );
  final TextStyle _unselectedTextStyle = const TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    color: LinxColors.backButtonGrey,
  );

  const _UserToggleButton({
    required this.label,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double buttonMinWidth = (context.width() - _doubleWidthPadding) / 2;
    bool isSelected = ref.watch(userTypeToggleStateProvider).index == index;
    TextStyle style;
    Color backgroundColor;
    BoxBorder? border;

    if (isSelected) {
      style = _selectedTextStyle;
      backgroundColor = LinxColors.white;
      border = const Border.fromBorderSide(
        BorderSide(color: LinxColors.black_4),
      );
    } else {
      style = _unselectedTextStyle;
      backgroundColor = LinxColors.transparent;
    }

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
        borderRadius: BorderRadius.all(Radius.circular(_buttonRadius)),
      ),
      constraints: BoxConstraints(
        minHeight: _buttonMinHeight,
        minWidth: buttonMinWidth,
      ),
      child: Center(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: style,
        ),
      ),
    );
  }
}
