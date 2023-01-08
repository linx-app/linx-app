import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingBasicInfoController {
  final ProviderRef ref;

  static final provider = Provider((ref) => OnboardingBasicInfoController(ref: ref));

  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final locationController = TextEditingController();

  OnboardingBasicInfoController({required this.ref});
}