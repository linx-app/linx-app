import 'package:flutter/material.dart';
import 'package:linx/common/linx_text_field.dart';

class LinxForm extends StatelessWidget {

  LinxTextField field;
  AutovalidateMode autovalidateMode;

  LinxForm({super.key, required this.autovalidateMode, required this.field});

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: autovalidateMode,
      child: field,
    );
  }
}