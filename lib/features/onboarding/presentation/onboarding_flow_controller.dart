import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/features/authentication/domain/models/user_type.dart';
import 'package:linx/features/authentication/ui/widgets/user_type_toggle_button.dart';

class OnboardingController {
  final ProviderRef ref;

  static final provider = Provider((ref) => OnboardingController(ref: ref));

  final stepRequiredProvider = StateProvider((ref) => true);
  final stepProvider = StateProvider((ref) => 1);
  final totalStepsProvider = StateProvider((ref) {
    if (ref.watch(userTypeToggleStateProvider) == UserType.club) {
      return 7;
    } else {
      return 6;
    }
  });

  OnboardingController({required this.ref});

  String getStepCountText(int step, int totalSteps, bool isStepRequired) {
    if (isStepRequired) {
      return "STEP $step OF $totalSteps";
    } else {
      return "STEP $step OF $totalSteps (OPTIONAL)";
    }
  }

  void onNextPressed() {
    int step = ref.read(stepProvider);
    ref.read(stepProvider.notifier).state = step + 1;
  }

  void onBackPressed() {
    int step = ref.read(stepProvider);
    ref.read(stepProvider.notifier).state = step - 1;
  }

  void reset() {
    ref.read(stepProvider.notifier).state = 1;
    ref.read(stepRequiredProvider.notifier).state = true;
  }
}