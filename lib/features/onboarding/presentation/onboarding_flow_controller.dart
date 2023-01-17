import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/user/domain/model/user_type.dart';
import 'package:linx/features/authentication/ui/widgets/user_type_toggle_button.dart';

final onboardingControllerProvider = StateNotifierProvider<OnboardingController, OnboardingFlowUiState>((ref) {
  return OnboardingController(ref.watch(userTypeToggleStateProvider));
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
