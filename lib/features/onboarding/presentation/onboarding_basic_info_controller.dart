import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingBasicInfoController {
  final ProviderRef ref;

  static final provider = Provider((ref) => OnboardingBasicInfoController(ref: ref));

  OnboardingBasicInfoController({required this.ref});
}