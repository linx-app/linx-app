import 'package:flutter/material.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;

  const BaseScaffold({super.key, required this.body, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(MediaQuery
              .of(context)
              .padding
              .top),
          child: SizedBox(
            height: MediaQuery
                .of(context)
                .padding
                .top,
          ),
        ),
        body: body,
        backgroundColor: backgroundColor,
    );
  }
}