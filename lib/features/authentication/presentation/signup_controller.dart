import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/domain/models/auth_response.dart';
import 'package:linx/features/authentication/domain/signup_service.dart';
import 'package:linx/features/user/domain/model/user_type.dart';
import 'package:linx/utils/validators.dart';

final signUpControllerProvider =
    StateNotifierProvider<SignUpController, SignUpUiState>((ref) {
  return SignUpController(ref.read(SignUpService.provider));
});

class SignUpController extends StateNotifier<SignUpUiState> {
  final SignUpService _signUpService;

  SignUpController(this._signUpService) : super(SignUpUiState());

  final emailErrorProvider = StateProvider<String?>((ref) => null);
  final passwordErrorProvider = StateProvider<String?>((ref) => null);

  Future<bool> initiateSignUp(
    String email,
    String password,
    String confirm,
    UserType userType,
  ) async {
    String? emailError = TextValidation.validateEmail(email);
    String? passwordError = TextValidation.validatePassword(password, confirm);
    AuthResponse? response;

    if (emailError == null && passwordError == null) {
      response = await _signUpService.createUserWithEmailAndPassword(
        email,
        password,
        userType,
      );
    } else {
      state = SignUpUiState(
        emailError: emailError,
        passwordError: passwordError,
      );
      return false;
    }

    if (response is AuthSuccess) {
      return true;
    } else {
      state = SignUpUiState(signUpError: response.authMessage);
      return false;
    }
  }
}

class SignUpUiState {
  final String? emailError;
  final String? passwordError;
  final String? signUpError;

  SignUpUiState({this.emailError, this.passwordError, this.signUpError,});
}
