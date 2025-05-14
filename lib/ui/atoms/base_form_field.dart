import 'package:flutter/material.dart';

class BaseFormField extends StatelessWidget {
  const BaseFormField(
    this.title, {
    required this.formField,
    super.key,
  });

  final Text title;
  final Widget formField;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          formField,
        ].expand((element) => [const SizedBox(height: 10), element]).toList(),
      );
    });
  }
}
