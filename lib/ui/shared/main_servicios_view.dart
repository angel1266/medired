// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/organisms/beneficio_info.dart';
import 'package:sembast/sembast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainServiciosView extends StatefulWidget {
  const MainServiciosView({Key? key, this.id = ""}) : super(key: key);
  final String id;

  @override
  State<MainServiciosView> createState() => MainServiciosViewState();
}

class MainServiciosViewState extends State<MainServiciosView> {
  List<Map<String, dynamic>> servicios = [];
  List<Map<String, dynamic>> prestadores = [];
  List<Map<String, dynamic>> especialidades = [];
  final Map<dynamic, GlobalKey> _contentKeys = {};
  var index = 0;
  int? selectedIndex;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey _contentKey = GlobalKey();
  bool _isButtonVisible = true;
  void _scrollToContent(_key) {
    final contentContext = _key.currentContext;
    if (contentContext != null) {
      Scrollable.ensureVisible(contentContext,
          duration: Duration(seconds: 1), curve: Curves.easeInOut);
    }
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchServicios() async {
    try {
      List<dynamic> fetchedData = await getDocs(
          'servicios', 'id_centro', 'Nv044fsBNjhl6HeBGBqUh7awIRy1');
      setState(() {
        servicios = fetchedData.map((entry) {
          _contentKeys[entry[1]] = GlobalKey();

          return {
            'data': entry[0],
            'id': entry[1],
          };
        }).toList();
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<List<dynamic>> _fetchEspecialidades(id) async {
    List<dynamic> fetchedData = [];
    try {
      fetchedData = await getDocs('especialidades', 'id_servicio', '${id}');
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }

    return fetchedData;
  }

  Future<void> _fetchPrestadores() async {
    try {
      List<dynamic> fetchedData =
          await getDocs('member', 'memberInfo.memberType', 2);
      setState(() {
        prestadores = fetchedData.map((entry) {
          return {
            'data': entry[0],
            'id': entry[1],
          };
        }).toList();
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<List<dynamic>> getDocs(
      String table, String field, dynamic filter) async {
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

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(seconds: 1), curve: Curves.easeInOut);
  }

  @override
  void initState() {
    _fetchPrestadores();
    _fetchServicios().then((_) {
      if (widget.id != "") {
        _scrollToContent(_contentKeys[widget.id]);
      }
    });

    super.initState();
  }

  IconData getIcon(icon) {
    final match = RegExp(r'U\+([0-9a-fA-F]+)').firstMatch(icon);
    if (match != null) {
      final hexValue = match.group(1)!;
      final iconDataInt = int.parse(hexValue, radix: 16);
      return IconData(iconDataInt,
          fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter');
    }
    return IconData(
      0x0F06D,
      fontFamily: 'FontAwesomeSolid',
      fontPackage: 'font_awesome_flutter',
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    var width = MediaQuery.of(context).size.width;

    return Center(
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          child: Column(
            children: [
              _buildBlueBanner(),
              Padding(
                padding: EdgeInsets.all(width < 500 ? 5 : 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var i = 0; i < servicios.length; i++)
                      Column(
                        children: [
                          Center(
                            child: Container(
                              key: _contentKeys[servicios[i]["id"].toString()],
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  width < 630
                                      ? Container()
                                      : Flexible(
                                          child: SizedBox(
                                            width: 30,
                                          ),
                                        ),
                                  Flexible(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  color:
                                                      AppColors.greenBackground,
                                                  getIcon(servicios[i]["data"]
                                                      ["iconName"]),
                                                  size: 50,
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  servicios[i]["data"]
                                                      ["nombre"],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: isDesktop
                                                        ? (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.05) *
                                                            0.5
                                                        : (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.1) *
                                                            0.5,
                                                    letterSpacing: 0.03,
                                                    fontFamily: 'Outfit',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: FutureBuilder<List<dynamic>>(
                                              future: _fetchEspecialidades(
                                                  servicios[i]["id"]),
                                              builder: (context, snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return CircularProgressIndicator();
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else if (snapshot.hasData) {
                                                  if (snapshot.data!.isEmpty)
                                                    return Container();

                                                  // Obtener y ordenar alfabéticamente las especialidades
                                                  final especialidadesOrdenadas =
                                                      (snapshot.data![0][0]
                                                                  ["especialidades"]
                                                              as Map<String,
                                                                  dynamic>)
                                                          .entries
                                                          .toList()
                                                        ..sort((a, b) => a
                                                            .value[0]
                                                            .toString()
                                                            .compareTo(b
                                                                .value[0]
                                                                .toString()));

                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Detalles",
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .blueBackground,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: isDesktop
                                                              ? (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.03) *
                                                                  0.5
                                                              : (MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      0.1) *
                                                                  0.5,
                                                          letterSpacing: 0.03,
                                                          fontFamily: 'Outfit',
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children:
                                                            especialidadesOrdenadas
                                                                .map<Widget>(
                                                                    (entry) {
                                                          return Text(
                                                            '* ${entry.value[0].toString()}',
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Text('No hay datos');
                                                }
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  width < 630
                                      ? Container()
                                      : Flexible(
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Image.network(
                                                  servicios[i]["data"]
                                                      ["imageUrl"],
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.30,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.30,
                                                ),
                                                Text(
                                                  servicios[i]["data"]
                                                      ["descripcion"],
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            color: Colors.grey,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlueBanner() {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 0,
                maxHeight: constraints.maxHeight,
              ),
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                  opacity: 0.3,
                  image: AssetImage("assets/images/fondo_servicios.png"),
                  fit: BoxFit.cover,
                )),
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 30, right: 30, top: 40, bottom: 50),
                    child: MediaQuery.of(context).size.width < 806
                        ? Column(
                            children: item(),
                          )
                        : Row(children: item())),
              ),
            ),
          ],
        );
      },
    );
  }

  bool esPar(numero) {
    return numero % 2 == 0;
  }

  List<Widget> ServicioWidget(int i, int totalServicios) {
    List<Widget> list = [];

    num mitad = (totalServicios / 2).floor();

    if (i > 0) {
      index = index + 1;
    } else {
      index = i;
    }

    // Primer botón
    if (index >= servicios.length) return list;
    var dataId = index;

    list.add(Container(
      margin: EdgeInsets.only(bottom: 5),
      child: ElevatedButton.icon(
        icon: Icon(getIcon(servicios[index]["data"]["iconName"]),
            color: AppColors.greenBackground),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: () {
          _scrollToContent(_contentKeys[servicios[dataId]["id"].toString()]);
        },
        label: Container(
          width: MediaQuery.of(context).size.width > 1200
              ? (MediaQuery.of(context).size.width * 0.09)
              : MediaQuery.of(context).size.width < 806
                  ? (MediaQuery.of(context).size.width * 0.15)
                  : (MediaQuery.of(context).size.width * 0.1),
          child: Text(
            servicios[index]["data"]["nombre"],
            style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width < 1200
                    ? MediaQuery.of(context).size.width < 806
                        ? (MediaQuery.of(context).size.width * 0.022)
                        : (MediaQuery.of(context).size.width * 0.011)
                    : MediaQuery.of(context).size.width * 0.012),
          ),
        ),
      ),
    ));

    // Segundo botón (si existe)
    index++;
    if ((index >= servicios.length) || ((mitad < i + 1) && !esPar(mitad))) {
      return list;
    }

    var dataId2 = index;

    list.add(SizedBox(width: 5));
    list.add(ElevatedButton.icon(
      icon: Icon(getIcon(servicios[index]["data"]["iconName"]),
          color: AppColors.greenBackground),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: () {
        _scrollToContent(_contentKeys[servicios[dataId2]["id"].toString()]);
      },
      label: Container(
        width: MediaQuery.of(context).size.width > 1200
            ? (MediaQuery.of(context).size.width * 0.09)
            : MediaQuery.of(context).size.width < 806
                ? (MediaQuery.of(context).size.width * 0.15)
                : (MediaQuery.of(context).size.width * 0.1),
        child: Text(
          servicios[index]["data"]["nombre"],
          style: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.width < 1200
                  ? MediaQuery.of(context).size.width < 806
                      ? (MediaQuery.of(context).size.width * 0.022)
                      : (MediaQuery.of(context).size.width * 0.011)
                  : MediaQuery.of(context).size.width * 0.012),
        ),
      ),
    ));

    return list;
  }

  List<Widget> item() {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    List<Widget> list = [];
    list.add(Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ClipRRect(
          borderRadius:
              BorderRadius.circular(20), // Adjust the radius as needed
          child: Image.asset(
            "assets/images/servicio.jpg",
            height: MediaQuery.of(context).size.width < 806
                ? MediaQuery.of(context).size.width * 0.4
                : MediaQuery.of(context).size.width * 0.2,
          )),
    ));
    if (MediaQuery.of(context).size.width > 806) {
      list.add(Spacer());
    }

    list.add(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'El Ahorro que te da Salud',
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            style: TextStyle(
              color: AppColors.greenBackground,
              fontWeight: FontWeight.bold,
              fontSize: isDesktop
                  ? (MediaQuery.of(context).size.width * 0.05) * 0.5
                  : (MediaQuery.of(context).size.width * 0.1) * 0.5,
              letterSpacing: 0.03,
              fontFamily: 'Outfit',
            ),
          ),
          /*Text(
            'A un clic de Distancia',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: isDesktop
                  ? (MediaQuery.of(context).size.width * 0.05) * 0.45
                  : (MediaQuery.of(context).size.width * 0.1) * 0.45,
              letterSpacing: 0.03,
              fontFamily: 'Outfit',
            ),
          ),*/
        ],
      ),
    );
    if (MediaQuery.of(context).size.width > 806) {
      list.add(Spacer());
    }
    list.add(Column(
      children: [
        for (var i = 0; i < (servicios.length / 2); i++)
          Container(
            margin: EdgeInsets.all(2.5),
            child: Container(
              child: MediaQuery.of(context).size.width < 1200 &&
                      MediaQuery.of(context).size.width > 806
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: ServicioWidget(i, servicios.length),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: ServicioWidget(i, servicios.length),
                    ),
            ),
          )
      ],
    ));
    return list;
  }
}
