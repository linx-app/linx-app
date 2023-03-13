import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:linx/common/linx_loading_spinner.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/text.dart';
import 'package:linx/features/app/core/ui/app_bottom_navigation_screen.dart';
import 'package:linx/features/authentication/ui/landing_screen.dart';
import 'package:linx/firebase/firebase_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
  runApp(
    const ProviderScope(
      child: LinxApp(),
    ),
  );
}

Future<void> _fcmBackgroundHandler(RemoteMessage message) async {

}

class LinxApp extends ConsumerWidget {
  const LinxApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return MaterialApp(
      title: 'LINX application',
      theme: ThemeData(
        fontFamily: "Inter",
        colorScheme: LinxColors.colorScheme,
        textTheme: LinxTextStyles.theme,
      ),
      home: authState.when(
        data: (data) {
          if (data != null) {
            return AppBottomNavigationScreen();
          } else {
            return const LandingScreen();
          }
        },
        error: (e, trace) => LinxLoadingSpinner(),
        loading: () => LinxLoadingSpinner(),
      ),
    );
  }
}
