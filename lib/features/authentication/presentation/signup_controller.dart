import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/domain/auth_service.dart';

class SignUpController {
  final ProviderRef ref;
  late AuthService authService = ref.watch(AuthService.provider);

  static final provider = Provider((ref) => SignUpController(ref: ref));
  
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  SignUpController({required this.ref});

  Future<void> initiateSignUp() async {

  }
}
