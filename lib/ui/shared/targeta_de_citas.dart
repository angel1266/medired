import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';

class Targetacitas extends StatelessWidget {
  const Targetacitas(
      {super.key,
      required this.tipodecita,
      required this.fecha,
      required this.hora,
      required this.doctor,
      required this.status});
  final String tipodecita;
  final String fecha;
  final String hora;
  final String doctor;
  final int status;
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
          ],
        ),
      ),
    );
  }

  List<Widget> get targetacontents {
    Color color = Colors.red;
    switch (status) {
      case 0:
        color = Colors.red;
        break;
      case 1:
        color = Colors.green;
        break;
      case 2:
        color = Colors.amber;
    }
    return [
      Text(
        tipodecita,
        textAlign: TextAlign.left,
        style: const TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.normal,
            color: AppColors.blueBackground),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            fecha,
            textAlign: TextAlign.left,
            style: const TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.normal,
                color: AppColors.blueBackground),
          ),
          Text(
            hora,
            textAlign: TextAlign.left,
            style: const TextStyle(
                fontFamily: 'Outfit',
                fontWeight: FontWeight.normal,
                color: AppColors.greenBackground),
          ),
        ],
      ),
      CircleAvatar(
        backgroundColor: color,
      ),
      Text(
        doctor,
        textAlign: TextAlign.left,
        style: const TextStyle(
            fontFamily: 'Outfit',
            //   fontSize: (width * 0.56) * 0.05,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: AppColors.blueBackground),
      ),
    ];
  }
}
