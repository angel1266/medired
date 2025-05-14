import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medired/core/utils/responsive.dart';
import 'package:medired/core/utils/selectable_item.dart';
import 'package:medired/core/value_objects/medical_specialization.dart';
import 'package:medired/core/value_objects/service_type.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/authentication/data/models/service_provider_model.dart';
import 'package:medired/features/authentication/domain/entities/patient.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/custom_dropdown_field.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';
import 'package:medired/ui/template/selectable_item_template.dart';

class PointsForm extends StatefulWidget {
  const PointsForm({
    required this.patients,
    required this.onSelected,
    required this.selectedPatient,
    required this.onChangedServiceType,
    required this.selectedServiceType,
    required this.specializations,
    required this.onChangedSpecialization,
    required this.selectedSpecialization,
    required this.tests,
    required this.onChangedTest,
    required this.selectedTest,
    required this.controller,
    required this.amountController,
    required this.onPressed,
    required this.suscrip,
    super.key,
  });

  final List<Patient> patients;
  final Function(SelectableItem<Patient>) onSelected;
  final String selectedPatient;
  final Function(dynamic) onChangedServiceType;
  final dynamic selectedServiceType;
  final Map<MedicalSpecialization, String> specializations;
  final Function(dynamic) onChangedSpecialization;
  final dynamic selectedSpecialization;
  final Map<MedicalTest, String> tests;
  final Function(MedicalTest?) onChangedTest;
  final MedicalTest? selectedTest;
  final TextEditingController controller;
  final TextEditingController amountController;
  final Function()? onPressed;
  final Function? suscrip;

  @override
  createState() => _PointsFormState(
      patients: patients,
      onSelected: onSelected,
      selectedPatient: selectedPatient,
      onChangedServiceType: onChangedServiceType,
      onChangedSpecialization: onChangedSpecialization,
      selectedServiceType: selectedServiceType,
      specializations: specializations,
      onChangedTest: onChangedTest,
      selectedSpecialization: selectedSpecialization,
      selectedTest: selectedTest,
      controller: controller,
      amountController: amountController,
      tests: tests,
      onPressed: onPressed);
}

class _PointsFormState extends State<PointsForm> {
  _PointsFormState({
    required this.patients,
    required this.onSelected,
    required this.selectedPatient,
    required this.onChangedServiceType,
    required this.selectedServiceType,
    required this.specializations,
    required this.onChangedSpecialization,
    required this.selectedSpecialization,
    required this.tests,
    required this.onChangedTest,
    required this.selectedTest,
    required this.controller,
    required this.amountController,
    required this.onPressed,
  });
  final List<Patient> patients;
  final Function(SelectableItem<Patient>) onSelected;
  final String selectedPatient;
  final Function(dynamic) onChangedServiceType;
  final dynamic selectedServiceType;
  final Map<MedicalSpecialization, String> specializations;
  final Function(dynamic) onChangedSpecialization;
  final dynamic selectedSpecialization;
  final Map<MedicalTest, String> tests;
  final Function(MedicalTest?) onChangedTest;
  final MedicalTest? selectedTest;
  final TextEditingController controller;
  final TextEditingController amountController;
  String selectedPatient1 = '';
  final Function()? onPressed;
  bool especialidState = false;
  String especialidadSelect = '';

  String selectPrestador = '';

  Map<dynamic, dynamic> servicios = {};
  Map<dynamic, String> especialidades = {};
  List<ServiceProviderModel> prestadoresService = [];
  Map<String, dynamic> prestadores = {};

  bool isImage = false;

  DateTime date = DateTime.now();

