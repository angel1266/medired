import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';
import 'package:medired/ui/shared/alert_helper.dart';
import 'package:medired/ui/shared/custom_flat_button.dart';
import 'package:medired/ui/shared/formularios.dart';
import 'package:medired/ui/shared/listas_textos.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ProvedoresView extends StatefulWidget {
  const ProvedoresView({
    super.key,
  });

  @override
  State<ProvedoresView> createState() => _ProvedoresViewState();
}

class _ProvedoresViewState extends State<ProvedoresView> {
  TextEditingController nombreController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController messageController = TextEditingController();

  TextEditingController tipoController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  List<String> enumeratedList = [
    'Asociación con una plataforma líder en el sector.',
    'Networking especializado con empresas buscando prestadores de servicios de salud confiables.',
    'Oportunidades de negocio con clientes potenciales.',
    'Contactos de alto nivel para hacer negocios.',
    'Exposición en medios nacionales e internacionales.'
  ];

  @override
  Widget build(BuildContext context) {
    bool device = context.screenType() == ScreenType.desktop;
    void sendEmail(String nombre, String texto) async {
      final to = Uri.encodeComponent('med-cc@medired.do');
      final subject = Uri.encodeComponent('Contacto: $nombre');
      final text = Uri.encodeComponent(texto);

      final url = Uri.parse(
          'https://us-central1-medired-f442d.cloudfunctions.net/emailprestador?to=$to&subject=$subject&text=$text'); // Reemplaza con la URL correcta de tu función y los valores correctos de parámetros

      final response = await http.get(url);

      if (response.statusCode == 200) {
      } else {}
    }

    showAlert(String message) {
      var alertHelper = AlertHelper();
      alertHelper.show((message), context);
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            //color: Colors.amber,
            width: MediaQuery.of(context).size.width,
            height: device ? MediaQuery.of(context).size.height * 0.74 : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Spacer(),
                SizedBox(
                  width: device
                      ? MediaQuery.of(context).size.width * 0.45
                      : MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: device
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: device
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1),
                          Text(
                            'Conviértete en prestador',
                            style: TextStyle(
                              color: AppColors.blueBackground,
                              fontWeight: FontWeight.bold,
                              fontSize: device
                                  ? (MediaQuery.of(context).size.width * 0.08) *
                                      0.4
                                  : (MediaQuery.of(context).size.width * 0.08),
                              letterSpacing: 0.03,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          Text(
                            'de servicios de salud',
                            style: TextStyle(
                              color: AppColors.blueBackground,
                              fontWeight: FontWeight.bold,
                              fontSize: device
                                  ? (MediaQuery.of(context).size.width * 0.08) *
                                      0.4
                                  : (MediaQuery.of(context).size.width * 0.08),
                              letterSpacing: 0.03,
                              fontFamily: 'Outfit',
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          Text(
                            'Asocia tu marca con nosotros',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColors.blueBackground,
                              letterSpacing: 0.03,
                              fontFamily: 'Outfit',
                              fontSize: device
                                  ? (MediaQuery.of(context).size.width * 0.03) *
                                      0.5
                                  : (MediaQuery.of(context).size.width * 0.07),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.02),
                          CustomFlatButton(
                              verticalPadding: 15,
                              horizontalPadding: 20,
                              buttonColor: AppColors.greenBackground,
                              text: 'Enviar mensaje directo al Whatsapp',
                              onPressed: () {
                                launchUrl(
                                    Uri.parse('https://wa.me/+18098967711'));
                              },
                              circularradius:
                                  (MediaQuery.of(context).size.width * 0.03),
                              fontsize: device
                                  ? (MediaQuery.of(context).size.width * 0.05) /
                                      3
                                  : (MediaQuery.of(context).size.width * 0.11) /
                                      3),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                device
                    ? Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.55, // 40% del ancho de la pantalla
                          height: MediaQuery.of(context).size.height *
                              0.75, // 80% de la altura de la pantalla
                          child: const Image(
                            image: AssetImage('assets/images/doc5.png'),
                            fit: BoxFit.cover,
                          ),
                        ))
                    : const SizedBox(),
                const Spacer(),
              ],
            ),
          ),
          /*Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.05,
          ),*/
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            //  height: MediaQuery.of(context).size.height ,
            child: MediaQuery.of(context).size.width > 768
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: device
                                ? MediaQuery.of(context).size.width * 0.43
                                : MediaQuery.of(context).size.width * 0.8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Formulario de contacto',
                                        style: TextStyle(
                                          color: AppColors.blueBackground,
                                          fontWeight: FontWeight.bold,
                                          fontSize: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.07) /
                                              2,
                                          letterSpacing: 0.03,
                                          fontFamily: 'Outfit',
                                        ),
                                      ),

                                      /// LINEA GRIS
                                    ],
                                  ),
                                ),
                                Container(
                                  width: device
                                      ? MediaQuery.of(context).size.width * 0.43
                                      : MediaQuery.of(context).size.width * 0.8,
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(89, 118, 190, 0.15),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    child: Column(
                                      //   crossAxisAlignment:  CrossAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            formularios(
                                              context,
                                              [
                                                'Nombre de la empresa',
                                                'Tipo de empresa',
                                                'Correo electrónico',
                                                'Teléfono',
                                                'Acerca de tus servicios'
                                              ],
                                              [
                                                nombreController,
                                                tipoController,
                                                emailController,
                                                phoneController,
                                                messageController
                                              ],
                                              [
                                                'Asociación Ejemplo',
                                                'Ejemplo: Centro de radiografía, Hospital',
                                                'a.ejemploasoc@email.com',
                                                '8090007849',
                                                'Tu mensaje'
                                              ],
                                              0,
                                              formKey,
                                              MediaQuery.of(context).size.width,
                                              false,
                                              bagColor: const Color.fromARGB(
                                                  255, 191, 200, 208),
                                              headerColor: Colors.black,
                                            ),
                                            CustomFlatButton(
                                                textColor: Colors.white,
                                                buttonColor:
                                                    AppColors.greenBackground,
                                                text: 'Enviar',
                                                onPressed: () {
                                                  if (formKey.currentState!
                                                      .validate()) {
                                                    // Si la validación es exitosa, procede con el envío
                                                    String text =
                                                        'Nombre: ${nombreController.text}\nEmail: ${emailController.text}\nMensaje: ${messageController.text}\nTipo: ${tipoController.text}\nNúmero: ${phoneController.text}';
                                                    sendEmail(
                                                        nombreController.text,
                                                        text);
                                                    emailController.text = '';
                                                    messageController.text = '';
                                                    nombreController.text = '';
                                                    tipoController.text = '';
                                                    phoneController.text = '';
                                                    showAlert(
                                                        'Gracias por contactarnos, nos comunicaremos lo antes posible');
                                                  } else {
                                                    // Si la validación falla, muestra un mensaje de error
                                                    showAlert(
                                                        'Por favor, corrija los errores en el formulario antes de enviar.');
                                                  }
                                                })
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          width: device
                              ? MediaQuery.of(context).size.width * 0.43
                              : MediaQuery.of(context).size.width * 0.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Beneficios de ser prestador de servicios de salud',
                                      style: TextStyle(
                                        color: AppColors.blueBackground,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            (MediaQuery.of(context).size.width *
                                                    0.06) /
                                                2,
                                        letterSpacing: 0.03,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),

                                    /// LINEA GRIS
                                  ],
                                ),
                              ),
                              SizedBox(
                                  width: device
                                      ? MediaQuery.of(context).size.width * 0.33
                                      : MediaQuery.of(context).size.width * 0.7,
                                  child: Column(
                                    children: [
                                      ...enumeratedList
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                        int index = entry.key;
                                        String text = entry.value;
                                        return EnumeratedListItem(
                                          text: text,
                                          textsize: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03) *
                                              0.5,
                                          botton: (MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03) *
                                              0.5,
                                          textColor: AppColors
                                              .blueBackground, // Color de texto
                                          number: index + 1, // Número a listar
                                        );
                                      }),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(
                          width: device
                              ? MediaQuery.of(context).size.width * 0.43
                              : MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Formulario de contacto',
                                      style: TextStyle(
                                        color: AppColors.blueBackground,
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            (MediaQuery.of(context).size.width *
                                                    0.11) /
                                                2,
                                        letterSpacing: 0.03,
                                        fontFamily: 'Outfit',
                                      ),
                                    ),

                                    /// LINEA GRIS
                                  ],
                                ),
                              ),
                              Container(
                                width: device
                                    ? MediaQuery.of(context).size.width * 0.43
                                    : MediaQuery.of(context).size.width,
                                decoration: const BoxDecoration(
                                    color: Color.fromRGBO(89, 118, 190, 0.15),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 20),
                                  child: Column(
                                    //   crossAxisAlignment:  CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          formularios(
                                            context,
                                            [
                                              'Nombre de la empresa',
                                              'Tipo de empresa',
                                              'Correo electrónico',
                                              'Teléfono',
                                              'Acerca de tus servicios'
                                            ],
                                            [
                                              nombreController,
                                              tipoController,
                                              emailController,
                                              phoneController,
                                              messageController
                                            ],
                                            [
                                              'Asociación Ejemplo',
                                              'Ejemplo: Centro de radiografía, Hospital',
                                              'a.ejemploasoc@email.com',
                                              '+1 (809) 000-000',
                                              'Tu mensaje'
                                            ],
                                            0,
                                            formKey,
                                            MediaQuery.of(context).size.width,
                                            true,
                                            bagColor: const Color.fromARGB(
                                                255, 191, 200, 208),
                                            headerColor: Colors.black,
                                          ),
                                          CustomFlatButton(
                                              textColor: Colors.white,
                                              buttonColor:
                                                  AppColors.greenBackground,
                                              text: 'Enviar',
                                              onPressed: () {
                                                String text =
                                                    'Nombre: ${nombreController.text}\nEmail: ${emailController.text}\nMensaje: ${messageController.text}\nTipo: ${tipoController.text}\nNúmero: ${phoneController.text}';
                                                sendEmail(nombreController.text,
                                                    text);
                                                emailController.text = '';
                                                messageController.text = '';
                                                nombreController.text = '';
                                                tipoController.text = '';
                                                phoneController.text = '';
                                                showAlert(
                                                    'Gracias por contactarnos, nos comunicaremos lo antes posible');
                                              })
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                      SizedBox(
                        width: device
                            ? MediaQuery.of(context).size.width * 0.43
                            : MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Beneficios de ser prestador de servicios de salud',
                                    style: TextStyle(
                                      color: AppColors.blueBackground,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          (MediaQuery.of(context).size.width *
                                                  0.11) /
                                              2,
                                      letterSpacing: 0.03,
                                      fontFamily: 'Outfit',
                                    ),
                                  ),

                                  /// LINEA GRIS
                                ],
                              ),
                            ),
                            SizedBox(
                                width: device
                                    ? MediaQuery.of(context).size.width * 0.33
                                    : MediaQuery.of(context).size.width * 0.8,
                                child: Column(
                                  children: [
                                    ...enumeratedList
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      int index = entry.key;
                                      String text = entry.value;
                                      return EnumeratedListItem(
                                        text: text,
                                        textsize:
                                            (MediaQuery.of(context).size.width *
                                                    0.08) *
                                                0.5,
                                        botton:
                                            (MediaQuery.of(context).size.width *
                                                    0.03) *
                                                0.5,
                                        textColor: AppColors
                                            .blueBackground, // Color de texto
                                        number: index + 1, // Número a listar
                                      );
                                    }),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.05,
          ),
        ],
      ),
    );
  }
}
