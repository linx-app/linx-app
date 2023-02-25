import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/routes.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/features/app/core/ui/app_bottom_navigation_screen.dart';
import 'package:linx/features/app/home/ui/profile_modal_screen.dart';
import 'package:linx/features/authentication/ui/landing_screen.dart';
import 'package:linx/features/authentication/ui/login_screen.dart';
import 'package:linx/features/debug/widget_testing_screen.dart';
import 'package:linx/features/onboarding/ui/onboarding_flow_screen.dart';
import 'package:linx/main_controller.dart';

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
    final state = ref.read(mainControllerProvider);
    String initialRoute;

    if (state.isFirstTimeInApp) {
      initialRoute = routeLanding;
    } else if (state.isUserFound) {
      initialRoute = routeLogIn; // TODO: Change to redirect to home
    } else {
      initialRoute = routeLogIn;
    }

    return MaterialApp(
      title: 'LINX application',
      theme: ThemeData(
        fontFamily: "Inter",
        colorScheme: LinxColors.colorScheme,
        textTheme: LinxTextStyles.theme,
      ),
      onGenerateRoute: (settings) {
        late Widget page;

        switch (settings.name) {
          case routeLanding:
            page = const LandingScreen();
            break;
          case routeLogIn:
            page = LogInScreen();
            break;
          case routeApp:
            page = AppBottomNavigationScreen();
            break;
          case routeDebugWidgetTesting:
            page = WidgetTestingScreen();
            break;
          case routeProfileModal:
            page = ProfileModalScreen(0, [], []);
            break;
          default:
            if (settings.name!.startsWith(routeOnboardingRoot)) {
              final subRoute = settings.name!.substring(
                  routeOnboardingRoot.length);
              page = OnboardingFlowScreen(initialRoute: subRoute);
            } else {
              throw Exception("Unknown route: ${settings.name}");
            }
        }

        return MaterialPageRoute(
          builder: (context) => page,
          settings: settings,
        );
      },
      initialRoute: initialRoute,
    );
  }
}
