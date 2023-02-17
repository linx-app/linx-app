import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/domain/model/linx_user.dart';
import 'package:linx/features/user/domain/user_service.dart';

final appBottomNavScreenControllerProvider = StateNotifierProvider<AppBottomNavScreenController, AppBottomNavScreenUiState>((ref) {
  return AppBottomNavScreenController(ref.read(UserService.provider));
});

class AppBottomNavScreenController extends StateNotifier<AppBottomNavScreenUiState> {
  AppBottomNavScreenController(this._userService): super(AppBottomNavScreenUiState()) {
    initialize();
  }

  final UserService _userService;

  Future<void> initialize() async {
    var user = await _userService.fetchUserProfile();
    state = AppBottomNavScreenUiState(currentUser: user);
  }
}

class AppBottomNavScreenUiState {
  final LinxUser? currentUser;
  AppBottomNavScreenUiState({this.currentUser});
}