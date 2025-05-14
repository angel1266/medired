import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medired/features/authentication/data/models/service_asig_model.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/custom_dropdown_field.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';
import 'package:medired/ui/organisms/identification_form.dart';

class AppointmentUpdateForm extends StatefulWidget {
  final selectServicio;
  final especialidadSelect;
  final prestadorSelect;
  final fecha;
  final comentario;
  final id;
  final Function edit;
  final String id_prestador;
  final String cita;
  const AppointmentUpdateForm(
      {super.key,
      required this.selectServicio,
      required this.especialidadSelect,
      required this.prestadorSelect,
      required this.fecha,
      required this.comentario,
      required this.edit,
      required this.id,
      required this.cita,
      required this.id_prestador});
  @override
  createState() =>
      _AppointmentUpdateFormState(selectedServicio: selectServicio);
}

class _AppointmentUpdateFormState extends State<AppointmentUpdateForm> {
  _AppointmentUpdateFormState({required this.selectedServicio});

  Map<dynamic, String> servicios = {};
  Map<dynamic, String> especialidades = {};
  Map<String, dynamic> prestadores = {};
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final DateFormat _timeFormat = DateFormat('HH:mm');
  TextEditingController controllerComentario = TextEditingController(text: '');
  TextEditingController controllerHora = TextEditingController(text: '');
  DateTime date = DateTime.now();
  String comentario = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<PrestadorList> listPrestador = [];

  var selectServicio = '';
  var selectPrestador = '';
  final selectedServicio;
  var selectEspecialidades = '';
  List<ServicioAsig> listServicioAsig = [];
  List<Servicio> listService = [];

