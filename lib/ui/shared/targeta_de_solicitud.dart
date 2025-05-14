import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';

class Targetasolicitudes extends StatefulWidget {
  const Targetasolicitudes({
    super.key,
    required this.paciente,
    required this.motivo,
    required this.fecha,
    required this.hora,
    required this.ontopclose,
    required this.ontopmenssage,
    required this.bordertype,
    required this.pacienteontop,
  });
  final String paciente;
  final String motivo;
  final int bordertype;
  final String fecha;
  final String hora;
  final Function ontopmenssage;
  final Function ontopclose;
  final Function pacienteontop;

  @override
  State<Targetasolicitudes> createState() => _TargetasolicitudesState();
}

class _TargetasolicitudesState extends State<Targetasolicitudes> {
  get device => context.screenType() == ScreenType.desktop;

  @override
  Widget build(BuildContext context) {
    bool device = context.screenType() == ScreenType.desktop;
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.width > 450 ? 165 : 225,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: getBorderRadius(widget.bordertype),
          /* boxShadow: const [
            BoxShadow(
              color: Colors.grey, // Color de la sombra
              offset: Offset(0, 4), // Desplazamiento horizontal y vertical
              blurRadius: 6, // Radio del desenfoque de la sombra
              spreadRadius: 2, // Radio de expansión de la sombra
            ),
          ],*/
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: device
                  ? ((MediaQuery.of(context).size.width) * 0.84)
                  : ((MediaQuery.of(context).size.width) * 0.74),
              // margin: const EdgeInsets.all(12),
              child: device
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: targetacontents)
                  : MediaQuery.of(context).size.width < 450
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: targetacontents)
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: targetacontents),
            ),
            /*GestureDetector(
              onTap: () => widget.ontopclose(),
              child: Container(
                width: device
                    ? (MediaQuery.of(context).size.width) * 0.06
                    : (MediaQuery.of(context).size.width) * 0.16,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 94, 128, 206),
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(0),
                    topRight: getBorderRadius(widget.bordertype).topRight,
                    bottomLeft: const Radius.circular(0.0),
                    bottomRight: getBorderRadius(widget.bordertype).bottomRight,
                  ),
                ),
                child: const Center(
                    child: Icon(
                  Icons.close,
                  color: Colors.white,
                )),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  BorderRadius getBorderRadius(int bordertype) {
    switch (bordertype) {
      case 0:
        return const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0),
        );
      case 1:
        return const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        );
      // Cambia el radio para bordertype 1
      case 2:
        return const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        );
      // Cambia el radio para bordertype 2
      default:
        return BorderRadius.circular(
            15); // Valor predeterminado para cualquier otro caso
    }
  }

  List<Widget> get targetacontents {
    return [
      Container(
        decoration: BoxDecoration(
          color: AppColors.lightBorder,
          borderRadius: BorderRadius.only(
            topLeft: MediaQuery.of(context).size.width > 450
                ? getBorderRadius(widget.bordertype).topRight
                : const Radius.circular(0),
            topRight: const Radius.circular(0.0),
            bottomLeft: MediaQuery.of(context).size.width > 450
                ? getBorderRadius(widget.bordertype).bottomRight
                : const Radius.circular(0),
            bottomRight: const Radius.circular(0),
          ),
        ),

        // height: double.maxFinite,
        width: device
            ? (((MediaQuery.of(context).size.width) * 0.84) - 24) / 3
            : MediaQuery.of(context).size.width > 450
                ? (((MediaQuery.of(context).size.width) * 0.74) - 24) / 3
                : (((MediaQuery.of(context).size.width) * 0.74)),
        child: Center(
          child: GestureDetector(
            onTap: () => widget.pacienteontop(),
            child: Text(
              widget.paciente,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.normal,
                  //decoration: TextDecoration.underline,
                  fontSize: MediaQuery.of(context).size.width > 450
                      ? MediaQuery.of(context).size.width * 0.015
                      : MediaQuery.of(context).size.width * 0.035,
                  color: AppColors.blueBackground),
            ),
          ),
        ),
      ),
      SizedBox(
        //  height: double.maxFinite,
        width: device
            ? (((MediaQuery.of(context).size.width) * 0.84) - 24) / 3
            : MediaQuery.of(context).size.width > 450
                ? (((MediaQuery.of(context).size.width) * 0.74) - 24) / 3
                : (((MediaQuery.of(context).size.width) * 0.74)),
        child: Center(
          child: Text(
            widget.motivo,
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Outfit',
                //   fontSize: (width * 0.56) * 0.05,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: MediaQuery.of(context).size.width > 450
                    ? MediaQuery.of(context).size.width * 0.015
                    : MediaQuery.of(context).size.width * 0.035,
                color: AppColors.greenBackground),
          ),
        ),
      ),
      Container(
        color: AppColors.lightBorder,
        //   height: double.maxFinite,
        width: device
            ? (((MediaQuery.of(context).size.width) * 0.84) - 24) / 3
            : MediaQuery.of(context).size.width > 450
                ? (((MediaQuery.of(context).size.width) * 0.74) - 24) / 3
                : (((MediaQuery.of(context).size.width) * 0.74)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.fecha,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.normal,
                  fontSize: MediaQuery.of(context).size.width > 450
                      ? MediaQuery.of(context).size.width * 0.015
                      : MediaQuery.of(context).size.width * 0.035,
                  color: AppColors.greenBackground),
            ),
            Text(
              widget.hora,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width > 450
                      ? MediaQuery.of(context).size.width * 0.015
                      : MediaQuery.of(context).size.width * 0.035,
                  color: AppColors.blueBackground),
            ),
          ],
        ),
      ),
      /*SizedBox(
        height:
            MediaQuery.of(context).size.width > 450 ? double.maxFinite : null,
        // height: double.maxFinite,
        width: device
            ? (((MediaQuery.of(context).size.width) * 0.84) - 24) / 4
            : MediaQuery.of(context).size.width > 450
                ? (((MediaQuery.of(context).size.width) * 0.74) - 24) / 4
                : (((MediaQuery.of(context).size.width) * 0.74)),

        child: GestureDetector(
          onTap: () => widget.ontopmenssage(),
          child: Container(
              decoration: BoxDecoration(
                color: AppColors.blueBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              margin:
                  EdgeInsets.all((MediaQuery.of(context).size.width) * 0.045),
              child: const Icon(
                Icons.message_sharp,
                color: Colors.white,
              )),
        ),
      )*/
    ];
  }
}
