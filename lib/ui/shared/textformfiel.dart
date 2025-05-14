import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Textformfiel extends StatefulWidget {
  const Textformfiel({
    super.key,
    required this.device,
    required this.text,
    required this.sizewidth,
    required this.write,
    this.password = false,
    required this.controller,
    required this.hinstext,
    this.headerColor = Colors.white,
    this.bagColor = Colors.white,
  });

  final bool write;
  final bool password;
  final String hinstext;
  final TextEditingController controller;
  final Color? bagColor;
  final bool device;
  final String text;
  final double sizewidth;
  final Color? headerColor;

  @override
  State<Textformfiel> createState() => _TextformfielState();
}

class _TextformfielState extends State<Textformfiel> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: widget.device
              ? (widget.sizewidth * 0.55) * 0.5
              : (widget.sizewidth) * 0.9,
          child: Row(
            children: [
              Text(
                widget.text,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.w300,
                  color: widget.headerColor,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: SizedBox(
            width: widget.device
                ? (widget.sizewidth * 0.55) * 0.5
                : (widget.sizewidth) * 0.9,
            child: TextFormField(
              obscureText: widget.password,
              obscuringCharacter: '*',
              readOnly: widget.write,
              textAlign: TextAlign.center,
              controller: widget.controller,
              maxLength: _getMaxLength(),
              inputFormatters: _getInputFormatters(),
              decoration: InputDecoration(
                  hintText: widget.hinstext,
                  hintStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(33, 57, 118, 0.4),
                  ),
                  filled: true,
                  fillColor: widget.bagColor,
                  labelStyle: const TextStyle(fontSize: 12),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  errorText: errorText),
              cursorColor: Colors.blue,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return _validateField(value);
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  int? _getMaxLength() {
    switch (widget.text) {
      case 'Nombre de la empresa':
        return 45;
      case 'Tipo de empresa':
        return 30;
      case 'Correo electrónico':
        return 45;
      case 'Teléfono':
        return 10;
      case 'Acerca de tus servicios':
        return 200;
      default:
        return null;
    }
  }

  List<TextInputFormatter> _getInputFormatters() {
    switch (widget.text) {
      case 'Nombre de la empresa':
      case 'Tipo de empresa':
        return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))];
      case 'Teléfono':
        return [FilteringTextInputFormatter.digitsOnly];
      case 'Correo electrónico':
        return [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@.]'))];
      default:
        return [];
    }
  }

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Rellena este campo';
    }

    switch (widget.text) {
      case 'Nombre de la empresa':
        if (value.length > 45) {
          return 'Máximo 45 caracteres';
        }
        break;
      case 'Tipo de empresa':
        if (value.length > 30) {
          return 'Máximo 30 caracteres';
        }
        if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
          return 'Solo se permiten letras';
        }
        break;
      case 'Correo electrónico':
        if (value.length > 45) {
          return 'Máximo 45 caracteres';
        }
        if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+$')
            .hasMatch(value)) {
          return 'Correo electrónico inválido';
        }
        break;
      case 'Teléfono':
        if (value.length != 10) {
          return 'Debe tener exactamente 10 dígitos';
        }
        break;
      case 'Acerca de tus servicios':
        if (value.length > 200) {
          return 'Máximo 200 caracteres';
        }
        break;
    }

    return null;
  }
}
