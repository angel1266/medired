import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';

class Targetapaciente extends StatefulWidget {
  const Targetapaciente({
    required this.nombre,
    required this.correo,
    required this.tipoUsuario,
    required this.suscripcionActiva,
    super.key,
  });
  final String nombre;
  final String correo;
  final String tipoUsuario;
  final bool suscripcionActiva; // Cambiado a un tipo booleano

  @override
  State<Targetapaciente> createState() => _TargetapacienteState();
}

class _TargetapacienteState extends State<Targetapaciente> {
  @override
  Widget build(BuildContext context) {
    bool device = context.screenType() == ScreenType.desktop;
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey, // Color de la sombra
              offset: Offset(0, 4), // Desplazamiento horizontal y vertical
              blurRadius: 6, // Radio del desenfoque de la sombra
              spreadRadius: 2, // Radio de expansión de la sombra
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: device
                  ? (MediaQuery.of(context).size.width * 0.56) * 0.05
                  : (MediaQuery.of(context).size.width) * 0.05,
              decoration: BoxDecoration(
                color: AppColors.greenBackground,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Container(
              width: device
                  ? (MediaQuery.of(context).size.width * 0.56) * 0.8
                  : (MediaQuery.of(context).size.width) * 0.8,
              margin: const EdgeInsets.all(12),
              child: device
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: targetacontents,
                    )
                  : MediaQuery.of(context).size.width < 450
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: targetacontents,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: targetacontents,
                        ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> get targetacontents {
    return [
      Text(
        widget.nombre, // Cambiado al campo de "nombre"
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.normal,
          color: AppColors.blueBackground,
        ),
      ),
      Text(
        widget.correo, // Cambiado al campo de "correo"
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.normal,
          color: AppColors.blueBackground,
        ),
      ),
      Text(
        'Tipo de Usuario: ${widget.tipoUsuario}', // Cambiado al campo de "tipoUsuario"
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.normal,
          color: AppColors.blueBackground,
        ),
      ),
      Text(
        "Suscripción Activa: ${widget.suscripcionActiva ? 'Sí' : 'No'}", // Cambiado al campo de "suscripcionActiva"
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontWeight: FontWeight.normal,
          color: AppColors.blueBackground,
        ),
      ),
    ];
  }
}
