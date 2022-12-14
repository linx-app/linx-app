import 'package:flutter/material.dart';
import 'package:linx/constants/colors.dart';
import 'package:linx/constants/text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LINX application',
      theme: ThemeData(
        fontFamily: "Inter",
        colorScheme: LinxColors.colorScheme,
        textTheme: linxTextTheme(),
      ),
      home: const InitialScreen(title: 'LINX Application'),
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "This is the LINX application",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}