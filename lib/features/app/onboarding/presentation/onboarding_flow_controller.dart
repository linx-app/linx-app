import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/buttons/linx_toggle_buttons.dart';
import 'package:linx/features/user/domain/model/user_type.dart';

final onboardingControllerProvider = StateNotifierProvider.autoDispose<OnboardingController, OnboardingFlowUiState>((ref) {
  final userTypeToggleIndex = ref.watch(toggleButtonIndexSelectedProvider);
  final userType = UserType.values[userTypeToggleIndex];
  return OnboardingController(userType);
});

class OnboardingController extends StateNotifier<OnboardingFlowUiState> {
  final UserType type;

  OnboardingController(this.type): super(OnboardingFlowUiState(type: type)) {
    if (type == UserType.club) {
      state = OnboardingFlowUiState(totalSteps: 7);
    } else {
      state = OnboardingFlowUiState(totalSteps: 6);
    }
  }

  void onNextPressed(bool isStepRequired) {
    state = OnboardingFlowUiState(
        step: state.step + 1,
        isStepRequired: isStepRequired,
        totalSteps: state.totalSteps
    );
  }

  void onBackPressed(bool isStepRequired) {
    state = OnboardingFlowUiState(
      step: state.step - 1,
      isStepRequired: isStepRequired,
      totalSteps: state.totalSteps
    );
  }

  void reset() {
    state = OnboardingFlowUiState();
  }
}

class OnboardingFlowUiState {
  final int step;
  final bool isStepRequired;
  final int totalSteps;
  final UserType? type;

  OnboardingFlowUiState({
    this.step = 1,
    this.isStepRequired = true,
    this.totalSteps = 7,
    this.type,
  });
}
