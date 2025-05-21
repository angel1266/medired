import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/organisms/beneficio_info.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrestadoresView extends StatefulWidget {
  const PrestadoresView({Key? key}) : super(key: key);

  @override
  State<PrestadoresView> createState() => PrestadoresViewState();
}

class PrestadoresViewState extends State<PrestadoresView> {
  List<ServicioModel> servicios = [];
  List<Map<String, dynamic>> prestadores = [];
  List<ServicioModel> listaService = [];
  int? selectedIndex;

  void _launchGoogleMaps(link) async {
    String googleMapsUrl =
        link;
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'No se pudo lanzar la URL $googleMapsUrl';
    }
  }

  Future<void> _fetchServicios(id) async {
    try {
      List<dynamic> fetchedData = await getDocs(
          'servicios', 'id_centro', 'Nv044fsBNjhl6HeBGBqUh7awIRy1');

      List<dynamic> fetchedDataAsig =
          await getDocs('espescialidades_asignadas', 'prestador_id', id);

      setState(() {
        if (fetchedDataAsig.isNotEmpty && fetchedData.isNotEmpty) {
          listaService = fetchedData.map((entry) {
            return ServicioModel(
              name: entry[0]["nombre"],
              id: entry[1],
            );
          }).toList();
          fetchedDataAsig.forEach((dat) {
            var nombre = listaService
                .firstWhere((element) => element.id == dat[0]["id_servicio"])
                .name;

            servicios
                .add(ServicioModel(name: nombre, id: dat[0]["id_servicio"]));
          });
        }
      });
      servicios.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
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

  Future<List<dynamic>> getDocs(String table, String field, dynamic filter,
      {tipo = "servicio"}) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(table)
        .where(field, isEqualTo: filter)
        .get();

    List<QueryDocumentSnapshot> documentos = querySnapshot.docs;
    if (tipo == "servicios") {
      documentos.sort((a, b) => a['nombre'].compareTo(b['nombre']));
    }

    List<dynamic> list = [];

    for (var doc in documentos) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      list.add([data, doc.id]);
    }
    return list;
  }

  @override
  void initState() {
    _fetchPrestadores();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildBlueBanner(),
            crearListPrestador(),
            selectedIndex != null
                ? buildPrestadorDetail(prestadores[selectedIndex!])
                : const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Seleccione un prestador para ver los detalles',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlueBanner() {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    return Container(
      constraints: const BoxConstraints(minHeight: 400),
      padding: const EdgeInsets.all(40),
      decoration: const BoxDecoration(
          image: DecorationImage(
        opacity: 0.3,
        image: AssetImage("assets/images/prestadoresimg.png"),
        fit: BoxFit.cover,
      )),
      width: MediaQuery.of(context).size.width,
      child: Align(
          alignment: Alignment.bottomCenter,
          child:
              Container() /*Column(
          children: [
            Text(
              'Obtén calidad médica y descuentos exclusivos.',
              textAlign: isDesktop ? TextAlign.start : TextAlign.center,
              style: TextStyle(
                color: AppColors.blueBackground,
                fontWeight: FontWeight.bold,
                fontSize: isDesktop
                    ? (MediaQuery.of(context).size.width * 0.05) * 0.5
                    : (MediaQuery.of(context).size.width * 0.1) * 0.5,
                letterSpacing: 0.03,
                fontFamily: 'Outfit',
              ),
            ),
            Text(
              'RD\$500 al mes',
              style: TextStyle(
                color: AppColors.greenBackground,
                fontWeight: FontWeight.bold,
                fontSize: isDesktop
                    ? (MediaQuery.of(context).size.width * 0.05) * 0.45
                    : (MediaQuery.of(context).size.width * 0.1) * 0.45,
                letterSpacing: 0.03,
                fontFamily: 'Outfit',
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                backgroundColor: AppColors.greenBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Acción para el botón de comprar
              },
              label: const Text(
                'Comprar',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),*/
          ),
    );
  }

 Widget crearListPrestador() {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        height: 70,
        width: MediaQuery.of(context).size.width * 0.7,
        child: Align(
          alignment: Alignment.center,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (var i = 0; i < prestadores.length; i++)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () {
                        servicios = [];
                        _fetchServicios(prestadores[i]["id"]);
                        setState(() {
                          selectedIndex = i;
                        });
                      },
                      child: Row(
                        children: [
                          prestadores[i]['data']['authInfo']['photoUrl'] != ''
                              ? Image.network(
                                  prestadores[i]['data']['authInfo']
                                      ['photoUrl'],
                                  height: MediaQuery.of(context).size.width >
                                          1000
                                      ? MediaQuery.of(context).size.width * 0.03
                                      : MediaQuery.of(context).size.width *
                                          0.05,
                                )
                              : Image.asset(
                                  'assets/images/logo.png',
                                  height: MediaQuery.of(context).size.width >
                                          1000
                                      ? MediaQuery.of(context).size.width * 0.03
                                      : MediaQuery.of(context).size.width *
                                          0.05,
                                ),
                          const SizedBox(width: 10),
                          Text(
                            prestadores[i]['data']['companyInfo']['name'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
      const Divider(color: Color.fromARGB(255, 206, 205, 205)),
      const SizedBox(height: 20),
    ],
  );
}


  List<Widget> ItemPrestador(Map<String, dynamic> prestador, type) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    bool isSmallDevice = MediaQuery.of(context).size.width <= 600;
    List<Widget> list = [];
    list.add(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          prestador['data']['authInfo']['photoUrl'] != ''
              ? Image.network(
                  prestador['data']['authInfo']['photoUrl'],
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                )
              : Image.asset(
                  'assets/images/logo.png',
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
          const SizedBox(height: 20),
          Text(
            'Tel: ${prestador['data']['companyInfo']['phoneNumber'][0]['phoneNumber']}',
            style: const TextStyle(
                fontSize: 16,
                color: Colors.blueAccent,
                decoration: TextDecoration.underline),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );

    list.add(
      const SizedBox(width: 30),
    );
    if (type == "web") {
      list.add(Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prestador['data']['companyInfo']['name'],
              style: const TextStyle(
                  color: AppColors.blueBackground,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            const SizedBox(height: 8),
            const Text(
              'Clínicas con el servicio de atención prioritaria, consultas médicas generales y especializadas en:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(servicios.length, (index) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          servicios[index].name,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isSmallDevice
                                ? IconButton(
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertBeneficio(
                                          prestadorConsult: false,
                                          id: prestador['id'],
                                          id_servicio: servicios[index].id,
                                        );
                                      },
                                    ),
                                    icon: const Icon(
                                      Icons.search,
                                      color: AppColors.greenBackground,
                                    ),
                                  )
                                : ElevatedButton.icon(
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertBeneficio(
                                          prestadorConsult: false,
                                          id: prestador['id'],
                                          id_servicio: servicios[index].id,
                                        );
                                      },
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.greenBackground,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.search,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Consultar',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: Color.fromARGB(255, 180, 177, 177)),
                  ],
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
  (prestador["data"]["companyInfo"]["address"] != null &&
   prestador["data"]["companyInfo"]["address"].isNotEmpty)
      ? prestador["data"]["companyInfo"]["address"][0]["direccion"] ?? 'Sin dirección'
      : 'Dirección no disponible',
  style: const TextStyle(color: Colors.black),
),

            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
               onPressed: () {
  if (prestador["data"]["companyInfo"]["address"] != null &&
      prestador["data"]["companyInfo"]["address"].isNotEmpty &&
      prestador["data"]["companyInfo"]["address"][0]["link"] != null) {
    _launchGoogleMaps(
        prestador["data"]["companyInfo"]["address"][0]["link"]);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Dirección no disponible"),
        backgroundColor: Colors.orange,
      ),
    );
  }
},

                icon: const Icon(Icons.location_on),
                label: const Text("Ver mapa"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueAccent,
                  side: const BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
      ));
    } else {
      list.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              prestador['data']['companyInfo']['name'],
              style: const TextStyle(
                  color: AppColors.blueBackground,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            const SizedBox(height: 8),
            const Text(
              'Clínicas con el servicio de atención prioritaria, consultas médicas generales y especializadas en:',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(servicios.length, (index) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          servicios[index].name,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isSmallDevice
                                ? IconButton(
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertBeneficio(
                                          prestadorConsult: false,
                                          id: prestador['id'],
                                          id_servicio: servicios[index].id,
                                        );
                                      },
                                    ),
                                    icon: const Icon(
                                      Icons.search,
                                      color: AppColors.greenBackground,
                                    ),
                                  )
                                : ElevatedButton.icon(
                                    onPressed: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertBeneficio(
                                          prestadorConsult: false,
                                          id: prestador['id'],
                                          id_servicio: servicios[index].id,
                                        );
                                      },
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          AppColors.greenBackground,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.search,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Consultar',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 13),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: Color.fromARGB(255, 180, 177, 177)),
                  ],
                );
              }),
            ),
            const SizedBox(height: 20),
            Text(
              prestador["data"]["companyInfo"]["address"][0]["direccion"],
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: () {
                  /// showMapDialog(prestador);
                  print( prestador["data"]["companyInfo"]["address"][0]
                          ["link"]);
                  _launchGoogleMaps(
                      prestador["data"]["companyInfo"]["address"][0]
                          ["link"]);
                },
                icon: const Icon(Icons.location_on),
                label: const Text("Ver mapa"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blueAccent,
                  side: const BorderSide(color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return list;
  }

  Widget buildPrestadorDetail(Map<String, dynamic> prestador) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: MediaQuery.of(context).size.width > 800
          ? MediaQuery.of(context).size.width * 0.7
          : MediaQuery.of(context).size.width * 0.95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: MediaQuery.of(context).size.width < 400
          ? Wrap(
              children: ItemPrestador(prestador, "movil"),
            )
          : Row(
              children: ItemPrestador(prestador,"web"),
            ),
    );
  }

  void showMapDialog(Map<String, dynamic> prestador) {
    final Completer<GoogleMapController> controller = Completer();
    CameraPosition position = CameraPosition(
      target: LatLng(
        prestador['data']['companyInfo']['address'][0]['latitude'],
        prestador['data']['companyInfo']['address'][0]['longitude'],
      ),
      zoom: 16.0,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 400,
            height: 300,
            child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: position,
                  markers: {
                    Marker(
                      markerId: MarkerId(prestador['id']),
                      position: LatLng(
                        prestador['data']['companyInfo']['address'][0]
                            ['latitude'],
                        prestador['data']['companyInfo']['address'][0]
                            ['longitude'],
                      ),
                      infoWindow: InfoWindow(
                        title: prestador['data']['companyInfo']['name'],
                        snippet: prestador['data']['companyInfo']['address'][0]
                            ['street'],
                      ),
                    ),
                  },
                  onMapCreated: (GoogleMapController mapController) {
                    controller.complete(mapController);
                  },
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: FloatingActionButton(
                    onPressed: () => Navigator.of(context).pop(),
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.close, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ServicioModel {
  final String name;
  final String id;
  ServicioModel({required this.name, required this.id});
}
