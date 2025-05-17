import 'package:excel/excel.dart' as exc;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reportes_medired/layout_main.dart';
import 'package:reportes_medired/list_pss.dart';
import 'package:reportes_medired/my_home_page.dart';
import 'package:reportes_medired/payment_report_page.dart';
import 'package:reportes_medired/register_pss.dart';
import 'package:universal_html/html.dart' as html;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:dropdown_search/dropdown_search.dart';

class EspecialidadesPage extends StatefulWidget {
  @override
  _EspecialidadesPageState createState() => _EspecialidadesPageState();
}

class _EspecialidadesPageState extends State<EspecialidadesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descuentoController = TextEditingController();
  List<Map<String, dynamic>> planes = [];
  List<Map<String, dynamic>> servicios = [];
  String? selectedPlan;
  String? selectedServicio;
  String? selectedIcon;
  String? _editingServiceId;
  List<String> savedIcons = [];
  String editEspecislidad = "0";

  Future<int> getEspecialidades(id) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('especialidades')
        .where('id_servicio', isEqualTo: id)
        .get();
    var data = querySnapshot.docs
        .map((doc) => {
              'id': doc.id,
              'data': doc.data() as Map<String, dynamic>,
            })
        .toList();
    print(data);
    return 0;
  }

  Future<List<Map<String, dynamic>>> getPlans() async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('planes')
        .where('status', isEqualTo: "1")
        .get();
    var data = querySnapshot.docs
        .map((doc) => {
              'id': doc.id,
              'data': doc.data() as Map<String, dynamic>,
            })
        .toList();
    setState(() {
      planes = data;
    });

    return data;
  }

  Future<List<Map<String, dynamic>>> getServicios(id) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('servicios')
        .where('id_plan', isEqualTo: id)
        .get();
    var data = querySnapshot.docs
        .map((doc) => {
              'id': doc.id,
              'data': doc.data() as Map<String, dynamic>,
            })
        .toList();
    setState(() {
      servicios = data;
    });

    return data;
  }

  IconData getIcon(icon) {
    final match = RegExp(r'U\+([0-9a-fA-F]+)').firstMatch(icon);
    if (match != null) {
      final hexValue = match.group(1)!;
      final iconDataInt = int.parse(hexValue, radix: 16);
      return IconData(iconDataInt,
          fontFamily: 'FontAwesomeSolid', fontPackage: 'font_awesome_flutter');
    }
    return const IconData(
      0x0F06D,
      fontFamily: 'FontAwesomeSolid',
      fontPackage: 'font_awesome_flutter',
    );
  }

  final List<IconData> medicalIcons = [];

  @override
  void initState() {
    _loadIcons();
    getPlans();
    super.initState();
  }

  Future<void> _loadIcons() async {
    List<String> icons = await FirestoreService().getIcons();
    setState(() {
      savedIcons = icons;
    });
  }

  Future<void> save() async {
    for (var i = 0; i < medicalIcons.length; i++) {
      await FirestoreService().saveIcon(medicalIcons[i].toString());
    }
    print("datos guardados");
  }

  Future<void> _addOrUpdateService() async {
  if (_formKey.currentState!.validate()) {
    QuerySnapshot querySnapshot = await _firestore
        .collection('especialidades')
        .where('id_servicio', isEqualTo: selectedServicio)
        .get();

    if (_editingServiceId == null) {
      // Agregar nuevo servicio
      if (querySnapshot.docs.isNotEmpty) {
        for (QueryDocumentSnapshot doc in querySnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          var especialidades = data["especialidades"] as Map<String, dynamic>;

          // ✅ Buscar índice numérico máximo de claves válidas
          int maxIndex = -1;
          especialidades.forEach((key, value) {
            final index = int.tryParse(key);
            if (index != null && index > maxIndex) {
              maxIndex = index;
            }
          });

          final myname = (maxIndex + 1).toString();

          await _firestore.collection('especialidades').doc(doc.id).update({
            'especialidades.$myname': [_nombreController.text, '0']
          });
        }
      } else {
        await _firestore.collection('especialidades').add({
          'especialidades': {
            '0': [_nombreController.text, '0']
          },
          'id_servicio': selectedServicio
        });
      }
    } else {
      // Actualizar servicio existente
      await _firestore
          .collection('especialidades')
          .doc(_editingServiceId)
          .update({
        'especialidades.$editEspecislidad': [_nombreController.text, '0'],
      });
    }

    _clearForm();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_editingServiceId == null
            ? 'Servicio agregado'
            : 'Servicio actualizado'),
      ),
    );
  }
}


  Future<void> _deleteService(String id, name) async {
    await _firestore.collection('especialidades').doc(id).update({
      'especialidades.${name}': FieldValue.delete(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Especialidad eliminado')),
    );
    Navigator.pop(context);
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nombreController.clear();
    _descuentoController.clear();
    setState(() {
      _editingServiceId = null;
    });
  }

  void _editService(
      String id, Map<String, dynamic> data, String name, String arr) async {
    DocumentSnapshot querySnapshot =
        await _firestore.collection('servicios').doc(data['id_servicio']).get();

    if (querySnapshot.exists) {
      Map<String, dynamic> data2 = querySnapshot.data() as Map<String, dynamic>;

      setState(() {
        _editingServiceId = id;
        _nombreController.text = name;
        selectedPlan = data2['id_plan'];
        selectedServicio = data['id_servicio'];
        editEspecislidad = arr;
      });
      Navigator.pop(context);
    } else {
      print('No such document!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: LayoutMain(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nombreController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre de la especialidad',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ingrese un nombre';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 72, 71, 71))),
                  child: DropdownButton<String>(
                    hint: const Text('Seleccione un Plan'),
                    value: selectedPlan,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPlan = newValue;
                        getServicios(newValue);
                      });
                    },
                    items: planes.map((item) {
                      return DropdownMenuItem<String>(
                        value: item["id"],
                        child: Text("Plan " + item["data"]["costo"]),
                      );
                    }).toList(),
                    underline: const SizedBox(),
                  ),
                ),
                servicios.length < 1
                    ? Container()
                    : _editingServiceId != null
                        ? Container()
                        : const SizedBox(width: 16),
                servicios.length < 1
                    ? Container()
                    : _editingServiceId != null
                        ? Container()
                        : Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    width: 1,
                                    color:
                                        const Color.fromARGB(255, 72, 71, 71))),
                            child: DropdownButton<String>(
                              hint: const Text('Seleccione un servicio'),
                              value: selectedServicio,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedServicio = newValue;
                                });
                              },
                              items: servicios.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item["id"],
                                  child: Text(item["data"]["nombre"]),
                                );
                              }).toList(),
                              underline: const SizedBox(),
                            ),
                          ),

                /* Expanded(
                            child: DropdownSearch<String>(
                              mode: Mode.form,
                              selectedItem: selectedIcon,
                              dropdownBuilder: (context, selectedItem) {
                                return Row(
                                  children: [
                                    Icon(
                                      getIconData(selectedItem ?? ''),
                                      size: 24,
                                    ),
                                    SizedBox(width: 8),
                                    Text(selectedItem ?? ''),
                                  ],
                                );
                              },
                              items: savedIcons,
                              onChanged: (value) {
                                setState(() {
                                  selectedIcon = value;
                                });
                              },
                              selectedItem: selectedIcon,
                            ),
                          ),*/
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _addOrUpdateService,
                  child: Text(
                    _editingServiceId == null ? 'Agregar' : 'Actualizar',
                  ),
                ),
                const SizedBox(width: 8),
                if (_editingServiceId != null)
                  ElevatedButton(
                    onPressed: _clearForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text('Cancelar'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('servicios').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('No hay servicios disponibles'),
                    );
                  }

                  final services = snapshot.data!.docs;

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: PaginatedDataTable(
                          header: const Text('Servicios'),
                          columns: const [
                            DataColumn(label: Text('Servicio')),
                            DataColumn(label: Text('Icono')),
                            DataColumn(label: Text('Descuento (%)')),
                            DataColumn(label: Text('N# Especialidades')),
                            DataColumn(label: Text('Acciones')),
                          ],
                          rowsPerPage: 5,
                          source: _ServicesDataSource(
                              icono: getIcon,
                              services: services,
                              onEdit: _editService,
                              onDelete: _deleteService,
                              onDetailsView: _showEspecialidades),
                          columnSpacing: 40.0,
                          horizontalMargin: 10.0,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future<List<Map<String, dynamic>>> loadEsp(id) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('especialidades')
        .where("id_servicio", isEqualTo: id)
        .get();
    return querySnapshot.docs
        .map((doc) => {
              'id': doc.id,
              'data': doc.data() as Map<String, dynamic>,
            })
        .toList();
  }

  void _showEspecialidades(Map<String, dynamic> especialidades, String serv,
      String id, String dct) async {
    List<DataRow> list = [];
    List<Map<String, dynamic>> data = await loadEsp(id);
    for (var i = 0; i < data.length; i++) {
      if (data[i]["data"]["especialidades"].length > 0) {
        var i = 0;
        bool init = false;
        data[i]["data"]["especialidades"].forEach((key, value) {
          list.add(DataRow(cells: [
            DataCell(Text(value[0])),
            DataCell(
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editService(
                        data[i]["id"], data[i]["data"], value[0], key),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteService(data[i]["id"], key),
                  ),
                ],
              ),
            ),
          ]));
        });
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Especialidades - $serv'),
          content: SingleChildScrollView(
            child: DataTable(columns: [
              const DataColumn(label: Text("Especialidad")),
              const DataColumn(label: Text("Acción"))
            ], rows: list),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _ServicesDataSource extends DataTableSource {
  final List<QueryDocumentSnapshot> services;
  final Function(String, Map<String, dynamic>, String, String) onEdit;
  final Function(String, String) onDelete;
  final Function(String) icono;
  final Function(Map<String, dynamic>, String, String, String) onDetailsView;

  _ServicesDataSource({
    required this.services,
    required this.onEdit,
    required this.onDelete,
    required this.onDetailsView,
    required this.icono,
  });

  @override
  DataRow getRow(int index) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    if (index >= services.length) return const DataRow(cells: []);

    final service = services[index];
    final data = service.data() as Map<String, dynamic>;

    return DataRow(
      cells: [
        DataCell(Text(data['nombre'] ?? '')),
        DataCell(icono(data['iconName']) != ""
            ? FaIcon(icono(data['iconName']))
            : const Text('')),
        DataCell(Text(data['descuento'] ?? '')),
        DataCell(StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('especialidades')
                .where("id_servicio", isEqualTo: service.id)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('0'),
                );
              }

              final esp = snapshot.data!.docs;
              return Center(
                  child: Text(esp[0]["especialidades"].length.toString()));
            })),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.visibility),
                onPressed: () => onDetailsView(
                    data, data['nombre'], service.id, data['descuento']),
                tooltip: 'Ver Detalles',
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => services.length;

  @override
  int get selectedRowCount => 0;
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<void> saveIcon(String iconName) async {
    await _db.collection('icons').add({'iconName': iconName});
  }

  Future<List<String>> getIcons() async {
    List<String> icons = [];
    QuerySnapshot querySnapshot = await _db.collection('icons').get();
    for (var doc in querySnapshot.docs) {
      icons.add(doc['iconName'] as String);
    }
    return icons;
  }
}
