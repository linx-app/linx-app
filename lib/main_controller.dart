import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/domain/auth_service.dart';

final mainControllerProvider = StateNotifierProvider<MainController, MainUiState>((ref) {
  return MainController(ref.read(AuthService.provider));
});

class MainController extends StateNotifier<MainUiState> {
  final AuthService _authService;

  MainController(this._authService): super(MainUiState()) {
    initialize();
  }

  Future<void> initialize() async {
    _authService.isUserLoggedIn().listen((event) async {
      var firstTime = await _authService.isFirstTimeInApp();
      state = MainUiState(isFirstTimeInApp: firstTime, isUserFound: event);
    });
  }
}

class MainUiState {
  final bool isFirstTimeInApp;
  final bool isUserFound;

  MainUiState({this.isFirstTimeInApp = true, this.isUserFound = false});
}