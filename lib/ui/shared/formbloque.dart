import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';

Widget formbloque(
    BuildContext context,
    String text,
    TextEditingController controller,
    GlobalKey<FormState> formKey,
    double sizewidth,
    bool write,
    {Color? headerColor = AppColors.blueBackground,
    Color? bagColor = const Color.fromRGBO(120, 144, 156, 1),
    String? hintText,
    bool enabled = true}) {
  bool device = context.screenType() == ScreenType.desktop;
  return Column(
    children: [
      SizedBox(
        width: device ? (sizewidth * 0.55) * 0.8 : (sizewidth) * 0.8,
        child: text != ' '
            ? Row(
                children: [
                  Text(
                    text,
                    style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: device
                            ? (sizewidth * 0.45) * 0.029
                            : (sizewidth) * 0.05,
                        fontWeight: FontWeight.w500,
                        color: headerColor),
                  )
                ],
              )
            : null,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 4.0, // Ajusta este valor para el grosor del borde
                color: bagColor!, // Utiliza el color deseado
              ),
            ),
            width: device ? (sizewidth * 0.55) * 0.8 : (sizewidth) * 0.8,
            child:  TextFormField(
              readOnly: write,
              enabled: enabled,
              textAlign: TextAlign.left,
              controller: controller,
              style: const TextStyle(
                color: Colors.black
              ),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none, // No border
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none, // No border
                  borderRadius: BorderRadius.circular(15),
                ),

                //filled: true,
                fillColor: Colors.transparent,
                labelStyle: const TextStyle(fontSize: 12),
              ),
              cursorColor:
                  AppColors.blueBackground, // Cambio de color de cursor
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Rellena este campo';
                } else {
                  return null;
                }
              },
            ),),
      ),
      const SizedBox(height: 12),
    ],
  );
}