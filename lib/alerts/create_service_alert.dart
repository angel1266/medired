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

class CreateServiceAlert extends StatefulWidget {
  final BuildContext mycontext;
  final Function update;
  final String idPlan;

  CreateServiceAlert(
      {required this.mycontext, required this.update, required this.idPlan});
  @override
  _CreateServiceAlertState createState() => _CreateServiceAlertState();
}

class _CreateServiceAlertState extends State<CreateServiceAlert> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descuentoController = TextEditingController();

  List<Map<String, dynamic>> planes = [];
  String? selectedPlan;
  String? selectedIcon;
  String? _editingServiceId;
  List<String> savedIcons = [];

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
      final data = {
        'nombre': _nombreController.text,
        'descuento': _descuentoController.text,
        'id_centro': 'Nv044fsBNjhl6HeBGBqUh7awIRy1',
        'id_plan': selectedPlan,
        'status_cita': 1,
        'iconName': selectedIcon,
      };

      if (_editingServiceId == null) {
        // Add new service
        await _firestore.collection('servicios').add(data);
      } else {
        // Update existing service
        await _firestore
            .collection('servicios')
            .doc(_editingServiceId)
            .update(data);
      }

      _clearForm();

      ScaffoldMessenger.of(widget.mycontext).showSnackBar(
        SnackBar(
          content: Text(_editingServiceId == null
              ? 'Servicio agregado'
              : 'Servicio actualizado'),
        ),
      );
      widget.update(widget.idPlan);
      Navigator.pop(widget.mycontext);
    }
  }

  Future<void> _deleteService(String id) async {
    await _firestore.collection('servicios').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Servicio eliminado')),
    );
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _nombreController.clear();
    _descuentoController.clear();
    setState(() {
      _editingServiceId = null;
    });
  }

  void _editService(String id, Map<String, dynamic> data) {
    setState(() {
      _editingServiceId = id;
      _nombreController.text = data['nombre'];
      _descuentoController.text = data['descuento'];
      selectedPlan = data['id_plan'];
      selectedIcon = data['iconName'];
    });
  }

  // Funciones para generación de reportes
  Future<void> _generateAndDownloadExcel() async {
    await _generateExcel('members.xlsx',
        (setDate, currentDate) => setDate.toDate().isAfter(currentDate));
  }

  Future<void> _generateAndDownloadExpiredExcel() async {
    await _generateExcel('expired_members.xlsx',
        (setDate, currentDate) => setDate.toDate().isBefore(currentDate));
  }

  Future<void> _generateExcel(String fileName,
      bool Function(Timestamp, DateTime) filterCondition) async {
    try {
      QuerySnapshot subscriptionSnapshot =
          await _firestore.collection('subscription').get();
      List<Map<String, dynamic>> subscriptionList = subscriptionSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      var excel = exc.Excel.createExcel();
      var sheet = excel['Sheet1'];

      if (subscriptionList.isNotEmpty) {
        var headers = subscriptionList[0].keys.toList();
        sheet.appendRow(headers.cast<exc.CellValue?>());

        for (var row in subscriptionList) {
          sheet.appendRow(headers
              .map((header) => row[header].toString())
              .cast<exc.CellValue?>()
              .toList());
        }
      } else {
        sheet.appendRow([]);
      }

      var bytes = excel.encode();
      var blob = html.Blob([bytes],
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      var url = html.Url.createObjectUrlFromBlob(blob);
      var anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Archivo Excel generado con éxito.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al generar el archivo Excel: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del servicio',
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
              Container(
                margin: EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: _descuentoController,
                  decoration: const InputDecoration(
                    labelText: 'Descuento (%)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ingrese un descuento válido';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 10, right: 10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        width: 1, color: Color.fromARGB(255, 72, 71, 71))),
                child: DropdownButton<String>(
                  hint: Text('Seleccione un Plan'),
                  value: selectedPlan,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPlan = newValue;
                    });
                  },
                  items: planes.map((item) {
                    return DropdownMenuItem<String>(
                      value: item["id"],
                      child: Text("Plan " + item["data"]["costo"]),
                    );
                  }).toList(),
                  underline: SizedBox(),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 10, right: 10),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                        width: 1, color: Color.fromARGB(255, 72, 71, 71))),
                child: DropdownButton<String>(
                  hint: Text('Seleccione un Icono'),
                  value: selectedIcon,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedIcon = newValue;
                    });
                  },
                  items: savedIcons.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: FaIcon(getIcon(item)),
                    );
                  }).toList(),
                  underline: SizedBox(),
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
        ],
      ),
    );
  }
}

class _ServicesDataSource extends DataTableSource {
  final List<QueryDocumentSnapshot> services;
  final Function(String, Map<String, dynamic>) onEdit;
  final Function(String) onDelete;
  final Function(String) icono;

  _ServicesDataSource({
    required this.services,
    required this.onEdit,
    required this.onDelete,
    required this.icono,
  });

  @override
  DataRow getRow(int index) {
    if (index >= services.length) return const DataRow(cells: []);

    final service = services[index];
    final data = service.data() as Map<String, dynamic>;

    return DataRow(
      cells: [
        DataCell(Text(data['nombre'] ?? '')),
        DataCell(icono(data['iconName']) != ""
            ? FaIcon(icono(data['iconName']))
            : Text('')),
        DataCell(Text(data['descuento'] ?? '')),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => onEdit(service.id, data),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(service.id),
              ),
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