  Future<List<dynamic>> getDocs(
      String table, String field, dynamic filter) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(table)
        .where(field, isEqualTo: filter)
        .get();
    List<dynamic> list = [];
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      if ((table == 'servicios') && (data['status_cita'] == 1)) {
        list.add([data, doc.id]);
      } else if (table != 'servicios') {
        list.add([data, doc.id]);
      }
    }
    return list;
  }

  Future<void> _fetchServicios() async {
    try {
      List<dynamic> fetchedData = await getDocs(
          'servicios', 'id_centro', 'Nv044fsBNjhl6HeBGBqUh7awIRy1');

      servicios = {
        for (var i = 0; i < fetchedData.length; i++)
          fetchedData[i][1]: fetchedData[i][0]['nombre']
      };

      for (var i = 0; i < fetchedData.length; i++) {
        listService.add(
            Servicio(id: fetchedData[i][1], name: fetchedData[i][0]['nombre']));
      }

      //_fetchEspecialidades(selectedServicio);
      var dataSelectService = Map.fromEntries(servicios.entries
          .where((entry) => entry.value.contains(selectedServicio)));
      String targetValue = selectedServicio;
      String? keyForValue;
      dataSelectService.forEach((key, value) {
        if (value == targetValue) {
          keyForValue = key;
        }
      });
      selectServicio = keyForValue.toString();
      selectEspecialidades = widget.especialidadSelect;
      _fetchEspecialidades(selectServicio);
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> _fetchServiciosPrestador(servicio) async {
    try {
      List<dynamic> fetchedData = await getDocs(
          'espescialidades_asignadas', 'id_servicio', selectServicio ?? "");

      for (var i = 0; i < fetchedData.length; i++) {
        List<Especialidades> listEspecialidades = [];
        fetchedData[i][0]['especialidades'].forEach((key, valor) {
          listEspecialidades.add(Especialidades(id: key, name: valor[0]));
        });

        listServicioAsig.add(ServicioAsig(
            id_prestador: fetchedData[i][0]['prestador_id'],
            id_servicio: fetchedData[i][0]['id_servicio'],
            lista: listEspecialidades));
      }

      /*if (servicioSelected != '') {
        DateFormat format = DateFormat('dd/MM/yyyy');
        date = format.parse(_dateFormat.format(fecha).toString());
        var dataSelectService = Map.fromEntries(servicios.entries
            .where((entry) => entry.value.contains(servicioSelected)));
        String targetValue = servicioSelected;
        String? keyForValue;
        dataSelectService.forEach((key, value) {
          if (value == targetValue) {
            keyForValue = key;
          }
        });
        servicioSelected2 = keyForValue.toString();
      }*/
      setState(() {});
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> _fetchEspecialidades(id) async {
    try {
      List<dynamic> fetchedData =
          await getDocs('especialidades', 'id_servicio', id);

      especialidades = {
        for (var i = 0; i < fetchedData[0][0]['especialidades'].length; i++)
          fetchedData[0][0]['especialidades']['$i'][0]: fetchedData[0][0]
              ['especialidades']['$i'][0]
      };
      _fetchPrestador();

      setState(() {});
    } catch (e) {
      debugPrint('Error fetching especialidades: $e');
    }
  }

  Future<List<dynamic>> getDocsProvider(
      String table, String field, dynamic filter) async {
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

  Future<void> _fetchPrestador() async {
    try {
      var idService = selectServicio;
      _fetchServiciosPrestador(idService);

      List<dynamic> fetchedData =
          await getDocsProvider('member', 'memberInfo.memberType', 2);

      setState(() {
        List<Map<String, dynamic>> prestadoresList = [];
        for (var e = 0; e < fetchedData.length; e++) {
          Map<String, dynamic> map = fetchedData[e][0];
          List<ServicioAsig> liSa = (listServicioAsig.length > 0
              ? listServicioAsig
                  .where(
                      (element) => element.id_servicio.toString() == idService)
                  .where((element) =>
                      element.id_prestador.toString() == fetchedData[e][1])
                  .toList()
              : []);

          List<Especialidades> liEs = liSa.length > 0
              ? liSa[0]
                  .lista
                  .where((element) => element.name == selectEspecialidades)
                  .toList()
              : [];

          if (liEs.length > 0) {
            prestadoresList
                .add({map['companyInfo']['name']: map['companyInfo']['name']});
            listPrestador.add(PrestadorList(
                id: fetchedData[e][1], name: map['companyInfo']['name']));
          }
        }
        if (prestadoresList.length > 0) {
          selectPrestador == "" ? null : "";
          prestadores = {};
          for (var i = 0; i < prestadoresList.length; i++) {
            prestadores.addAll(prestadoresList[i]);
          }
        }
      });
    } catch (e) {
      debugPrint('Error fetching prestador;: $e');
    }
  }

  void _updateDocument(
      id, description, date, hora, servicio, especialidad) async {
    try {
      String dateString = "${_dateFormat.format(date)} " + hora;
      DateFormat originalFormat = DateFormat('dd/MM/yyyy HH:mm');
      DateTime dateTime = originalFormat.parse(dateString);
      DateFormat newFormat = DateFormat("dd 'de' MMMM 'de' yyyy, h:mm:ss a");
      String formattedDate = newFormat.format(dateTime);
      DateTime formattedDateTime = newFormat.parse(formattedDate);
      Timestamp timestamp = Timestamp.fromDate(formattedDateTime);
      PrestadorList prestador = listPrestador.firstWhere(
          (element) => element.name.toString() == selectPrestador!.toString());

      DocumentReference documentReference =
          _firestore.collection('appointment').doc(id);
      Map<String, dynamic> updatedData = {
        'appointmentInfo': {
          'description': '$description',
          'date': timestamp,
          'serviceProvider': {'firstName': prestador.name, 'uid': prestador.id}
        },
        'medicalTest': {
          'category': 0,
          'description': '',
          'durationDescription': '0',
          'id': '$servicio',
          'name': '$especialidad'
        }
      };

      await documentReference.set(updatedData, SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Cita actualizada con éxito',
                style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.green),
      );

      widget.edit(id, selectPrestador, 1, widget.cita);
      widget.edit(id, selectPrestador, 2, widget.cita);
      Navigator.pop(context);
    } catch (e) {
      print('Error al actualizar el documento: $e');
    }
  }

  @override
  void initState() {
    DateFormat format = DateFormat('dd/MM/yyyy');
    date = format.parse(_dateFormat.format(widget.fecha));
    controllerHora.text = _timeFormat.format(widget.fecha);
    controllerComentario.text = widget.comentario;

    _fetchServicios();
    setState(() {
      selectPrestador == widget.prestadorSelect;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          servicios.isNotEmpty
              ? CustomDropdownFormField(
                  'Servicios:',
                  currentValue: selectServicio != '' && servicios.isNotEmpty
                      ? selectServicio
                      : null,
                  options: servicios,
                  onChanged: (value) {
                    setState(() {
                      especialidades = {};
                      selectEspecialidades = '';
                      selectServicio = value;
                    });
                    _fetchEspecialidades(selectServicio);
                  },
                )
              : const Center(child: CircularProgressIndicator()),
          especialidades.isNotEmpty
              ? CustomDropdownFormField(
                  'Especialidadd:',
                  currentValue:
                      selectEspecialidades != '' && especialidades.isNotEmpty
                          ? selectEspecialidades
                          : null,
                  options: especialidades,
                  onChanged: (value) {
                    setState(() {
                      selectEspecialidades = value;
                      _fetchPrestador();
                    });
                  },
                )
              : const Center(child: CircularProgressIndicator()),
          prestadores.isNotEmpty
              ? CustomDropdownFormField(
                  'Proveedor de servicio:',
                  currentValue: selectPrestador == "" ? null : selectPrestador,
                  options: prestadores,
                  onChanged: (value) {
                    selectPrestador = value!;
                  },
                )
              : const Center(child: CircularProgressIndicator()),
          CustomTextFormField(
            'Fecha',
            hintText: '',
            controller: TextEditingController(text: _dateFormat.format(date)),
            keyboardType: TextInputType.phone,
            readOnly: true,
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.date_range,
                color: AppColors.blueBackground,
              ),
              onPressed: () => _onDatePressed(context),
            ),
          ),
          CustomTextFormField(
            'Hora',
            hintText: '',
            controller: controllerHora,
            keyboardType: TextInputType.phone,
            readOnly: true,
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.access_time,
                color: AppColors.blueBackground,
              ),
              onPressed: () => _onTimePressed(context),
            ),
          ),
          CustomTextFormField('Descripción', controller: controllerComentario),
          const SizedBox(height: 25),
          Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _updateDocument(
                          widget.id,
                          controllerComentario.text,
                          date,
                          controllerHora.text,
                          servicios['$selectServicio'],
                          selectEspecialidades);
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green,
                      ),
                      child: const Center(
                          child: Text('Actualizar Cita',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                      child: const Center(
                          child: Text('Cancelar',
                              style: TextStyle(color: Colors.black))),
                    ),
                  )
                ]),
          )
        ],
      ),
    );
  }

  void _onTimePressed(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (!context.mounted) return;
      if (value != null) {
        setState(() {
          date = date.add(Duration(hours: value.hour, minutes: value.minute));
          controllerHora.text = _timeFormat.format(date);
        });
      }
    });
  }

  void _onDatePressed(BuildContext context) async {
    await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      currentDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    ).then((value) {
      if (!context.mounted) return;
      if (value != null) {
        setState(() {
          date = value;
        });
      }
    });
  }
}

class PrestadorList {
  String id;
  String name;
  PrestadorList({required this.id, required this.name});
}
