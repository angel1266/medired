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
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:typed_data';

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _descuentoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  List<Map<String, dynamic>> planes = [];
  String? selectedPlan;
  String? selectedIcon;
  String? _editingServiceId;
  List<String> savedIcons = [];
  Uint8List? _imageFile;
  String? _imageUrl;

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
    List<String> icons = await getIcons();
    setState(() {
      savedIcons = icons;
    });
  }

  Future<void> save() async {
    for (var i = 0; i < medicalIcons.length; i++) {
      await saveIcon(medicalIcons[i].toString());
    }
    print("datos guardados");
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageFile = imageBytes;
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_imageFile == null) return null;

    try {
      String fileName = 'services/${DateTime.now().millisecondsSinceEpoch}.png';

      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref().child(fileName);

      await ref.putData(_imageFile!);

      String downloadURL = await ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _addOrUpdateService() async {
    if (_formKey.currentState!.validate()) {
      String? imageUrl = await _uploadImage();

      final data = {
        'nombre': _nombreController.text,
        'descuento': _descuentoController.text,
        'descripcion': _descripcionController.text,
        'id_centro': 'Nv044fsBNjhl6HeBGBqUh7awIRy1',
        'id_plan': selectedPlan,
        'status_cita': 1,
        'iconName': selectedIcon,
        'imageUrl': imageUrl ?? _imageUrl ?? '',
      };

      if (_editingServiceId == null) {
        await _firestore.collection('servicios').add(data);
      } else {
        await _firestore
            .collection('servicios')
            .doc(_editingServiceId)
            .update(data);
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
    _descripcionController.clear();
    setState(() {
      _editingServiceId = null;
      _imageFile = null;
      _imageUrl = null;
    });
  }

  void _editService(String id, Map<String, dynamic> data) {
    setState(() {
      _editingServiceId = id;
      _nombreController.text = data['nombre'];
      _descuentoController.text = data['descuento'];
      _descripcionController.text = data['descripcion'] ?? '';
      selectedPlan = data['id_plan'];
      selectedIcon = data['iconName'];
      _imageUrl = data['imageUrl'] ?? '';
    });
  }

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
                const SizedBox(width: 16),
                Expanded(
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
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 1,
                        color: const Color.fromARGB(255, 72, 71, 71),
                      ),
                    ),
                    child: DropdownButton<String>(
                      hint: const Text('Seleccione un Plan'),
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
                      underline: const SizedBox(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 1,
                        color: const Color.fromARGB(255, 72, 71, 71),
                      ),
                    ),
                    child: DropdownButton<String>(
                      hint: const Text('Seleccione un Icono'),
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
                      underline: const SizedBox(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Segunda Fila
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción del servicio',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.image),
                      label: const Text('Subir Imagen'),
                    ),
                    const SizedBox(height: 10),
                    if (_imageFile != null || _imageUrl != null)
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: _imageFile != null
                            ? Image.memory(_imageFile!, fit: BoxFit.cover)
                            : Image.network(_imageUrl!, fit: BoxFit.cover),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: _addOrUpdateService,
                      child: Text(
                        _editingServiceId == null ? 'Agregar' : 'Actualizar',
                      ),
                    ),
                    const SizedBox(height: 8),
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
                        child: SingleChildScrollView(
                          child: PaginatedDataTable(
                            header: const Text('Servicios'),
                            columns: const [
                              DataColumn(label: Text('Servicio')),
                              DataColumn(label: Text('Icono')),
                              DataColumn(label: Text('Descuento (%)')),
                              DataColumn(label: Text('descripcion')),
                              DataColumn(label: Text('imageUrl')),
                              DataColumn(label: Text('Acciones')),
                            ],
                            rowsPerPage: 5,
                            source: _ServicesDataSource(
                              icono: getIcon,
                              services: services,
                              onEdit: _editService,
                              onDelete: _deleteService,
                            ),
                            columnSpacing: 40.0,
                            horizontalMargin: 10.0,
                          ),
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
            : const Text('')),
        DataCell(Text(data['descuento'] ?? '')),
        DataCell(Text(data['descripcion'] ?? '')),
        DataCell(data['imageUrl'] != null && data['imageUrl'] != ''
            ? Image.network(data['imageUrl'], width: 50, height: 50)
            : const Icon(Icons.image_not_supported)),
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
