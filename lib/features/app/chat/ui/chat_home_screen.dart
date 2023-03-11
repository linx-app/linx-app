import 'package:flutter/material.dart';
import 'package:linx/common/base_scaffold.dart';
import 'package:linx/features/app/core/ui/widgets/app_title_bar.dart';
import 'package:linx/utils/ui_extensions.dart';

class ChatHomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: context.height() * 0.1),
            AppTitleBar(title: "Messages"),

          ],
        )
      )
    );
  }
}