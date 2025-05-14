import 'package:flutter/material.dart';
import 'package:medired/ui/shared/carnet_menbresia.dart';

Future<dynamic> dialogtarjeta(BuildContext context, String number, bool device,
    String idnumber, String name) {
  return showDialog(
    useSafeArea: false,
    context: context,
    builder: (BuildContext context) {
      return FractionallySizedBox(
        // widthFactor: 1, // Puedes ajustar este valor según tus necesidades
        heightFactor: MediaQuery.of(context).size.width > 769
            ? 0.7
            : 0.65, // Puedes ajustar este valor según tus necesidades
        child: AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Colors.transparent,
          content: InsuranceCard(
            membershipNumber: number,
            membershipType: 'Membresía Premium',
            name: name,
            idnumber: idnumber,
            width: MediaQuery.of(context).size.width < 769
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.width * 0.45,
            textsize: device
                ? (MediaQuery.of(context).size.width * 0.05) * 0.46
                : (MediaQuery.of(context).size.width * 0.1) * 0.45,
            titlesize: 17,
          ),
        ),
      );
    },
  );
}


          //   title: Text('Confirmación'),
     /*     content: InsuranceCard(
              membershipNumber: number,
              membershipType: "",
              width: MediaQuery.of(context).size.width < 769
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.width * 0.4,
              textsize: device
                  ? (MediaQuery.of(context).size.width * 0.05) * 0.46
                  : (MediaQuery.of(context).size.width * 0.1) * 0.45,
              titlesize: 17));
*/

      /*    Stack(
            alignment: Alignment.center,
            children: [
              Stack(
                children: [
                  Image.asset(
                    "assets/images/doc2.png",
                    height: MediaQuery.of(context).size.width < 769
                        ? MediaQuery.of(context).size.width * 0.5
                        : MediaQuery.of(context).size.width * 0.2,
                    width: MediaQuery.of(context).size.width < 769
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.width * 0.4,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: AppColors.blueBackground
                        .withOpacity(0.8), // Color por encima de la imagen
                    height: MediaQuery.of(context).size.width < 769
                        ? MediaQuery.of(context).size.width * 0.5
                        : MediaQuery.of(context).size.width * 0.2,
                    width: MediaQuery.of(context).size.width < 769
                        ? MediaQuery.of(context).size.width
                        : MediaQuery.of(context).size.width * 0.4,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(
                      image: AssetImage("assets/images/logob.png"),
                    ),
                    Text(
                      number,
                      style: const TextStyle(
                        color: Colors.white,
                        letterSpacing: 5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ));
    

    },
  );
}
*/
