import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/domain/auth_service.dart';
import 'package:linx/features/authentication/domain/models/user_type.dart';
import 'package:linx/utils/validators.dart';

final signUpControllerProvider = StateNotifierProvider<SignUpController, SignUpUiState>((ref) {
  return SignUpController(
    ref.read(AuthService.provider)
  );
});

class SignUpController extends StateNotifier<SignUpUiState> {
  final AuthService _authService;

  SignUpController(this._authService): super(SignUpUiState());

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

    if (emailError == null && passwordError == null) {
      await _authService.createUserWithEmailAndPassword(email, password, userType);
      return true;
    } else {
      // TODO: Implement validation display (https://github.com/linx-app/linx-app/issues/14)
      state = SignUpUiState(emailError: emailError, passwordError: passwordError);
      return false;
    }
  }
}

class SignUpUiState {
  final String? emailError;
  final String? passwordError;

  SignUpUiState({this.emailError, this.passwordError});
}