  Future<void> _fetchServicios() async {
    try {
      List<dynamic> fetchedData = await getDocs(
          'servicios', 'id_centro', 'Nv044fsBNjhl6HeBGBqUh7awIRy1');
      setState(() {
        servicios = {
          for (var i = 0; i < fetchedData.length; i++)
            fetchedData[i][1]: fetchedData[i][0]['nombre']
        };
      });
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> _fetchPrestador() async {
    try {
      List<dynamic> fetchedData =
          await getDocsProvider('member', 'memberInfo.memberType', 2);
      setState(() {
        for (var e = 0; e < fetchedData.length; e++) {
          Map<String, dynamic> map = fetchedData[e][0];
          prestadores = {
            map['companyInfo']['name']: map['companyInfo']['name']
          };

          prestadoresService.add(ServiceProviderModel.fromJson(map));
        }

        print(prestadores.toString());
      });
    } catch (e) {
      debugPrint('Error fetching prestador: $e');
    }
  }

  Future<void> _fetchEspecialidades(id) async {
    try {
      List<dynamic> fetchedData =
          await getDocs('especialidades', 'id_servicio', id);
      setState(() {
        setState(() {
          especialidadSelect = fetchedData[0][0]['especialidades']['0'][0];
        });
        especialidades = {
          for (var i = 0; i < fetchedData[0][0]['especialidades'].length; i++)
            fetchedData[0][0]['especialidades']['$i'][0]: fetchedData[0][0]
                ['especialidades']['$i'][0]
        };
        setState(() {
          especialidState = true;
        });
      });
    } catch (e) {
      debugPrint('Error fetching especialidades: $e');
    }
  }

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

  updateService(value) {
    _fetchEspecialidades(value);

    onChangedServiceType(value);
  }

  updateSelectPaciente(value) async {
    var data = await widget.suscrip!(value.data.authInfo.uid, "paciente");
    if (data) {
      onSelected(value);

      setState(() {
        Patient paciente = value.data;
        selectedPatient1 = paciente.fullName ?? '';
      });
    } else {
      Patient paciente = value.data;
      ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('El paciente ${paciente.fullName} tiene vencida la suscripción')),
        );
    }
  }

  @override
  void initState() {
    _fetchServicios();
    print('El nombre del paciente es $selectedPatient');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTextFormField(
          'Paciente',
          readOnly: true,
          controller: TextEditingController(text: selectedPatient1),
          suffixIcon: IconButton(
            onPressed: () async {
              List<SelectableItem<Patient>> lista = [];
              for (var i = 0; i < patients.length; i++) {
                var data =
                    await widget.suscrip!(patients[i].authInfo.uid, "paciente");
                lista.add(SelectableItem<Patient>(
                    data: patients[i],
                    title: patients[i].fullName +
                        " - " +
                        (data ? "Activo" : "inactivo")));
              }

              await showAdaptiveSheet(
                context: context,
                bottomSheetHeight: 0.8,
                body: SelectableItemTemplate<Patient>(
                  items: lista,
                  onSelected: updateSelectPaciente,
                  hintText: 'María Perez',
                ),
              );
            },
            icon: const Icon(Icons.person, color: AppColors.blueBackground),
          ),
        ),
        CustomDropdownFormField<dynamic>(
          'Tipo de servicio',
          onChanged: (value) {
            setState(() {
              especialidState = false;
            });
            updateService(value);
          },
          options: servicios,
          currentValue: selectedServiceType,
        ),
        !especialidState
            ? Container()
            : CustomDropdownFormField<dynamic>(
                'Especialidad',
                onChanged: onChangedSpecialization,
                options: especialidades,
              ),
        if (selectedServiceType == ServiceType.test)
          CustomDropdownFormField<MedicalTest>(
            'Prueba',
            onChanged: onChangedTest,
            options: tests,
            currentValue: selectedTest,
          ),
        CustomTextFormField(
          'Diagnóstico',
          controller: controller,
        ),
        CustomTextFormField(
          'Monto',
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          controller: amountController,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: selectedPatient1 == '' ? null : onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}

class UsuariosSet {
  final String title;
  final String id;
  UsuariosSet({required this.id, required this.title});
}
