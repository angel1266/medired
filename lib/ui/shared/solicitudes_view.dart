import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medired/core/value_objects/titulos.dart';
import 'package:medired/core/value_objects/value_objects_export.dart';
import 'package:medired/features/appointments/presentation/bloc/appointments_bloc.dart';
import 'package:medired/features/single_appointment/domain/entities/appointed_patient.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment.dart';
import 'package:medired/services/locator.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/constants/ui_helper.dart';
import 'package:medired/ui/shared/custom_flat_button.dart';
import 'package:medired/ui/shared/solicitud_paciente_widget.dart';
import 'package:medired/ui/shared/targeta_de_solicitud.dart';

class Solicitudesview extends StatefulWidget {
  const Solicitudesview({super.key});

  @override
  State<Solicitudesview> createState() => _SolicitudesviewState();
}

class _SolicitudesviewState extends State<Solicitudesview> {
  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  // solcitude de citas
  final AppointmentsBloc appointmentsBloc = sl<AppointmentsBloc>();

  @override
  void initState() {
    super.initState();
    appointmentsBloc.add(const GetPendingAppointments());
  }

  @override
  Widget build(BuildContext context) {
    bool device = context.screenType() == ScreenType.desktop;
    return BlocProvider(
      create: (context) => appointmentsBloc,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(MediaQuery.of(context).size.width * 0.09),
          topRight: Radius.circular(MediaQuery.of(context).size.width * 0.09),
          bottomLeft: const Radius.circular(0.0),
          bottomRight: const Radius.circular(0.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.height * 0.93),
          color: AppColors.blueBackground,
          child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Text(
                  'Tabla de Solicitudes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: device
                          ? MediaQuery.of(context).size.width * 0.06
                          : MediaQuery.of(context).size.width * 0.08,
                      fontFamily: 'Outfit',
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 30,
                ),
                MediaQuery.of(context).size.width > 450
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05),
                        child: Row(
                          children: titulosTypeToString[TitulosType.titulo1]!
                              .map((titulo) {
                            return SizedBox(
                              width: device
                                  ? (((MediaQuery.of(context).size.width) *
                                          0.84)) /
                                      4
                                  : (((MediaQuery.of(context).size.width) *
                                          0.74)) /
                                      4,
                              child: Center(
                                child: Text(
                                  titulo,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Outfit',
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.025,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    : Container(),
                solicitudeswidget(context),
                const SizedBox(
                  height: 30,
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }

  Widget solicitudeswidget(BuildContext context) {
    //  bool device = context.screenType() == ScreenType.desktop;

    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(MediaQuery.of(context).size.width * 0.01))),
          child: BlocBuilder<AppointmentsBloc, AppointmentsState>(
            bloc: appointmentsBloc,
            builder: (context, state) {
              if (state is SuccessPendingAppointments) {
                if (state.appointments.isEmpty) {
                  return const Center(
                    child: Text('No tienes citas pendientes por aprobar'),
                  );
                }
                return ListView.builder(
                  itemCount: state.appointments.length,
                  itemBuilder: (BuildContext context, int index) {
                    int bordertype;
                    if (index == 0) {
                      bordertype = 0;
                    } else if (index == state.appointments.length - 1) {
                      bordertype = 2;
                    } else {
                      bordertype = 1;
                    }
                    Appointment appointment = state.appointments[index];
                    // Crea una tarjeta (Targetacitas) para cada solicitud
                    TimeOfDay time = TimeOfDay.fromDateTime(
                        appointment.appointmentInfo.date);
                    return Targetasolicitudes(
                      bordertype: bordertype,
                      paciente: appointment.appointmentInfo.patient.firstName,
                      motivo: 'Enfermedad',
                      fecha:
                          _dateFormat.format(appointment.appointmentInfo.date),
                      hora: '${time.hour}:${time.minute}',
                      pacienteontop: () {
                        // locator<NavigationService>()
                        //     .navigateTo(RouteGenerator.solicitudpacientePage);
                        const Solicitudpaciente();
                        // print('Clic en la tarjeta ${index + 1}');
                      },
                      ontopmenssage: () {
                        // Acción al hacer clic en el mensajje
                        // Puedes agregar aquí cualquier acción personalizada
                        //  print('Clic en la tarjeta ${index + 1}');
                      },
                      ontopclose: () {
                        dialogdelete(context,
                            appointment.appointmentInfo.patient, 'Enfermedad');
                        // Acción al hacer clic en la x de eleimianar
                        // Puedes agregar aquí cualquier acción personalizada
                        // print('Clic en la tarjeta ${index + 1}');
                      },
                    );
                  },
                );
              } else if (state is LoadingPendingAppointments) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ));
  }

  Future<dynamic> dialogdelete(
      BuildContext context, AppointedPatient patient, String motivo) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          backgroundColor: const Color.fromARGB(255, 94, 128, 206),
          //   title: Text('Confirmación'),
          content: Text(
            '¿Estás seguro de que deseas declina a ${patient.firstName}-$motivo?',
            style: const TextStyle(
                color: Colors.white,
                letterSpacing: 1,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            CustomFlatButton(
              text: 'Cancelar',
              onPressed: () => Navigator.of(context).pop(),
              buttonColor: Colors.white,
              textColor: AppColors.blueBackground,
            ),
            CustomFlatButton(
              text: 'Declinar',
              onPressed: () =>
                  context.read<AppointmentsBloc>().add(UpdateAppointmentStatus(
                        id: patient.uid,
                        status: AppointmentStatus.unauthorized,
                      )),
              buttonColor: AppColors.blueBackground,
              textColor: Colors.white,
            ),
          ],
        );
      },
    );
  }
}
