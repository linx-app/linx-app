import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/domain/auth_service.dart';
import 'package:linx/features/authentication/domain/models/user_type.dart';
import 'package:linx/utils/validators.dart';

class SignUpController {
  final ProviderRef ref;
  late AuthService authService = ref.watch(AuthService.provider);

  static final provider = Provider((ref) => SignUpController(ref: ref));
  
  final TextEditingController emailController = TextEditingController();
  final emailErrorProvider = StateProvider<String?>((ref) => null);

  final TextEditingController passwordController = TextEditingController();
  final passwordErrorProvider = StateProvider<String?>((ref) => null);

  final TextEditingController confirmController = TextEditingController();

  SignUpController({required this.ref});

  Future<void> initiateSignUp(UserType userType) async {
    String email = emailController.value.text;
    String password = passwordController.value.text;
    String confirm = confirmController.value.text;

    String? emailError = TextValidation.validateEmail(email);
    String? passwordError = TextValidation.validatePassword(password, confirm);

    if (emailError != null) {
      ref.read(emailErrorProvider.notifier).state = emailError;
    }

    if (passwordError != null) {
      ref.read(passwordErrorProvider.notifier).state = passwordError;
    }

    if (emailError == null && passwordError == null) {
      authService.createUserWithEmailAndPassword(email, password, userType);
    }
  }
}
