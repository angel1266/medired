import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';

class MyStack extends StatelessWidget {
  const MyStack({super.key});

  @override
  Widget build(BuildContext context) {
    // solo para iterrar widgets
    int indice = -1;
    List<Widget> widgetsList = [
      Text(
        'Beneficios',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: (MediaQuery.of(context).size.width * 0.45) * 0.05,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: AppColors.blueBackground),
      ),
      Text(
        'Plan básico',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: (MediaQuery.of(context).size.width * 0.45) * 0.05,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: AppColors.blueBackground),
      ),
      Text(
        'Plan Premium',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: (MediaQuery.of(context).size.width * 0.45) * 0.07,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: AppColors.greenBackground),
      ),
      Text(
        '',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: (MediaQuery.of(context).size.width * 0.45) * 0.04,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: const Color.fromRGBO(33, 57, 118, 1)),
      ),
      Text(
        '',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: (MediaQuery.of(context).size.width * 0.45) * 0.04,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: AppColors.blueBackground),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.21,
        child: Text(
          '',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: (MediaQuery.of(context).size.width * 0.45) * 0.03,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: Colors.white,
          ),
          softWrap: true,
        ),
      ),
      Text(
        'Atencion VIP',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: (MediaQuery.of(context).size.width * 0.45) * 0.04,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: const Color.fromRGBO(33, 57, 118, 1)),
      ),
      Center(
        child: Container(
          width: (MediaQuery.of(context).size.width * 0.5) * 0.06,
          height: (MediaQuery.of(context).size.width * 0.5) * 0.06,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Icon(
            Icons.close,
            color: Colors.white,
            size: (MediaQuery.of(context).size.width * 0.5) * 0.04,
          ),
        ),
      ),
      Expanded(
        child: Center(
          child: Container(
            width: (MediaQuery.of(context).size.width * 0.5) * 0.06,
            height: (MediaQuery.of(context).size.width * 0.5) * 0.06,
            decoration: BoxDecoration(
              color: Colors.lightGreen,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: (MediaQuery.of(context).size.width * 0.5) * 0.04,
            ),
          ),
        ),
      ),
      Text(
        'Servicio de Laboratorio',
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: (MediaQuery.of(context).size.width * 0.45) * 0.04,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: const Color.fromRGBO(33, 57, 118, 1)),
      ),
      Text(
        '5% Descuento',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: (MediaQuery.of(context).size.width * 0.45) * 0.04,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: AppColors.blueBackground),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.21,
        child: Text(
          '2 gratis al ano y 5% de descuento en la adicionales',
          textAlign: TextAlign.left,
          style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: (MediaQuery.of(context).size.width * 0.45) * 0.03,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              color: Colors.white),
          softWrap: true,
        ),
      ),
      Text(
        'Consultas Médicas',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: (MediaQuery.of(context).size.width * 0.45) * 0.04,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: const Color.fromRGBO(33, 57, 118, 1)),
      ),
      Center(
        child: Container(
          width: (MediaQuery.of(context).size.width * 0.5) * 0.06,
          height: (MediaQuery.of(context).size.width * 0.5) * 0.06,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Icon(
            Icons.close,
            color: Colors.white,
            size: (MediaQuery.of(context).size.width * 0.5) * 0.04,
          ),
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.21,
        child: Text(
          '4 gratis al ano con su seguro sin pago de diferencia',
          textAlign: TextAlign.left,
          style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: (MediaQuery.of(context).size.width * 0.45) * 0.03,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              color: Colors.white),
          softWrap: true,
        ),
      ),
      Text(
        'Estudios de imágenes',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: (MediaQuery.of(context).size.width * 0.45) * 0.04,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: const Color.fromRGBO(33, 57, 118, 1)),
      ),
      Text(
        '5% Descuento',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Outfit',
            fontSize: (MediaQuery.of(context).size.width * 0.45) * 0.04,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: AppColors.blueBackground),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: (MediaQuery.of(context).size.width * 0.3) * 0.1),
        child: Row(
          children: [
            Text(
              '10% Descuento',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: (MediaQuery.of(context).size.width * 0.45) * 0.04,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      const Text('Widget 2'),
    ];

    return Stack(
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(
              0,
              0,
              MediaQuery.of(context).size.width * 0.05,
              MediaQuery.of(context).size.height * 0.034,
            ),
            child: Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: (MediaQuery.of(context).size.height * 0.85),
                    width: (MediaQuery.of(context).size.width * 0.9) / 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        (MediaQuery.of(context).size.height * 0.02),
                      ),
                      color: AppColors.blueBackground,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                              height: (MediaQuery.of(context).size.height / 8),
                              color: AppColors.blueBackground,
                              child: const Spacer()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.04,
              ),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                SizedBox(
                  width: (MediaQuery.of(context).size.width * 0.9) / 3,
                  height: (MediaQuery.of(context).size.height * 0.75) + 20,
                  child: Positioned.fill(
                    child: Container(
                        color: const Color.fromRGBO(237, 241, 249, 1),
                        child: const Spacer()),
                  ),
                ),
              ]),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.04,
              horizontal: MediaQuery.of(context).size.width * 0.05),
          child: Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (int i = 0; i < 6; i++)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                          height: (MediaQuery.of(context).size.height / 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).size.height * 0.02),
                            ),
                            color: indice == -1
                                ? Colors.transparent
                                : const Color.fromRGBO(89, 118, 190, 0.15),
                          ),
                          child: Center(
                            child: widgetsList[++indice],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: (MediaQuery.of(context).size.height / 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).size.height * 0.02),
                            ),
                            color: const Color.fromRGBO(89, 118, 190, 0.15),
                          ),
                          child: Center(
                            child: widgetsList[++indice],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              (MediaQuery.of(context).size.height * 0.02),
                            ),
                            color: indice == 1
                                ? Colors.transparent
                                : const Color.fromRGBO(89, 118, 190, 0.15),
                          ),
                          height: (MediaQuery.of(context).size.height / 8),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    (MediaQuery.of(context).size.width * 0.3) *
                                        0.15),
                            child: Row(
                              children: [
                                widgetsList[++indice],
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
