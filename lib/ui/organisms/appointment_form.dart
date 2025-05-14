import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medired/core/extensions/converter.dart';
import 'package:medired/core/router/router.dart';
import 'package:medired/core/value_objects/appointment_status.dart';
import 'package:medired/core/value_objects/medical_specialization.dart';
import 'package:medired/core/value_objects/medical_test_type.dart';
import 'package:medired/core/value_objects/service_type.dart';
import 'package:medired/features/appointments/data/models/medical_test_model.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/authentication/data/models/authentication_model_export.dart';
import 'package:medired/features/authentication/data/models/service_asig_model.dart';
import 'package:medired/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment_info.dart';
import 'package:medired/features/single_appointment/presentation/bloc/single_appointment_bloc.dart';
import 'package:medired/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/custom_dropdown_field.dart';
import 'package:medired/ui/molecules/custom_text_form_field.dart';
import 'package:medired/ui/organisms/appointment_update.dart';
import 'package:http/http.dart' as http;

class AppointmentForm extends StatefulWidget {
  const AppointmentForm(
      {super.key,
      this.especialidadSelected = '',
      this.servicioSelected = '',
      this.fecha = '',
      this.comentario = '',
      this.prestadorSelected = '',
      this.type = 'create',
      required this.cancel,
      required this.edit,
      required this.contextCancel,
      required this.id_prestador,
      required this.cita,
      this.id_appointment = ''});

  final String servicioSelected;
  final String especialidadSelected;
  final fecha;
  final comentario;
  final prestadorSelected;
  final type;
  final Function cancel;
  final Function edit;
  final BuildContext contextCancel;
  final id_appointment;
  final String id_prestador;
  final String cita;
  @override
  State<AppointmentForm> createState() => _AppointmentFormState(
      fecha: fecha,
      servicioSelected: servicioSelected,
      especialidadSelected: especialidadSelected,
      comentario: comentario,
      prestadorSelected: prestadorSelected,
      type: type);
}

class _AppointmentFormState extends State<AppointmentForm> {
  _AppointmentFormState(
      {this.servicioSelected = '',
      this.especialidadSelected = '',
      this.fecha = '',
      this.comentario = '',
      this.prestadorSelected = '',
      this.type = 'create'});

  final TextEditingController descripcionController = TextEditingController();
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  final comentario;
  final String servicioSelected;
  final String especialidadSelected;
  final fecha;
  final prestadorSelected;
  final type;

  String servicioSelected2 = '';
  String especialidadSelected2 = '';
  String selectPrestador = '';
  String selectEspecialidad = '';
  String SelectServicio = '';
  List<MedicalTest> tests = [];
  List<ServicioAsig> listServicioAsig = [];
  List<Servicio> listService = [];

  Map<dynamic, String> servicios = {};
  Map<dynamic, String> especialidades = {};
  List<ServiceProviderModel> prestadoresService = [];
  Map<String, dynamic> prestadores = {};

  bool isImage = false;

  DateTime date = DateTime.now();

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

