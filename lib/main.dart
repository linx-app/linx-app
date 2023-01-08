import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/routes.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/features/authentication/ui/landing_screen.dart';
import 'package:linx/features/onboarding/ui/onboarding_flow.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: LinxApp(),
    ),
  );
}

class LinxApp extends ConsumerWidget {
  const LinxApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'LINX application',
      theme: ThemeData(
        fontFamily: "Inter",
        colorScheme: LinxColors.colorScheme,
        textTheme: LinxTextStyles.theme,
      ),
      onGenerateRoute: (settings) {
        late Widget page;

        if (settings.name == routeLanding) {
          page = const LandingScreen();
        } else if (settings.name!.startsWith(routeOnboardingRoot)) {
          final subRoute = settings.name!.substring(routeOnboardingRoot.length);
          page = OnboardingFlow(initialRoute: subRoute);
        } else {
          throw Exception("Unknown route: ${settings.name}");
        }

        return MaterialPageRoute(
          builder: (context) {
            return page;
          },
          settings: settings,
        );
      },
    );
  }
}
