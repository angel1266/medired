import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medired/features/authentication/data/models/pruebas_model.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/asset.dart';

class PrestadorDetalle extends StatefulWidget {
  const PrestadorDetalle({super.key, required this.id_prestador});
  final String id_prestador;
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  _PrestadorDetalletate createState() => _PrestadorDetalletate();
}

class _PrestadorDetalletate extends State<PrestadorDetalle> {
  bool showProviders = false;
  String? selectedProvider;
  List<TestModel> providerName = [];
  List<dynamic> prestadores = [];
  List<Widget> listServiceRow = [];
  bool vacio = false;
  Map<String, dynamic> prestadoresLis = {};

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    // TODO: implement initState
    getBdDoc('member', widget.id_prestador);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: _buildProvidersContent(),
        ),
      ),
    );
  }

  Future getDocs(table, field, filter) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(table)
        .where(field, isEqualTo: filter)
        .get();
    List<dynamic> list = [];
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      list.add([data, doc.id]);
    }
    return list;
  }

  getBdDoc(table, id) async {
    var docRef = FirebaseFirestore.instance.collection(table).doc(id);

    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      prestadoresLis = docSnapshot.data() as Map<String, dynamic>;
      // ... and so on
    } else {
      print('Document does not exist');
    }
    vacio = true;
    setState(() {});
  }

  Widget _buildProvidersContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(prestadoresLis.isNotEmpty
                ? prestadoresLis['companyInfo']['name']
                : ''),
          ),
          vacio && prestadoresLis.isEmpty
              ? const Center(
                  child: Text(
                      'No hay beneficios registrados pera el prestador seleccionado'))
              : vacio && prestadoresLis.length > 1
                  ? Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                const Text('Telefono: '),
                                Text(prestadoresLis['companyInfo']
                                    ['phoneNumber'][0]['phoneNumber']),
                              ],
                            ),
                            const Divider(
                              color: Colors.grey,
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                const Text('Correo: '),
                                Text(prestadoresLis['authInfo']['email']),
                              ],
                            ),
                            const Divider(
                              color: Colors.grey,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 300,
                          child: GoogleMap(
                            mapType: MapType.normal,
                            markers: {
                              Marker(
                                markerId: const MarkerId('marker_1'),
                                position: LatLng(prestadoresLis['companyInfo']['address'][1], prestadoresLis['companyInfo']['address'][2]),
                                infoWindow: InfoWindow(
                                  title:
                                      prestadoresLis['companyInfo']['address'][0],
                                  snippet:
                                      prestadoresLis['companyInfo']['address'][0],
                                ),
                              ),
                            },
                            initialCameraPosition: const CameraPosition(
                              target: LatLng(18.4753311,
                                  -69.9379325), // Coordenadas del Palacio Nacional de la República Dominicana
                              zoom: 20.0, // Zoom inicial
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                          ),
                        ),
                      ],
                    )
                  : prestadoresLis.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Container(),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }
}
