import 'package:flutter/material.dart';
import 'package:medired/core/router/router.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';
import 'package:medired/ui/shared/custom_flat_button.dart';

Widget registrofase2(BuildContext context, double sizewidth) {
  return SizedBox(
    width: sizewidth * 0.50,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: (sizewidth * 0.45) * 0.08),
          child: Text(
            'Tu cuenta está en camino',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: (sizewidth * 0.45) * 0.09,
                fontWeight: FontWeight.w100,
                color: const Color.fromRGBO(255, 255, 255, 1)),
          ),
        ),
        const SizedBox(height: 25),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: (sizewidth * 0.45) * 0.065),
          child: Text(
            'Hemos enviado un enlace a tu correo electrónico asi podremos verificar tu cuenta.',
            textAlign: TextAlign.left,
            style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: (sizewidth * 0.45) * 0.045,
                fontWeight: FontWeight.w300,
                color: const Color.fromRGBO(255, 255, 255, 1)),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: (sizewidth * 0.45) * 0.065),
          child: Row(
            children: [
              Text(
                'Puedes cerrar esta página.',
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: (sizewidth * 0.45) * 0.045,
                    fontWeight: FontWeight.w300,
                    color: const Color.fromRGBO(255, 255, 255, 1)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        CustomFlatButton(
          text: 'Volver',
          onPressed: () {
            router.push(RoutePath.login);
          },
          fontsize: 30,
          horizontalPadding: 35,
          circularradius: 30,
          textColor: AppColors.whiteBackground,
          buttonColor: AppColors.greenBackground,
        ),
        context.screenType() == ScreenType.desktop
            ? const SizedBox()
            : const SizedBox(
                height: 15,
              ),
      ],
    ),
  );
}
