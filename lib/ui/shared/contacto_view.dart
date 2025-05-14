import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';
import 'package:medired/ui/shared/alert_helper.dart';
import 'package:medired/ui/shared/custom_flat_button.dart';
import 'package:medired/ui/shared/formbloque.dart';

import 'package:http/http.dart' as http;
import 'package:medired/ui/shared/formbloquevalidated.dart';
import 'package:medired/ui/shared/maps.dart';
import 'package:url_launcher/url_launcher.dart';

void sendEmail(String nombre, String texto) async {
  final to = Uri.encodeComponent('info@medired.do');
  final subject = Uri.encodeComponent('Contacto: $nombre');
  final text = Uri.encodeComponent(texto);

  final url = Uri.parse(
      'https://us-central1-medired-f442d.cloudfunctions.net/emailcontact?to=$to&subject=$subject&text=$text'); // Reemplaza con la URL correcta de tu función y los valores correctos de parámetros

  final response = await http.get(url);

  if (response.statusCode == 200) {
  } else {}
}

class ContacView extends StatefulWidget {
  const ContacView({
    super.key,
  });

  @override
  State<ContacView> createState() => _ContacViewState();
}

class _ContacViewState extends State<ContacView> {
  TextEditingController nombreController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController messageController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool device = context.screenType() == ScreenType.desktop;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            //color: Colors.amber,
            width: MediaQuery.of(context).size.width,
            height: device
                ? MediaQuery.of(context).size.height - 75
                : MediaQuery.of(context).size.height * 0.6,
            child: device
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: contents(context, device),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: contents(context, device),
                  ),
          ),
          Container(
            color: Colors.white,
            height: device ? MediaQuery.of(context).size.height * 0.1 : 0,
          ),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            //  height: MediaQuery.of(context).size.height ,
            child: MediaQuery.of(context).size.width > 768
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: device
                              ? MediaQuery.of(context).size.width * 0.8
                              : MediaQuery.of(context).size.width *
                                  0.8, // 40% del ancho de la pantalla
                          height: MediaQuery.of(context).size.height *
                              0.8, // 80% de la altura de la pantalla

                          child:
                              // mapas
                              /*
                          const Image(
                            image: AssetImage("assets/images/maps.png"),

                          child: const Image(
                            image: AssetImage('assets/images/maps.png'),

                            fit: BoxFit.cover,
                          ),*/
                              const MapSample(),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                          width: device
                              ? MediaQuery.of(context).size.width * 0.43
                              : MediaQuery.of(context).size.width *
                                  0.8, // 40% del ancho de la pantalla
                          height: device
                              ? MediaQuery.of(context).size.height * 0.8
                              : null, // 80% de la altura de la pantalla
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                device
                                    ? const SizedBox()
                                    : SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                      ),
                                formbloque(
                                    context,
                                    'Nombre',
                                    nombreController,
                                    formKey,
                                    MediaQuery.of(context).size.width,
                                    false),
                                formbloque(
                                    context,
                                    'Correo electrónico',
                                    emailController,
                                    formKey,
                                    MediaQuery.of(context).size.width,
                                    false),
                                formbloque(
                                    context,
                                    'Mensaje',
                                    messageController,
                                    formKey,
                                    MediaQuery.of(context).size.width,
                                    false),
                                CustomFlatButton(
                                    textColor: Colors.white,
                                    buttonColor: AppColors.blueBackground,
                                    text: 'Enviar',
                                    onPressed: () {
                                      final texto =
                                          '${emailController.text}: ${messageController.text}';
                                      sendEmail(nombreController.text, texto);
                                      emailController.text = '';
                                      messageController.text = '';
                                      nombreController.text = '';
                                    }),
                                device
                                    ? const SizedBox()
                                    : SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                      ),
                              ],
                            ),
                          )),
                      SizedBox(
                        // 80% de la altura de la pantalla
                        width: device
                            ? MediaQuery.of(context).size.width * 0.70
                            : MediaQuery.of(context).size.width *
                                0.95, // 40% del ancho de la pantalla
                        height: device
                            ? MediaQuery.of(context).size.height * 0.8
                            : MediaQuery.of(context).size.height,
                        // prueba
                        child: const MapSample(),
/*
                        child: Image(
                          width: device
                              ? MediaQuery.of(context).size.width * 0.43
                              : MediaQuery.of(context).size.width *
                                  0.95, // 40% del ancho de la pantalla
                          height: device
                              ? MediaQuery.of(context).size.height * 0.8
                              : null,
                          image: const AssetImage('assets/images/maps.png'),
                          fit: BoxFit.contain,
                        ),

*/
                      ),
                    ],
                  ),
          ),
          Container(
            color: Colors.white,
            child: Center(
              child: Image(
                width: device
                    ? MediaQuery.of(context).size.width * 0.25
                    : MediaQuery.of(context).size.width * 0.9,
                image: const AssetImage('assets/images/logo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.12,
          ),
        ],
      ),
    );
  }

  List<Widget> contents(BuildContext context, bool device) {
    showAlert(String message) {
      var alertHelper = AlertHelper();
      alertHelper.show((message), context);
    }

    return [
      const Spacer(),
      SizedBox(
        width: device
            ? MediaQuery.of(context).size.width * 0.43
            : MediaQuery.of(context).size.width * 0.95,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              device ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Text(
              'Contáctanos',
              style: TextStyle(
                color: AppColors.blueBackground,
                fontWeight: FontWeight.bold,
                fontSize: device
                    ? (MediaQuery.of(context).size.width * 0.08) / 2
                    : (MediaQuery.of(context).size.width * 0.12),
                letterSpacing: 0.03,
                fontFamily: 'Outfit',
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              'info@medired.do',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: AppColors.blueBackground,
                letterSpacing: 0.03,
                fontFamily: 'Outfit',
                fontSize: device
                    ? (MediaQuery.of(context).size.width * 0.03) / 2
                    : (MediaQuery.of(context).size.width * 0.09),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text(
              'Contáctanos llamando al +1 (809)-896-7711',
              textAlign: device ? TextAlign.left : TextAlign.center,
              style: TextStyle(
                color: AppColors.blueBackground,
                letterSpacing: 0.03,
                fontFamily: 'Outfit',
                fontSize: device
                    ? (MediaQuery.of(context).size.width * 0.03) / 2
                    : MediaQuery.of(context).size.width < 600
                        ? (MediaQuery.of(context).size.width * 0.084)
                        : (MediaQuery.of(context).size.width * 0.04),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            CustomFlatButton(
                verticalPadding: 15,
                horizontalPadding: 30,
                buttonColor: AppColors.greenBackground,
                text: 'WhatsApp',
                onPressed: () {
                  launchUrl(Uri.parse('https://wa.me/+18098967711'));
                },
                circularradius: (MediaQuery.of(context).size.width * 0.03),
                fontsize: device
                    ? (MediaQuery.of(context).size.width * 0.05) / 2.5
                    : (MediaQuery.of(context).size.width * 0.06)),
          ],
        ),
      ),
      const Spacer(),
      device
          ? SizedBox(
              width: device
                  ? MediaQuery.of(context).size.width * 0.43
                  : MediaQuery.of(context).size.width *
                      0.8, // 40% del ancho de la pantalla
              height: MediaQuery.of(context).size.height *
                  0.8, // 80% de la altura de la pantalla
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FormBloqueValidated(
                      text: 'Nombre',
                      controller: nombreController,
                      formKey: formKey,
                      sizewidth: MediaQuery.of(context).size.width,
                      write: false,
                      maxLength: 90, // Máximo de 90 caracteres
                    ),
                    FormBloqueValidated(
                      text: 'Correo electrónico',
                      controller: emailController,
                      formKey: formKey,
                      sizewidth: MediaQuery.of(context).size.width,
                      write: false,
                      emailValidation: true,
                      maxLength: 45, // Validar formato de correo
                    ),
                    FormBloqueValidated(
                      text: 'Mensaje',
                      controller: messageController,
                      formKey: formKey,
                      sizewidth: MediaQuery.of(context).size.width,
                      write: false,
                      maxLength: 300,
                    ),
                    CustomFlatButton(
                        textColor: Colors.white,
                        buttonColor: AppColors.blueBackground,
                        text: 'Enviar',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            final texto =
                                '${emailController.text}: ${messageController.text}';
                            sendEmail(nombreController.text, texto);
                            emailController.clear();
                            messageController.clear();
                            nombreController.clear();
                            showAlert(
                                'Mensaje enviado. Te contactaremos pronto');
                          } else {
                            formKey.currentState!.save();
                            setState(() {});
                          }
                        })
                  ],
                ),
              ))
          : const SizedBox(),
      /*device
          ? SizedBox(
              width: device
                  ? MediaQuery.of(context).size.width * 0.43
                  : MediaQuery.of(context).size.width * 0.95,
              // 40% del ancho de la pantalla
              height: MediaQuery.of(context).size.height *
                  0.8, // 80% de la altura de la pantalla
              child: const Image(
                image: AssetImage("assets/images/baculo.png"),
                fit: BoxFit.contain,
              ),
            )
          : SizedBox(),*/
      const Spacer(),
    ];
  }
}
