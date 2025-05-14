import 'package:flutter/material.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/shared/custom_flat_button.dart';

Future<dynamic> dialogCitas(BuildContext context, String fecha, String hora,
    bool device, List<String> text1, List<String> text2, List<String> text3) {
  List<String> titles = ['Nombre del paciente', 'Contacto', 'Sexo', 'Edad'];

  List<String> titles2 = [
    'Código de Membresía',
    'Síntomas presentes',
    'Síntomas presentes desde'
  ];
  List<String> titles3 = [
    'Diagnóstico médico',
    'Descripción del diagnóstico médico',
    'Prescripción médica'
  ];

  final formKey = GlobalKey<FormState>();
  List<TextEditingController> textControllers1 = List.generate(
    titles.length, // La longitud de tu lista de text3
    (index) => TextEditingController(text: text1[index]),
  );
  List<TextEditingController> textControllers2 = List.generate(
    titles2.length, // La longitud de tu lista de text3
    (index) => TextEditingController(text: text2[index]),
  );
  List<TextEditingController> textControllers3 = List.generate(
    titles3.length, // La longitud de tu lista de text3
    (index) => TextEditingController(text: text3[index]),
  );

  return showModalBottomSheet(
    useSafeArea: true,
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.vertical(
                top:
                    Radius.circular(MediaQuery.of(context).size.width * 0.015)),
          ),
          child:
              /*  AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: Colors.transparent,
          content: 
          */
              SingleChildScrollView(
            child: Container(
              constraints:
                  BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.015),
                image: const DecorationImage(
                  image: AssetImage('assets/images/fondo.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: title(device, context, fecha, hora),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    Container(
                      color: Colors.white,
                      child: device
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: firstcontents(
                                          device,
                                          context,
                                          titles,
                                          text1,
                                          textControllers1,
                                          MediaQuery.of(context).size.width *
                                              0.39),
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.40,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: firstcontents(
                                          device,
                                          context,
                                          titles2,
                                          text2,
                                          textControllers2,
                                          MediaQuery.of(context).size.width *
                                              0.39),
                                    ),
                                  )
                                ])
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width *
                                          0.0425),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: firstcontents(
                                          device,
                                          context,
                                          titles,
                                          text1,
                                          textControllers1,
                                          MediaQuery.of(context).size.width *
                                              0.83),
                                    ),
                                    Column(
                                      children: firstcontents(
                                          device,
                                          context,
                                          titles2,
                                          text2,
                                          textControllers2,
                                          MediaQuery.of(context).size.width *
                                              0.83),
                                    )
                                  ]),
                            ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    ...text3.asMap().entries.map((entry) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.005,
                            horizontal:
                                MediaQuery.of(context).size.width * 0.0425),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: contents(
                              device,
                              context,
                              titles3[entry.key],
                              entry.value,
                              textControllers3[entry.key],
                              MediaQuery.of(context).size.width * 0.83,
                              TextAlign.left),
                        ),
                      );
                    }),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: device
                                ? MediaQuery.of(context).size.width * 0.0425
                                : 0),
                        child: device
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: butoms(
                                    context,
                                    device,
                                    textControllers1,
                                    textControllers2,
                                    textControllers3),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: butoms(
                                    context,
                                    device,
                                    textControllers1,
                                    textControllers2,
                                    textControllers3),
                              )
                        /* Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: butoms(
                                    context,
                                    device,
                                    textControllers1,
                                    textControllers2,
                                    textControllers3),
                              ),
                            ),
                            */
                        ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  ],
                ),
              ),
            ),
          ));
    },
  );
}

List<Widget> butoms(
    BuildContext context,
    bool device,
    List<TextEditingController> textControllers1,
    List<TextEditingController> textControllers2,
    List<TextEditingController> textControllers3) {

  return [
    CustomFlatButton(
      text: 'Cancelar',
      fontsize: device ? 20 : 15,
      onPressed: () {
        Navigator.pop(context);
      },
      textColor: Colors.white,
      buttonColor: Colors.red,
    ),
    device
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.0055,
          )
        : SizedBox(height: MediaQuery.of(context).size.height * 0.025),
    CustomFlatButton(
      text: 'Completar',
      fontsize: device ? 20 : 15,
      onPressed: () async {},
      textColor: Colors.white,
      buttonColor: AppColors.greenBackground,
    ),
  ];
}

List<Widget> title(
    bool device, BuildContext context, String fecha, String hora) {
  return [
    Text(
      'Notas Médicas',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: device
            ? (MediaQuery.of(context).size.width * 0.08) / 2
            : (MediaQuery.of(context).size.width * 0.12),
        letterSpacing: 0.03,
        fontFamily: 'Outfit',
      ),
    ),
    Column(
      children: [
        Text(
          fecha,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: device
                ? (MediaQuery.of(context).size.width * 0.035) / 2
                : (MediaQuery.of(context).size.width * 0.05),
            letterSpacing: 0.03,
            fontFamily: 'Outfit',
          ),
        ),
        Text(
          hora,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: device
                ? (MediaQuery.of(context).size.width * 0.035) / 2
                : (MediaQuery.of(context).size.width * 0.05),
            letterSpacing: 0.03,
            fontFamily: 'Outfit',
          ),
        ),
      ],
    )
  ];
}

List<Widget> contents(
    bool device,
    BuildContext context,
    String title,
    String text,
    TextEditingController controller,
    double size,
    TextAlign aling) {
  return [
    Text(
      title,
      textAlign: aling,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: device
            ? (MediaQuery.of(context).size.width * 0.035) / 2
            : (MediaQuery.of(context).size.width * 0.035),
        letterSpacing: 0.03,
        fontFamily: 'Outfit',
      ),
    ),
    ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width > 768
            ? size
            : size * 0.8, // Establece el ancho máximo deseado
        minWidth: 80,
      ),
      child: IntrinsicWidth(
          //  width: double.minPositive,

          child: TextField(
        controller: controller,
        textAlign: aling,
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.w600,
          fontSize: device
              ? (MediaQuery.of(context).size.width * 0.035) / 2
              : (MediaQuery.of(context).size.width * 0.035),
          letterSpacing: 0.03,
          fontFamily: 'Outfit',
        ),
        decoration: InputDecoration(
          border: InputBorder.none, // Elimina el borde
          filled: true,
          fillColor: const Color.fromARGB(
              30, 158, 158, 158), // Establece el fondo transparente
          //hintText: 'Placeholder', // Puedes agregar un marcador de posición si lo necesitas
          hintStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w600,
            fontSize: device
                ? (MediaQuery.of(context).size.width * 0.035) / 2
                : (MediaQuery.of(context).size.width * 0.035),
            letterSpacing: 0.03,
            fontFamily: 'Outfit',
          ),
        ),
      )),
    ),
    /*  Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w600,
        fontSize: device
            ? (MediaQuery.of(context).size.width * 0.035) / 2
            : (MediaQuery.of(context).size.width * 0.035),
        letterSpacing: 0.03,
        fontFamily: 'Outfit',
      ),
    ),*/
  ];
}

List<Widget> firstcontents(
    bool device,
    BuildContext context,
    List<String> title,
    List<String> text,
    List<TextEditingController> textControllers,
    double size) {
  List<Widget> widgets = [];

  for (int i = 0; i < title.length; i++) {
    widgets.add(
      MediaQuery.of(context).size.width > 474
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: contents(device, context, title[i], text[i],
                  textControllers[i], size / 2, TextAlign.right),
            )
          : SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: contents(device, context, title[i], text[i],
                    textControllers[i], size, TextAlign.start),
              ),
            ),
    );
  }

  return widgets;
}