      if (servicioSelected != '') {
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
      }
      setState(() {});
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
  }

  Future<void> _fetchServiciosPrestador(servicio) async {
    try {
      List<dynamic> fetchedData = await getDocs('espescialidades_asignadas',
          'id_servicio', servicio == "" ? servicioSelected2 : servicio);

      print("tu servicio esss " + fetchedData.toString());

      for (var i = 0; i < fetchedData.length; i++) {
        List<Especialidades> listEspecialidades = [];
        fetchedData[i][0]['especialidades'].forEach((key, valor) {
          listEspecialidades.add(Especialidades(id: key, name: valor[0]));
          print(valor.toString());
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

  Future<void> _fetchPrestador() async {
    try {
      var idService = listService
              .firstWhere(
                  (element) => element.name == SelectServicio.toString())
              .id ??
          "";
      _fetchServiciosPrestador(idService);
      List<dynamic> fetchedData =
          await getDocsProvider('member', 'memberInfo.memberType', 2);

      setState(() {
        List<Map<String, dynamic>> prestadoresList = [];
        for (var e = 0; e < fetchedData.length; e++) {
          Map<String, dynamic> map = fetchedData[e][0];
          for (var i = 0; i < map['medicalTests'].length; i++) {
            tests.add(MedicalTestModel.fromJson(map['medicalTests'][i]));
          }

          List<ServicioAsig> liSa = listServicioAsig
              .where((element) => element.id_servicio.toString() == idService)
              .where((element) =>
                  element.id_prestador.toString() == fetchedData[e][1])
              .toList();

          List<Especialidades> liEs = liSa.length > 0
              ? liSa[0]
                  .lista
                  .where((element) => element.name == selectEspecialidad)
                  .toList()
              : [];

          if (liEs.length > 0) {
            prestadoresList
                .add({map['companyInfo']['name']: map['companyInfo']['name']});

            prestadoresService.add(ServiceProviderModel.fromJson(map));
          }
        }
        for (var i = 0; i < prestadoresList.length; i++) {
          prestadores.addAll(prestadoresList[i]);
        }

        if (especialidadSelected != '') {
          selectPrestador = prestadorSelected;
          context.read<SingleAppointmentBloc>().add(UpdateTestOption(tests,
              test: MedicalTest(
                  id: SelectServicio,
                  name: especialidadSelected,
                  category: MedicalTestType.imaging,
                  description: 'description',
                  durationDescription: '0')));
        }
      });
    } catch (e) {
      debugPrint('Error fetching prestador: $e');
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

      if (especialidadSelected != '') {
        selectEspecialidad = especialidadSelected;
        especialidadSelected2 = especialidadSelected;
        _fetchPrestador();

        /*context.read<SingleAppointmentBloc>().add(UpdateTestOption(state.tests,
            test: new MedicalTest(
                id: SelectServicio,
                name: especialidadSelected,
                category: MedicalTestType.imaging,
                description: "description",
                durationDescription: "0")));*/
      }
      setState(() {});
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

  @override
  void initState() {
    _fetchServicios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return type != 'create'
        ? SingleChildScrollView(
            child: AppointmentUpdateForm(
              id_prestador: widget.id_prestador,
              cita: widget.cita,
              edit: widget.edit,
              id: widget.id_appointment,
              fecha: fecha,
              comentario: comentario,
              selectServicio: servicioSelected,
              especialidadSelect: especialidadSelected,
              prestadorSelect: prestadorSelected,
            ),
          )
        : SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      BlocBuilder<SingleAppointmentBloc,
                          SingleAppointmentState>(
                        buildWhen: (previous, current) =>
                            current is SuccessUpdateServiceType,
                        builder: (context, state) {
                          if (state is SuccessUpdateServiceType) {
                            return CustomDropdownFormField<dynamic>(
                              'Tipo de servicio',
                              onChanged: (newValue) {
                                prestadores = {};
                                SelectServicio = servicios[newValue]!;
                                _fetchEspecialidades(newValue!);

                                newValue == ServiceType.medicalConsultation
                                    ? context
                                        .read<SingleAppointmentBloc>()
                                        .add(const GetSpecializations())
                                    : context
                                        .read<SingleAppointmentBloc>()
                                        .add(const GetTests());
                              },
                              options: servicios,
                              currentValue:
                                  servicioSelected != '' && servicios.isNotEmpty
                                      ? servicioSelected2
                                      : state.serviceType,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      BlocConsumer<SingleAppointmentBloc,
                          SingleAppointmentState>(
                        listener: _typeListener,
                        listenWhen: (previous, current) =>
                            current is SuccessGetSpecializations ||
                            current is SuccessGetTests,
                        buildWhen: (previous, current) =>
                            current is SuccessGetSpecializations ||
                            current is SuccessGetTests,
                        builder: (context, state) {
                          if (state is SuccessGetSpecializations) {
                            return CustomDropdownFormField<dynamic>(
                              'Especialidad',
                              onChanged: (newValue) {
                                selectEspecialidad = newValue!;
                                _fetchPrestador();
                              },
                              options: especialidades,
                              currentValue: especialidadSelected != '' &&
                                      especialidades.isNotEmpty
                                  ? especialidadSelected2
                                  : state is SuccessUpdateSpecializationOption
                                      ? state.specialization
                                      : null,
                            );
                          } else if (state is SuccessGetTests) {
                            return CustomDropdownFormField<dynamic>(
                              'Servicios',
                              onChanged: (newValue) {
                                selectEspecialidad = newValue!;
                                _fetchPrestador();

                                context.read<SingleAppointmentBloc>().add(
                                    UpdateTestOption(state.tests,
                                        test: MedicalTest(
                                            id: SelectServicio,
                                            name: newValue,
                                            category: MedicalTestType.imaging,
                                            description: 'description',
                                            durationDescription: '0')));
                              },
                              options: especialidades,
                              currentValue: especialidadSelected != '' &&
                                      especialidades.isNotEmpty
                                  ? especialidadSelected2
                                  : state is SuccessUpdateMedicalTestOption
                                      ? state.medicalTest.name
                                      : null,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      BlocBuilder<SingleAppointmentBloc,
                          SingleAppointmentState>(
                        buildWhen: (previous, current) =>
                            current is SuccessGetSpecializationProviders ||
                            current is SuccessGetTestProviders,
                        builder: (context, state) {
                          if (state is SuccessGetSpecializationProviders) {
                            if (selectPrestador != '' ||
                                (prestadorSelected != '' &&
                                    prestadores.isNotEmpty)) {
                              context
                                  .read<SingleAppointmentBloc>()
                                  .add(UpdateSpecializationProvider(
                                    state.serviceProviders,
                                    serviceProvider: prestadoresService
                                        .firstWhere((element) =>
                                            element.companyInfo.name ==
                                            selectPrestador),
                                    serviceType: state.serviceType,
                                    medicalSpecialization:
                                        state.medicalSpecialization,
                                  ));
                            }
                            return CustomDropdownFormField<dynamic>(
                              'Proveedor de servicio',
                              currentValue: prestadorSelected != '' &&
                                      prestadores.isNotEmpty
                                  ? prestadorSelected
                                  : null,
                              onChanged: (newValue) {
                                context
                                    .read<SingleAppointmentBloc>()
                                    .add(UpdateSpecializationProvider(
                                      state.serviceProviders,
                                      serviceProvider: prestadoresService
                                          .firstWhere((element) =>
                                              element.companyInfo.name ==
                                              newValue),
                                      serviceType: state.serviceType,
                                      medicalSpecialization:
                                          state.medicalSpecialization,
                                    ));
                                selectPrestador = newValue;
                                setState(() {});
                              },
                              options: prestadores,
                            );
                          }
                          if (state is SuccessGetTestProviders) {
                            if (selectPrestador != '' ||
                                (prestadorSelected != '' &&
                                    prestadores.isNotEmpty)) {
                              context
                                  .read<SingleAppointmentBloc>()
                                  .add(UpdateTestProvider(
                                    state.serviceProviders,
                                    serviceProvider: prestadoresService
                                        .firstWhere((element) =>
                                            element.companyInfo.name ==
                                            selectPrestador),
                                    serviceType: state.serviceType,
                                    medicalTest: state.medicalTest,
                                  ));
                            }
                            return CustomDropdownFormField<dynamic>(
                              'Proveedor de servicio',
                              currentValue: prestadorSelected != '' &&
                                      prestadores.isNotEmpty
                                  ? prestadorSelected
                                  : null,
                              onChanged: (newValue) {
                                context
                                    .read<SingleAppointmentBloc>()
                                    .add(UpdateTestProvider(
                                      state.serviceProviders,
                                      serviceProvider: prestadoresService
                                          .firstWhere((element) =>
                                              element.companyInfo.name ==
                                              newValue),
                                      serviceType: state.serviceType,
                                      medicalTest: state.medicalTest,
                                    ));
                                selectPrestador = newValue;
                                setState(() {});
                              },
                              options: prestadores,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      CustomTextFormField(
                        'Fecha',
                        hintText: '',
                        controller: TextEditingController(
                            text: type == 'create'
                                ? _dateFormat.format(date)
                                : _dateFormat.format(fecha)),
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
                        controller: TextEditingController(
                            text:
                                _timeFormat.format(fecha != '' ? fecha : date)),
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
                    ],
                  ),
                ),
                CustomTextFormField(
                  'Descripción',
                  controller: comentario != ''
                      ? TextEditingController(text: comentario)
                      : descripcionController,
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: BlocListener<SubscriptionBloc, SubscriptionState>(
                        listener: _subscriptionListener,
                        child: BlocConsumer<SingleAppointmentBloc,
                            SingleAppointmentState>(
                          listener: _appointmentListener,
                          builder: (context, state) {
                            return _button(
                                context,
                                state is SuccessUpdateSpecializationProvider ||
                                        state is SuccessUpdateTestProvider
                                    ? () async {
                                        Patient patient = (context
                                                    .read<AuthBloc>()
                                                    .state
                                                as AuthenticatedState<Patient>)
                                            .user;
                                        context
                                            .read<SubscriptionBloc>()
                                            .add(GetSubscription(
                                              uid: patient.authInfo.uid!,
                                            ));

                                        widget.cancel(widget.contextCancel);
                                      }
                                    : null);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancelar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
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

  void _onTimePressed(BuildContext context) {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (!context.mounted) return;
      if (value != null) {
        setState(() {
          date = date.add(Duration(hours: value.hour, minutes: value.minute));
        });
      }
    });
  }

  void _typeListener(BuildContext context, SingleAppointmentState state) {
    if (state is SuccessUpdateMedicalTestOption) {
      if (state is SuccessUpdateImageTestOption) {
        setState(() {
          isImage = true;
        });
      }
      context
          .read<SingleAppointmentBloc>()
          .add(GetTestProviders(test: state.medicalTest));
    } else if (state is SuccessUpdateSpecializationOption) {
      context.read<SingleAppointmentBloc>().add(
          GetSpecializationProviders(specialization: state.specialization));
    }
  }

  void _subscriptionListener(BuildContext context, SubscriptionState state) {
    if (state is SuccessGetSubscription) {
      var appointmentState = context.read<SingleAppointmentBloc>().state;
      var authState = context.read<AuthBloc>().state;
      Patient patient = (authState as AuthenticatedState<Patient>).user;
      if (appointmentState is SuccessUpdateSpecializationProvider) {
        context.read<SubscriptionBloc>().add(ReduceConsultation(
              subscription: state.subscription,
              medicalSpecialization: appointmentState.medicalSpecialization,
              patient: patient,
              serviceType: appointmentState.serviceType,
              serviceProvider: appointmentState.serviceProvider,
            ));
      } else if (appointmentState is SuccessUpdateTestProvider) {
        if (isImage) {
          context.read<SubscriptionBloc>().add(ReduceImage(
                subscription: state.subscription,
                medicalTest: appointmentState.medicalTest,
                patient: patient,
                serviceType: appointmentState.serviceType,
                serviceProvider: appointmentState.serviceProvider,
              ));
        } else {
          context.read<SubscriptionBloc>().add(ReduceTest(
                subscription: state.subscription,
                medicalTest: appointmentState.medicalTest,
                patient: patient,
                serviceType: appointmentState.serviceType,
                serviceProvider: appointmentState.serviceProvider,
              ));
        }
      }
    } else if (state is SuccessReduceConsultation) {
      context.read<SingleAppointmentBloc>().add(AddConsultationAppointment(
            medicalSpecialization: state.medicalSpecialization,
            appointmentInfo: AppointmentInfo(
              serviceProvider:
                  state.serviceProvider.toAppointedServiceProvider(),
              serviceType: state.serviceType,
              patient: state.patient.toAppointedPatient(),
              date: date,
              description: descripcionController.text,
              status: AppointmentStatus.authorized,
            ),
          ));
      var emailBody =
          'Nueva cita recibida de ${state.patient.personalInfo.lastName} \nCédula: ${state.patient.personalInfo.documents[0].value} \nTipo de Especialidad: $selectEspecialidad \nServicio: $SelectServicio';
      context.read<PaymentBloc>().add(SendEmail(
          to: state.serviceProvider.authInfo.email ?? '',
          subject: 'Nueva cita recibida',
          body: emailBody));

      context.read<PaymentBloc>().add(SendEmail(
          to: state.patient.authInfo.email ?? '',
          subject: 'Nueva cita recibida',
          body: emailBody));
    } else if (state is SuccessReduceTest) {
      context.read<SingleAppointmentBloc>().add(AddTestAppointment(
            medicalTest: state.medicalTest,
            appointmentInfo: AppointmentInfo(
              serviceProvider:
                  state.serviceProvider.toAppointedServiceProvider(),
              serviceType: state.serviceType,
              patient: state.patient.toAppointedPatient(),
              date: date,
              description: descripcionController.text,
              status: AppointmentStatus.authorized,
            ),
          ));

      var emailBody =
          'Nueva cita recibida de ${state.patient.personalInfo.lastName} \nCédula: ${state.patient.personalInfo.documents[0].value} \nTipo de Especialidad: $selectEspecialidad \nServicio: $SelectServicio';
      sendEmail(state.serviceProvider.authInfo.email ?? '', emailBody);
      emailBody =
          'Nueva cita recibida de ${state.patient.personalInfo.lastName} \nCédula: ${state.patient.personalInfo.documents[0].value} \nTipo de Especialidad: $selectEspecialidad \nServicio: $SelectServicio. \n \n La cita es opcional para este Prestador de Servicios de Salud, dada la atencion por orden de llegada. Si tiene alguna duda llamar a ${state.serviceProvider.companyInfo.phoneNumber[0].phoneNumber.toString()}';

      sendEmail(state.patient.authInfo.email ?? '', emailBody);
    } else if (state is ErrorSubscriptionState) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

  void _appointmentListener(
      BuildContext context, SingleAppointmentState state) {
    if (state is SuccessAddConsultationAppointment ||
        state is SuccessAddTestAppointment) {
      router.pop();
    } else if (state is ErrorSingleAppointment) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.message)));
    }
  }

  void sendEmail(email, body) async {
    final to = Uri.encodeComponent(email);
    final subject = Uri.encodeComponent('Medired Nueva Cita');

    final text = Uri.encodeComponent(body);

    final url = Uri.parse(
        'https://us-central1-medired-f442d.cloudfunctions.net/email?to=$to&subject=$subject&text=$text');

    final response = await http.get(url);

    if (response.statusCode == 200) {
    } else {}
  }

  Widget _button(BuildContext context, Function()? onPressed) {
    return ElevatedButton(
      style:
          ElevatedButton.styleFrom(backgroundColor: AppColors.greenBackground),
      onPressed: onPressed,
      child: Text(
        type == 'create' ? 'Agendar' : 'Actualizar Cita',
        style: Theme.of(context)
            .textTheme
            .labelLarge!
            .copyWith(color: Colors.white),
      ),
    );
  }
}

