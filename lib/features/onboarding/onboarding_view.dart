import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class OnboardingView extends ConsumerWidget {
  String pageTitle();
  void onNextPressed();
  void onBackPressed();
}