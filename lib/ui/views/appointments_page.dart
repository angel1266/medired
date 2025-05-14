import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core_web/firebase_core_web_interop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/core/router/router.dart';
import 'package:medired/core/utils/responsive.dart';
import 'package:medired/core/value_objects/appointment_status.dart';
import 'package:medired/core/value_objects/medical_specialization.dart';
import 'package:medired/core/value_objects/service_type.dart';
import 'package:medired/core/value_objects/subscription_type.dart';
import 'package:medired/features/appointments/appointments_export.dart';
import 'package:medired/features/authentication/domain/entities/patient.dart';
import 'package:medired/features/authentication/domain/entities/service_provider.dart';
import 'package:medired/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:medired/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:medired/features/points/domain/usecases/save_points.dart';
import 'package:medired/features/points/presentation/bloc/points_bloc.dart';
import 'package:medired/features/single_appointment/domain/entities/test_appointment.dart';
import 'package:medired/features/single_appointment/presentation/bloc/single_appointment_bloc.dart';
import 'package:medired/features/subscription/domain/usecases/get_active_subscriptions.dart';
import 'package:medired/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:medired/services/locator.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/molecules/appointment_list_tile.dart';
import 'package:medired/ui/organisms/appointment_form.dart';
import 'package:medired/ui/organisms/points_form.dart';
import 'package:medired/ui/shared/calendar.dart';
import 'package:medired/ui/template/appointments_template.dart';
import 'package:medired/ui/views/create_points_page.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:universal_html/html.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  bool btnAdd = false;

  Future<bool> CheckSubcription(id, tipo) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("subscription")
        .where("uid", isEqualTo: id)
        .get();

    List<QueryDocumentSnapshot> documentos = querySnapshot.docs;
    //documentos.sort((a, b) => a['nombre'].compareTo(b['nombre']));

    List<dynamic> list = [];
    bool suc = false;

    if (tipo != "paciente") {
      suc = true;
    }

    if (tipo == "paciente") {
      for (var doc in documentos) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Timestamp timestamp = data['setDate'];
        DateTime fechaDesdeFirebase = timestamp.toDate();
        DateTime fechaActual = DateTime.now();
        if (fechaDesdeFirebase.isAfter(fechaActual)) {
          suc = true;
        } else {
          suc = false;
        }
      }
    }

    setState(() {
      btnAdd = suc;
    });
    return suc;
  }

  @override
  void initState() {
    super.initState();
    var state = context.read<AuthBloc>().state;
    if (state is AuthenticatedState<Patient>) {
      context
          .read<AppointmentsBloc>()
          .add(GetUpcomingPatientAppointments(uid: state.user.authInfo.uid!));
    } else if (state is AuthenticatedState<ServiceProvider>) {
      context.read<AppointmentsBloc>().add(
          GetUpcomingServiceProviderAppointments(
              uid: state.user.authInfo.uid!));
    }
  }

  void showMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Suscripción Vencida'),
          content: Text(
              'No puedes crear una cita porque su suscripción está vencida.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppointmentsBloc, AppointmentsState>(
          listener: _appointmentsListener,
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: _authListener,
        ),
      ],
      child: BlocBuilder<AppointmentsBloc, AppointmentsState>(
        builder: (context, state) {
          if (state is LoadingAppointments) {
            return const Center(child: CircularProgressIndicator());
          }
          return AppointmentsTemplate(
            backgroundColor: AppColors.lightBackground,
            appointments: state is SuccessUpcomingAppointments
                // TODO: Fix `ServiceProviderName`
                ? state.appointments
                    .map((e) => AppointmentListTile(
                          suscrip: CheckSubcription,
                          cita: e.medTestName!.id,
                          id_prestador: e.appointmentInfo.serviceProvider.uid,
                          id_appointment: e.id.toString(),
                          prestadorName:
                              e.appointmentInfo.serviceProvider.firstName,
                          serviceId: e.medTestName!.id.toString(),
                          especialidadSelect: e.medTestName!.name.toString(),
                          fecha: e.appointmentInfo.date,
                          serviceType: e.appointmentInfo.serviceType !=
                                  ServiceType.test
                              ? 'Consulta médica: ${medicalSpecializationToString[MedicalSpecialization.values.firstWhere((i) => i.index == e.medSpe)]}'
                              : e.medTestName!.name
                          /*serviceTypeToString[e is TestAppointment
                            ? ServiceType.test
                            : ServiceType.medicalConsultation]!*/
                          ,
                          serviceProviderName:
                              '${e.appointmentInfo.serviceProvider.firstName} ${e.appointmentInfo.serviceProvider.lastName} - ${e.appointmentInfo.patient.firstName} ${e.appointmentInfo.patient.lastName}',
                          date: e.appointmentInfo.date,
                          status: appointmentStatusToColour[
                              e.appointmentInfo.status]!,
                          description: e.appointmentInfo.description,
                          appointmentID: e.id,
                          onAppointmentCancelled: (String appointmentId) {
                            context.read<AppointmentsBloc>().add(
                                  RemoveAppointment(
                                      appointmentId: appointmentId),
                                );
                          },
                        ))
                    .toList()
                : [],
            source: state is SuccessUpcomingAppointments
                ? state.appointments
                    .map((e) => Meeting(
                        serviceTypeToString[e is TestAppointment
                            ? ServiceType.test
                            : ServiceType.medicalConsultation]!,
                        e.appointmentInfo.date,
                        e.appointmentInfo.date.add(const Duration(minutes: 30)),
                        appointmentStatusToColour[e.appointmentInfo.status]!,
                        false))
                    .toList()
                : [],
            floatingActionButton:
                BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              CheckSubcription(
                  (state is AuthenticatedState<Patient>
                      ?  state.user.authInfo.uid
                      : ""),
                  (state is AuthenticatedState<Patient>
                      ?  state.user.memberInfo.memberType == "2" ? "prestador" : "paciente"
                      : "Paciente"));

              return state is AuthenticatedState<Patient> &&
                          state.user.memberInfo.subscriptionType !=
                              SubscriptionType.none &&
                          state.user.points >= 5 ||
                      state is AuthenticatedState<ServiceProvider>
                  ? _fab(context, state)
                  : const SizedBox.shrink();
            }),
          );
        },
      ),
    );
  }

  Container _fab(BuildContext context, AuthState state) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: FloatingActionButton.extended(
        onPressed: () => !btnAdd
            ? showMessage(context)
            : showAdaptiveSheet(
                context: context,
                body: state is AuthenticatedState<Patient>
                    ? MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => SingleAppointmentBloc(
                              sl(),
                              sl(),
                              sl(),
                            )..add(const UpdateServiceType(serviceType: null)),
                          ),
                          BlocProvider(
                            create: (context) => SubscriptionBloc(
                              sl(),
                              sl(),
                              sl(),
                              sl(),
                              sl(),
                              sl(),
                              sl(),
                            ),
                          ),
                          BlocProvider(
                            create: (context) => PaymentBloc(
                              sl(),
                              sl(),
                              sl(),
                              sl(),
                              sl(),
                              sl(),
                              sl(),
                              sl(),
                              sl(),
                            ),
                          ),
                        ],
                        child: Container(
                            color: AppColors.blueBackground,
                            child: AppointmentForm(
                              cita: "",
                              id_prestador: "",
                              edit: () {},
                              cancel: () {},
                              contextCancel: context,
                              id_appointment: '',
                            )),
                      )
                    : MultiBlocProvider(
                        providers: [
                            BlocProvider(
                              create: (context) => PointsBloc(
                                sl(),
                                sl(),
                              )..add(GetActiveSubscriptions()),
                            ),
                            BlocProvider(
                              create: (context) => SingleAppointmentBloc(
                                sl(),
                                sl(),
                                sl(),
                              ),
                            ),
                          ],
                        child: Container(
                            color: AppColors.blueBackground,
                            child: CreatePointsPage(
                              suscrip: CheckSubcription,
                            ))),
                bottomSheetHeight: 0.8,
              ),
        label: const Text('Agregar servicio',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 6, 54, 94),
        foregroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  // Container _fab(BuildContext context, AuthState state) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(25),
  //     ),
  //     child: FloatingActionButton.extended(
  //       onPressed: () => showAdaptiveSheet(
  //         context: context,
  //         body: state is AuthenticatedState<Patient>
  //             ? MultiBlocProvider(
  //                 providers: [
  //                   BlocProvider(
  //                     create: (context) => SingleAppointmentBloc(
  //                       sl(),
  //                       sl(),
  //                       sl(),
  //                     )..add(const UpdateServiceType(serviceType: null)),
  //                   ),
  //                   BlocProvider(
  //                     create: (context) => SubscriptionBloc(
  //                       sl(),
  //                       sl(),
  //                       sl(),
  //                       sl(),
  //                       sl(),
  //                       sl(),
  //                       sl(),
  //                     ),
  //                   ),
  //                   BlocProvider(
  //                     create: (context) => PaymentBloc(
  //                       sl(),
  //                       sl(),
  //                       sl(),
  //                       sl(),
  //                       sl(),
  //                       sl(),
  //                       sl(),
  //                       sl(),
  //                       sl(),
  //                     ),
  //                   ),
  //                 ],
  //                 child: Container(
  //                     color: AppColors.blueBackground,
  //                     child: AppointmentForm(
  //                       cancel: () {},
  //                       contextCancel: context,
  //                       id_appointment: '',
  //                     )),
  //               )
  //             : MultiBlocProvider(
  //                 providers: [
  //                   BlocProvider(
  //                     create: (context) => PointsBloc(
  //                       sl(),
  //                       sl(),
  //                     )..add(GetActiveSubscriptions()),
  //                   ),
  //                   BlocProvider(
  //                     create: (context) => SingleAppointmentBloc(
  //                       sl(),
  //                       sl(),
  //                       sl(),
  //                     ),
  //                   ),
  //                 ],
  //                 child: Container(),
  //               ),
  //         bottomSheetHeight: 0.8,
  //       ),
  //       label: const Text('Agregar servicio',
  //           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  //       icon: const Icon(Icons.add, color: Colors.white),
  //       backgroundColor: const Color.fromARGB(255, 6, 54, 94),
  //       foregroundColor: Theme.of(context).colorScheme.secondary,
  //     ),
  //   );
  // }

  void _appointmentsListener(BuildContext context, AppointmentsState state) {
    if (state is ErrorAppointmentState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error)),
      );
    }
  }

  void _authListener(BuildContext context, AuthState state) {
    if (state is AuthenticatedState<Patient>) {
      context
          .read<AppointmentsBloc>()
          .add(GetUpcomingPatientAppointments(uid: state.user.authInfo.uid!));
    } else if (state is AuthenticatedState<ServiceProvider>) {
      context.read<AppointmentsBloc>().add(
          GetUpcomingServiceProviderAppointments(
              uid: state.user.authInfo.uid!));
    }
  }
}
