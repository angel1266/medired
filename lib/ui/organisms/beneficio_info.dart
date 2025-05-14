import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:medired/features/authentication/data/models/pruebas_model.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/asset.dart';

class AlertBeneficio extends StatefulWidget {
  const AlertBeneficio(
      {super.key,
      required this.id,
      required this.id_servicio,
      this.prestadorConsult = false});
  final String id;
  final bool prestadorConsult;
  final String id_servicio;
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  _AlertBeneficiotate createState() => _AlertBeneficiotate();
}

class _AlertBeneficiotate extends State<AlertBeneficio> {
  bool showProviders = false;
  String? selectedProvider;
  List<TestModel> providerName = [];
  List<dynamic> prestadores = [];
  List<dynamic> prestadores2 = [];
  List<Widget> listServiceRow = [];
  bool vacio = false;
  Map<String, dynamic> serviciosList = {};

  @override
  void initState() {
    // TODO: implement initState
    getBdDoc('servicios', widget.id_servicio.toString());

    if (widget.prestadorConsult) {
      _fetchPrestadores();
    } else {
      getInfo(widget.id.toString());
    }
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

  Future<void> _fetchPrestadores() async {
    try {
      List<dynamic> fetchedData =
          await getDocs('member', 'memberInfo.memberType', 2);

      setState(() {
        prestadores2 = fetchedData.map((entry) {
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

  getInfo(String id) async {
    prestadores =
        await getDocs('servicios', 'id_centro', 'Nv044fsBNjhl6HeBGBqUh7awIRy1');
    providerName = await obtenerEspecialidades(serviciosList) == null
        ? []
        : await obtenerEspecialidades(prestadores);

    createRowServices(serviciosList, providerName);

    if (prestadores.isEmpty) {
      vacio = true;
    }
    setState(() {});
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

  getBdDoc(table, String id) async {
    var docRef = FirebaseFirestore.instance.collection(table).doc(id);

    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      serviciosList = docSnapshot.data() as Map<String, dynamic>;
      // ... and so on
    } else {
      print('Document does not exist');
    }
    setState(() {});
  }

  Widget ListPrestadores() {
    List<DropdownMenuItem<String>> providerItems = [
      const DropdownMenuItem<String>(
        value: '0',
        child: Text('Selecciona Prestador'),
      ),
    ];
    if (prestadores2.isNotEmpty) {
      providerItems.addAll(
        prestadores2.map((doc) {
          print("mi id " + doc['id']);
          return DropdownMenuItem<String>(
            value: doc['id'],
            child: Text(doc['data']['companyInfo']['name'] ?? 'Sin nombre'),
          );
        }).toList(),
      );
      print("prestador vacio1");
    } else {
      print("prestador vacio2");
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<String>(
        value: selectedProvider,
        hint: const Text('Seleccione un prestador'),
        items: providerItems,
        isExpanded: true,
        onChanged: (value) async {
          selectedProvider = value;
          if (value != '0') {
            getInfo(value!);
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _buildProvidersContent() {
    return widget.prestadorConsult &&
            (selectedProvider == null ||
                prestadores.isEmpty ||
                selectedProvider == '0')
        ? ListPrestadores()
        : (selectedProvider == null || selectedProvider == '') &&
                widget.prestadorConsult
            ? Container()
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    widget.prestadorConsult ? ListPrestadores() : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(serviciosList.isNotEmpty
                          ? serviciosList['nombre']
                          : ''),
                    ),
                    if (providerName.isNotEmpty)
                      const Row(
                        children: [
                          Text(
                            'Especialidades',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text('Descuento',
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    Column(
                      children: listServiceRow,
                    ),
                    vacio
                        ? const Center(
                            child: Text(
                                'No hay beneficios registrados pera el prestador seleccionado'))
                        : prestadores.isEmpty
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

  createRowServices(prestador, List<TestModel> providerName) {
    Map<String, dynamic> especialidades = providerName
            .firstWhere((element) => element.id_servicio == widget.id_servicio)
            .especialidades ??
        {};
    Map<String, dynamic> filter = {};
    listServiceRow = [];
    for (var i = 0; i < especialidades.length; i++) {
      if (!filter.containsKey(especialidades['$i'][1])) {
        filter[especialidades['$i'][1]] = [];
      }
      filter[especialidades['$i'][1]].add(especialidades['$i'][0]);
    }

    var count = 0;
    filter.forEach((key, valor) {
      listServiceRow.add(const Divider(
        color: Colors.grey,
      ));
      if (count == 0) {
        listServiceRow.add(Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width < 500
                  ? MediaQuery.of(context).size.width * 0.5
                  : MediaQuery.of(context).size.width * 0.2,
              child: Text(valor.toString().replaceAll(RegExp(r'\[|\]'), ''),
                  style: const TextStyle(fontSize: 12)),
            ),
            const Spacer(),
            Text(
                key.toString() != '0'
                    ? '$key%'
                    : serviciosList['descuento'] + '%',
                style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ));
        count++;
      } else {
        listServiceRow.add(Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width < 500
                  ? MediaQuery.of(context).size.width * 0.5
                  : MediaQuery.of(context).size.width * 0.2,
              child: Text(valor.toString().replaceAll(RegExp(r'\[|\]'), ''),
                  style: const TextStyle(fontSize: 12)),
            ),
            const Spacer(),
            Text(
                key.toString() != '0'
                    ? '$key%'
                    : serviciosList['descuento'] + '%',
                style: const TextStyle(fontWeight: FontWeight.bold))
          ],
        ));
      }
    });
  }

  obtenerEspecialidades(prestadores) async {
    List<TestModel> especialidades = [];
    if (prestadores.length > 0) {
      List<dynamic> data = [];
      if (widget.prestadorConsult) {
         data = await getDocs(
            'espescialidades_asignadas', 'prestador_id', selectedProvider);
      } else {
         data = await getDocs(
            'espescialidades_asignadas', 'prestador_id', widget.id);
      }
      for (var e = 0; e < data.length; e++) {
        if (data.isNotEmpty) {
          if(data[e][0]["id_servicio"] == widget.id_servicio){
             especialidades.add(TestModel(
              especialidades: data[e][0]['especialidades'],
              id: data[e][1].toString(),
              id_servicio: data[e][0]['id_servicio']));
          }

          
        }
      }
    }

    return especialidades;
  }
}
