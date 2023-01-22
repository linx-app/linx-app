import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/common/buttons/linx_text_button.dart';
import 'package:linx/common/buttons/rounded_button.dart';
import 'package:linx/common/linx_text_field.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/routes.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/features/authentication/presentation/login_controller.dart';
import 'package:linx/features/authentication/ui/widgets/linx_logo.dart';
import 'package:linx/features/authentication/ui/widgets/password_text_field.dart';
import 'package:linx/utils/ui_extensions.dart';

class LogInScreen extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(logInControllerProvider);
    return BaseScaffold(
      backgroundColor: LinxColors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: context.height() - MediaQuery.of(context).padding.top,
          width: context.width(),
          child: Column(
            children: [
              Container(
                alignment: Alignment.bottomCenter,
                height: 185,
                child: const LinxLogo(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTitle(),
                    _buildSubtitle(),
                    _buildEmailTextField(state.emailError),
                    _buildPasswordTextField(state.logInError),
                    _buildLogInButton(context, ref),
                    _buildForgotPasswordButton(context),
                  ],
                ),
              ),
              _buildSignUpText(context),
            ],
          ),
        ),
      ),
    );
  }

  void _onSignUpPressed(BuildContext context) {
    Navigator.of(context).popAndPushNamed(routeOnboardingStart);
  }

  void _onLogInPressed(BuildContext context, WidgetRef ref) async {
    var email = _emailController.text;
    var password = _passwordController.text;

    var notifier = ref.read(logInControllerProvider.notifier);
    await notifier.onLogInPressed(email, password);
  }

  void _onForgetPasswordPressed(BuildContext context) {}

  Container _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: const Text(
        "Welcome back to LINX!",
        style: LinxTextStyles.subtitle,
      ),
    );
  }

  Container _buildSubtitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: const Text(
        "Log in now to start connecting",
        style: LinxTextStyles.regular,
      ),
    );
  }

  Container _buildEmailTextField(String? error) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: LinxTextField(label: "Email", controller: _emailController, errorText: error,),
    );
  }

  Container _buildPasswordTextField(String? error) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
        child: PasswordTextField(
            label: "Password",
            controller: _passwordController,
            errorText: error,
        ),
    );
  }

  Container _buildLogInButton(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: RoundedButton(
        style: greenButtonStyle(),
        onPressed: () => _onLogInPressed(context, ref),
        text: "Log In",
      ),
    );
  }

  Container _buildForgotPasswordButton(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: LinxTextButton(
        label: "Forgot password?",
        tint: LinxColors.green,
        onPressed: () => _onForgetPasswordPressed(context),
      )
    );
  }

  Container _buildSignUpText(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't have an account?"),
          LinxTextButton(
            label: "Sign up!",
            onPressed: () => _onSignUpPressed(context),
            tint: LinxColors.green,
          ),
        ],
      ),
    );
  }
}
