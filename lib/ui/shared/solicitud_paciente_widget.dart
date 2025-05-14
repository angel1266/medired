import 'package:flutter/material.dart';
import 'package:medired/core/value_objects/titulos.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';
import 'package:medired/ui/shared/custom_flat_button.dart';

class Solicitudpaciente extends StatefulWidget {
  const Solicitudpaciente({
    super.key,
  });

  @override
  State<Solicitudpaciente> createState() => _SolicitudpacienteState();
}

class _SolicitudpacienteState extends State<Solicitudpaciente> {
  // solcitude de citas

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool device = context.screenType() == ScreenType.desktop;
    Color lettercolor = MediaQuery.of(context).size.width > 450
        ? AppColors.blueBackground
        : Colors.white;
    double lettersize = MediaQuery.of(context).size.width > 450
        ? MediaQuery.of(context).size.width * 0.025
        : MediaQuery.of(context).size.width * 0.07;
    TextAlign textaling = MediaQuery.of(context).size.width > 450
        ? TextAlign.left
        : TextAlign.center;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(MediaQuery.of(context).size.width * 0.09),
        topRight: Radius.circular(MediaQuery.of(context).size.width * 0.09),
        bottomLeft: const Radius.circular(0.0),
        bottomRight: const Radius.circular(0.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: (MediaQuery.of(context).size.height * 0.93),
        color: AppColors.blueBackground,
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
          child: SingleChildScrollView(
              child: Column(
            children: [
              Text(
                'Solicitud Paciente',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: device
                        ? MediaQuery.of(context).size.width * 0.06
                        : MediaQuery.of(context).size.width * 0.08,
                    fontFamily: 'Outfit',
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 30,
              ),
              pacienteContents(device, lettercolor, lettersize, textaling),
              const SizedBox(
                height: 30,
              ),
            ],
          )),
        ),
      ),
    );
  }

  Widget pacienteContents(bool device, Color lettercolor, double lettersize,
          TextAlign textaling) =>
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                  Radius.circular(MediaQuery.of(context).size.width * 0.01))),
          child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.015),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(MediaQuery.of(context).size.width * 0.01)),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.5, 0.5],
                  colors: [
                    AppColors.blueBackground,
                    MediaQuery.of(context).size.width > 450
                        ? const Color.fromRGBO(95, 125, 201, 0.1)
                        : AppColors.blueBackground,
                  ], // Colores para la mitad izquierda y derecha respectivamente
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // pendiente
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: MediaQuery.of(context).size.width > 450
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: compornentes(
                                lettercolor, lettersize, textaling),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: compornentes(
                                lettercolor, lettersize, textaling),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  List<Widget> compornentes(
      Color lettercolor, double lettersize, TextAlign textaling) {
    return [
      SizedBox(
          width: MediaQuery.of(context).size.width > 450
              ? MediaQuery.of(context).size.width * 0.425
              : MediaQuery.of(context).size.width * 0.850,
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.lightBorder,
                radius: MediaQuery.of(context).size.width > 450
                    ? MediaQuery.of(context).size.width * 0.08
                    : MediaQuery.of(context).size.width * 0.25,
                child: ClipRRect(
                  child: FittedBox(
                    fit: BoxFit
                        .cover, // Ajusta la imagen para llenar el espacio sin cortarla
                    child: Image(
                      height: MediaQuery.of(context).size.width > 450
                          ? MediaQuery.of(context).size.width * 0.10
                          : MediaQuery.of(context).size.width * 0.25,
                      image: const AssetImage('assets/images/userbg.png'),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: titulosTypeToString[TitulosType.title2]!
                    .asMap()
                    .map((index, titulo) {
                      return MapEntry(
                        index,
                        apartado(
                            titulo,
                            'campo',
                            AppColors.greenBackground,
                            Colors.white,
                            lettersize,
                            textaling),
                      );
                    })
                    .values
                    .toList(),
              ),
            ],
          )),
      SizedBox(
        width: MediaQuery.of(context).size.width > 450
            ? MediaQuery.of(context).size.width * 0.425
            : MediaQuery.of(context).size.width * 0.850,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            apartado('Motivo', 'solicitud.motivo', AppColors.greenBackground,
                lettercolor, lettersize, textaling),
            apartado('Síntomas', 'solicitud.sintomas',
                AppColors.greenBackground, lettercolor, lettersize, textaling),
            apartado('Cita', 'solicitud.fecha', AppColors.greenBackground,
                lettercolor, lettersize, textaling),
            Text(
              'solicitud.hora',
              textAlign: textaling,
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontSize: lettersize,
                  color: lettercolor),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CustomFlatButton(
                  buttonColor: AppColors.greenBackground,
                  textColor: Colors.white,
                  fontsize: lettersize,
                  text: 'Confirmar Solicitud',
                  onPressed: () {
                    // por realizar
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CustomFlatButton(
                  buttonColor: Colors.white,
                  textColor: Colors.black,
                  fontsize: lettersize,
                  text: 'Cancelar Solicitud',
                  onPressed: () {
                    // por realizar
                  }),
            )
          ],
        ),
      )
    ];
  }

  Column apartado(String titulo, String text, Color titlecolor,
      Color title2color, double lettersize, TextAlign textaling) {
    return Column(
      children: [
        Text(
          titulo,
          textAlign: textaling,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: lettersize,
            color: titlecolor,
          ),
        ),
        Text(
          text,
          textAlign: textaling,
          style: TextStyle(
              fontFamily: 'Outfit',
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontSize: lettersize,
              color: title2color),
        ),
      ],
    );
  }
}
