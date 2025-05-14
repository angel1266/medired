import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:medired/features/authentication/data/models/pruebas_model.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/asset.dart';
import 'package:medired/ui/organisms/beneficio_info.dart';

class MembershipCard extends StatefulWidget {
  const MembershipCard({
    super.key,
    required this.expirationDate,
    required this.membershipCode,
    required this.medicalConsultation,
    required this.medicalTest,
    required this.medicalImage,
    required this.points,
    required this.servicios,
  });

  final DateTime expirationDate;
  final String membershipCode;
  final int medicalConsultation;
  final int medicalTest;
  final int medicalImage;
  final int points;
  final List<dynamic> servicios;
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  _MembershipCardState createState() => _MembershipCardState();
}

class _MembershipCardState extends State<MembershipCard> {
  bool showProviders = false;
  String? selectedProvider;
  String? selectedServicio;
  List<TestModel> providerName = [];
  List<dynamic> prestadores = [];
  List<DataRow> listServiceRow = [];
  List<ServicioModel> servicios = [];
  List<ServicioModel> listaService = [];

  Future<List<ServicioModel>> _fetchServicios() async {
    servicios = [];
    listaService = [];

    try {
      List<dynamic> fetchedData = await getDocs(
          'servicios', 'id_centro', 'Nv044fsBNjhl6HeBGBqUh7awIRy1');

      List<dynamic> fetchedDataAsig = await getDocs('espescialidades_asignadas',
          'prestador_id', selectedProvider.toString());

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
    return servicios;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmallScreen = constraints.maxWidth < 500;
          return SizedBox(
            width: isSmallScreen ? constraints.maxWidth : 500,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: showProviders
                  ? _buildProvidersContent(isSmallScreen)
                  : _buildInitialContent(isSmallScreen),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInitialContent(bool isSmallScreen) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 400,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 48,
                      child: Image(image: AssetImage(Asset.logo)),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListTile(
                        title: const Text('Número de la membresía'),
                        subtitle: Text(widget.membershipCode),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListTile(
                        title: const Text('Fecha de expiración'),
                        subtitle: Text(MembershipCard._dateFormat
                            .format(widget.expirationDate)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    for (var i = 0; i < widget.servicios.length; i++)
                      Expanded(
                        child: ListTile(
                          title: Text(widget.servicios[i][0]),
                        ),
                      ),
                    Expanded(
                      child: ListTile(
                        title: const Text('Puntos'),
                        subtitle: Text(widget.points.toString()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Center(
          child: GestureDetector(
            onTap: () => setState(() => showProviders = true),
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.blueBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Más Información',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
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

  Widget _buildProvidersContent(bool isSmallScreen) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Información',
                style: TextStyle(fontSize: isSmallScreen ? 18 : 20),
              ),
              const SizedBox(height: 20),
              FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('member')
                    .where('memberInfo.memberType', isEqualTo: 2)
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Text('No se encontraron prestadores');
                  }

                  List<DropdownMenuItem<String>> providerItems = [
                    const DropdownMenuItem<String>(
                      value: '0',
                      child: Text('Selecciona Prestador'),
                    ),
                  ];

                  providerItems.addAll(
                    snapshot.data!.docs.map((doc) {
                      return DropdownMenuItem<String>(
                        value: doc.id,
                        child: Text(doc['companyInfo']['name'] ?? 'Sin nombre'),
                      );
                    }).toList(),
                  );

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButton<String>(
                      value: selectedProvider,
                      hint: const Text('Seleccione un prestador'),
                      items: providerItems,
                      isExpanded: true,
                      onChanged: (value) async {
                        if (value == '0') return;

                        setState(() {
                          selectedServicio = null;

                          selectedProvider = value;
                        });

                        /*for (var prestador in prestadores) {
                          createRowServices(prestador, providerName);
                        }

                        if (mounted) {
                          setState(() {
                            selectedProvider = value;
                          });
                        }*/
                      },
                    ),
                  );
                },
              ),
            ],
          ),
          selectedProvider == null && servicios.isEmpty
              ? Container()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<List<ServicioModel>>(
                      future: _fetchServicios(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        if (snapshot.data!.isEmpty) {
                          return const Text('No se encontraron prestadores');
                        }

                        List<DropdownMenuItem<String>> ServicioItems = [
                          const DropdownMenuItem<String>(
                            value: '0',
                            child: Text('Selecciona un servicio'),
                          ),
                        ];

                        ServicioItems.addAll(
                          snapshot.data!.map((doc) {
                            return DropdownMenuItem<String>(
                              value: doc.id,
                              child: Text(doc.name),
                            );
                          }).toList(),
                        );

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: DropdownButton<String>(
                            value: selectedServicio,
                            hint: const Text('Seleccione un servicio'),
                            items: ServicioItems,
                            isExpanded: true,
                            onChanged: (value) async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertBeneficio(
                                    prestadorConsult: false,
                                    id: selectedProvider.toString(),
                                    id_servicio: value!,
                                  );
                                },
                              );
                              selectedServicio = value;
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Volver',
                        style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  void createRowServices(dynamic prestador, List<TestModel> providerName) {
    Map<String, dynamic> especialidades = providerName
            .firstWhere((element) => element.id_servicio == prestador[1])
            .especialidades ??
        {};
    Map<String, dynamic> filter = {};

    for (var i = 0; i < especialidades.length; i++) {
      if (!filter.containsKey(especialidades['$i'][1])) {
        filter[especialidades['$i'][1]] = [];
      }
      filter[especialidades['$i'][1]].add(especialidades['$i'][0]);
    }

    int count = 0;
    filter.forEach((key, valor) {
      listServiceRow.add(DataRow(cells: [
        DataCell(count == 0 ? Text(prestador[0]['nombre']) : const Text('')),
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 50,
              maxWidth: 140,
            ),
            child: Center(
              child: Text(
                valor.toString().replaceAll(RegExp(r'\[|\]'), ''),
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        DataCell(Text(
          key != '0' ? '$key%' : "${prestador[0]["descuento"]}%",
        )),
      ]));
      count++;
    });
  }

  Future<List<TestModel>> obtenerEspecialidades(List prestadores) async {
    List<TestModel> especialidades = [];
    if (!mounted) {
      return especialidades; // Check if mounted before async operation
    }

    for (var prestador in prestadores) {
      List<dynamic> data = await getDocs(
          'especialidades', 'id_servicio', prestador[1].toString());
      for (var item in data) {
        especialidades.add(TestModel(
          especialidades: item[0]['especialidades'],
          id: item[1].toString(),
          id_servicio: item[0]['id_servicio'],
        ));
      }
    }
    return especialidades;
  }
}

class ServicioModel {
  final String name;
  final String id;
  ServicioModel({required this.name, required this.id});
}
