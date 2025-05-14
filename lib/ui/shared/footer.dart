import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:medired/core/router/router.dart';
import 'package:medired/core/value_objects/footer_type.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/shared/footerwidget.dart';
import 'package:medired/ui/shared/icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/ui_helper.dart';

class TheFooter extends StatefulWidget {
  final Widget child;

  const TheFooter({super.key, required this.child});
  @override
  createState() => _TheFooterState(child: child);
}

class _TheFooterState extends State<TheFooter> {
  final Widget child;
  List<Map<String, dynamic>> servicios = [];

  _TheFooterState({required this.child});
  final ScrollController _scrollController = ScrollController();
  bool _isButtonVisible = false;

  Future getDocs(table, field, filter) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(table)
        .where(field, isEqualTo: filter)
        .get();

    List<QueryDocumentSnapshot> documentos = querySnapshot.docs;
    documentos.sort((a, b) => a['nombre'].compareTo(b['nombre']));

    List<dynamic> list = [];

    for (var doc in documentos) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      list.add([data, doc.id]);
    }

    return list;
  }

 

  Future<void> _fetchServicios() async {
    try {
      List<dynamic> fetchedData = await getDocs(
          'servicios', 'id_centro', 'Nv044fsBNjhl6HeBGBqUh7awIRy1');
      setState(() {
        // Convierte los datos obtenidos en un mapa con 'data' y 'id'
        servicios = fetchedData.map((entry) {
          return {
            'data': entry[0],
            'id': entry[1],
          };
        }).toList();

        // Ordena alfabéticamente los servicios por el campo 'nombre'
        servicios.sort((a, b) {
          return (a['data']['nombre'] as String)
              .compareTo(b['data']['nombre'] as String);
        });
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  @override
  void initState() {
    _scrollController.addListener(() {
      if (_scrollController.offset >= 200) {
        setState(() {
          _isButtonVisible = true;
        });
      } else {
        setState(() {
          _isButtonVisible = false;
        });
      }
    });
    _fetchServicios();
    super.initState();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          controller: _scrollController,
          children: [
            child,
            Footer(
              child: MiFooter(
                services: servicios,
                navegacion: navegacionMap,
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Visibility(
            visible: _isButtonVisible,
            child: FloatingActionButton(
              onPressed: _scrollToTop,
              child: Icon(Icons.arrow_upward),
            ),
          ),
        ),
      ],
    );
  }
}

class MiFooter extends StatelessWidget {
  final List<dynamic> services;
  final Map<String, String> navegacion;

  const MiFooter({super.key, required this.services, required this.navegacion});

 Future<void> _launchUrl(url) async {
    final Uri _url = Uri.parse(url);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool device = context.screenType() == ScreenType.desktop;
    return Container(
      color: Colors.white,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.05,
            ),
            device
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: sections(context, device))
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: sections(context, device),
                  ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var iconData in SocialMediaIcons.all)
                  SocialMediaIconButton(
                    iconSize:
                        Theme.of(context).textTheme.headlineSmall!.fontSize!,
                    icon: iconData[0],
                    onPressed: () {
                      _launchUrl(iconData[1]);
                    },
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Todos los derechos reservados  @2023 Medired',
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.grey),
              ),
            ),
          ]),
    );
  }

  List<Widget> sections(BuildContext context, bool device) {
    double bodytexts = device
        ? MediaQuery.sizeOf(context).width * 0.38
        : MediaQuery.sizeOf(context).width;
    double texts = device
        ? MediaQuery.sizeOf(context).width * 0.29
        : MediaQuery.sizeOf(context).width;
    return [
      Container(
        constraints: BoxConstraints(maxWidth: texts),
        child: Center(
          child: Column(
              crossAxisAlignment:
                  device ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Servicios',
                  textAlign: device ? TextAlign.left : TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(color: AppColors.greenBackground),
                ),
                ...services.asMap().entries.map((entry) => MySectionWidget(
                      id: services[entry.key]['id'],
                      index: entry.key,
                      child: Text(
                        services[entry.key]['data']['nombre'],
                        textAlign: device ? TextAlign.left : TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Colors.black),
                      ),
                    )),
              ]),
        ),
      ),
      Container(
        constraints: BoxConstraints(maxWidth: texts),
        child: Center(
          child: Column(
              crossAxisAlignment:
                  device ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: device ? 0 : 10,
                ),
                Text(
                  'Contenido',
                  textAlign: device ? TextAlign.left : TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(color: AppColors.greenBackground),
                ),
                ...navegacion.entries.map(
                  (title) => MySection1Widget(
                    page: title.value,
                    child: Text(
                      title.key,
                      textAlign: device ? TextAlign.left : TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: Colors.black),
                    ),
                  ),
                ),
              ]),
        ),
      ),
      SizedBox(
        height: device ? 0 : 10,
      ),
      Container(
        constraints: BoxConstraints(maxWidth: bodytexts),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    device ? MainAxisAlignment.start : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: const AssetImage('assets/images/logo.png'),
                    height: device ? 82 : 50,
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              const Column(
                children: [
                  Text(
                    'Preguntas frecuentes',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ExpansionTile(
                    title: Text('1) ¿Qué es MediRed?'),
                    children: [
                      Text(
                          '''Somos un club de membresías que ofrece a sus adquirientes grandes beneficios fungiendo como un plan preferencial.\n''')
                    ],
                  ),
                  ExpansionTile(
                    title: Text('2) ¿Cómo puedo adquirir un plan?'),
                    children: [
                      Text(
                          '''Ve a la pestaña de registro y completa el formulario, luego completa el pago y se luego de las validaciones correspondientes podrás ver el código de membresía asignado a tu cuenta.\n''')
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
            ]),
      ),
    ];
  }
}
