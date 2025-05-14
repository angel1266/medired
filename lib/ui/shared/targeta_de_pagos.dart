import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';

class Targetapagos extends StatelessWidget {
  const Targetapagos({
    super.key,
    required this.numeropago,
    required this.fechapago,
    required this.nombrepago,
    required this.locationpago,
    required this.tipopago,
    required this.cantidadpago,
  });
  final String numeropago;
  final String fechapago;
  final String nombrepago;
  final String locationpago;
  final String tipopago;
  final String cantidadpago;

  @override
  Widget build(BuildContext context) {
    bool device = context.screenType() == ScreenType.desktop;
    return GestureDetector(
      child: Container(
        width: double.infinity,
        height: 210,
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
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                device
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: titles,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: titles,
                      ),
                Text(
                  nombrepago.toUpperCase(),
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                      fontFamily: 'Outfit',
                      //   fontSize: (width * 0.56) * 0.05,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      color: Colors.black),
                ),
                Text(
                  locationpago,
                  textAlign: device ? TextAlign.justify : TextAlign.center,
                  style: const TextStyle(
                      fontFamily: 'Outfit',
                      //   fontSize: (width * 0.56) * 0.05,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blueBackground),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tipopago,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                    Text(
                      cantidadpago,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }

  List<Widget> get titles {
    return [
      Text(
        numeropago,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.normal,
            color: Colors.grey),
      ),
      Text(
        fechapago,
        textAlign: TextAlign.center,
        style: const TextStyle(
            fontFamily: 'Outfit',
            fontWeight: FontWeight.normal,
            color: Colors.black),
      ),
    ];
  }
}
