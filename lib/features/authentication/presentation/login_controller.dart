import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/domain/login_service.dart';
import 'package:linx/features/authentication/domain/models/auth_response.dart';
import 'package:linx/utils/validators.dart';

final logInControllerProvider = StateNotifierProvider<LogInController, LogInUiState>((ref) {
  return LogInController(ref.read(LogInService.provider));
});

class LogInController extends StateNotifier<LogInUiState> {
  final LogInService _logInService;

  LogInController(this._logInService): super(LogInUiState());

  Future<bool> onLogInPressed(String email, String password) async {
    String? emailError = TextValidation.validateEmail(email);
    AuthResponse? response;

    if (email.isNotEmpty && emailError == null) {
      response = await _logInService.attemptLogIn(email, password);
    } else {
      state = LogInUiState(emailError: emailError);
      return false;
    }

    if (response is AuthSuccess) {
      return true;
    } else {
      state = LogInUiState(logInError: response.authMessage);
      return false;
    }
  }
}

class LogInUiState {
  final String? emailError;
  final String? logInError;

  LogInUiState({this.emailError, this.logInError});
}