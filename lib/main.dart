import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/features/authentication/ui/landing_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: LinxApp(),
    ),
  );
}

final firebaseInitializerProvider = FutureProvider<FirebaseApp>((ref) async {
  return await Firebase.initializeApp();
});

class LinxApp extends ConsumerWidget {
  const LinxApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseInitialization = ref.watch(firebaseInitializerProvider);
    return MaterialApp(
      title: 'LINX application',
      theme: ThemeData(
        fontFamily: "Inter",
        colorScheme: LinxColors.colorScheme,
        textTheme: LinxTextStyles.theme,
      ),
      home: firebaseInitialization.when(
        data: (data) => const LandingScreen(),
        error: (e, st) => const LandingScreen(), // TODO: Network error screen
        loading: () => const LandingScreen(), //  TODO: Loading screen
      ),
    );
  }
}
