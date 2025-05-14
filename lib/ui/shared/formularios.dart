import 'package:flutter/material.dart';
import 'package:medired/ui/constants/ui_helper.dart';
import 'package:medired/ui/shared/textformfiel.dart';

Widget formularios(
  BuildContext context,
  List<String> texts,
  List<TextEditingController> controllers,
  List<String> hinstext,
  int model,
  GlobalKey<FormState> formKey,
  double sizewidth,
  bool write, {
  Color? headerColor = Colors.white,
  Color? bagColor = const Color.fromRGBO(255, 255, 255, 0.7),
  List<bool>? passwordmode,
}) {
  bool device = context.screenType() == ScreenType.desktop;
  passwordmode ??= List.generate(texts.length, (index) => false);
  return SizedBox(
    child: Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: controllers.asMap().entries.map((entry) {
          
          final int index = entry.key;
          final TextEditingController controller = entry.value;
          final bool isPassword =
              index < passwordmode!.length ? passwordmode[index] : false;
          return Textformfiel(
            device: device,
            password: isPassword,
            text: texts[index],
            sizewidth: sizewidth,
            headerColor: headerColor,
            controller: controller,
            bagColor: bagColor,
            hinstext: hinstext[index],
            write: write,
          );
        }).toList(),
      ),
    ),
  );
}
