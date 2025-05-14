import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';

class FormBloqueValidated extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;
  final double sizewidth;
  final bool write;
  final Color? headerColor;
  final Color? bagColor;
  final String? hintText;
  final bool enabled;
  final int? maxLength;
  final bool? emailValidation;

  const FormBloqueValidated({
    super.key,
    required this.text,
    required this.controller,
    required this.formKey,
    required this.sizewidth,
    required this.write,
    this.headerColor = AppColors.blueBackground,
    this.bagColor = const Color.fromRGBO(120, 144, 156, 1),
    this.hintText,
    this.enabled = true,
    this.maxLength,
    this.emailValidation = false,
  });

  @override
  _FormBloqueValidatedState createState() => _FormBloqueValidatedState();
}

class _FormBloqueValidatedState extends State<FormBloqueValidated> {
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    bool device = context.screenType() == ScreenType.desktop;

    return Column(
      children: [
        SizedBox(
          width: device
              ? (widget.sizewidth * 0.55) * 0.8
              : (widget.sizewidth) * 0.8,
          child: widget.text != ' '
              ? Row(
                  children: [
                    Text(
                      widget.text,
                      style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: device
                              ? (widget.sizewidth * 0.45) * 0.029
                              : (widget.sizewidth) * 0.05,
                          fontWeight: FontWeight.w500,
                          color: widget.headerColor),
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
                color: widget.bagColor!, // Utiliza el color deseado
              ),
            ),
            width: device
                ? (widget.sizewidth * 0.55) * 0.8
                : (widget.sizewidth) * 0.8,
            child: TextFormField(
              readOnly: widget.write,
              enabled: widget.enabled,
              textAlign: TextAlign.left,
              controller: widget.controller,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength:
                  widget.maxLength, // Aplicar maxLength si se proporciona
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none, // No border
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none, // No border
                  borderRadius: BorderRadius.circular(15),
                ),
                fillColor: Colors.transparent,
                labelStyle: const TextStyle(fontSize: 12),
                errorText:
                    _errorText, // Mostrar mensaje de error en tiempo real
              ),
              cursorColor: AppColors.blueBackground,
              validator: (value) {
                return _validate(value); // Validación estándar
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  String? _validate(String? value) {
    if (value!.isEmpty) {
      return 'Rellena este campo';
    }

    // Validación para el nombre: solo letras
    if (widget.text.toLowerCase().contains('nombre') &&
        !RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'El nombre solo puede contener letras';
    }

    // Validación para el correo electrónico: letras, números, sin símbolos
    if (widget.emailValidation == true &&
        !RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+$').hasMatch(value)) {
      return 'Introduce un correo válido';
    }

    // Validación para otros campos (ej. mensaje): admite letras, números, y símbolos
    if (widget.text.toLowerCase().contains('mensaje')) {
      // Aquí se admite todo, así que no hay validación adicional
    }

    return null;
  }
}
