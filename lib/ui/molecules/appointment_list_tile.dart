import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:medired/core/utils/responsive.dart';
import 'package:medired/features/authentication/domain/entities/patient.dart';
import 'package:medired/features/authentication/presentation/bloc/auth/auth_bloc.dart';
import 'package:medired/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:medired/features/points/presentation/bloc/points_bloc.dart';
import 'package:medired/features/single_appointment/presentation/bloc/single_appointment_bloc.dart';
import 'package:medired/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:medired/services/locator.dart';
import 'package:medired/ui/constants/app_colors.dart';
import 'package:medired/ui/organisms/appointment_form.dart';

class AppointmentListTile extends StatelessWidget {
  const AppointmentListTile({
    required this.serviceType,
    required this.serviceProviderName,
    required this.date,
    required this.status,
    required this.description,
    required this.appointmentID,
    required this.onAppointmentCancelled,
    required this.serviceId,
    required this.especialidadSelect,
    required this.fecha,
    required this.prestadorName,
    required this.id_appointment,
    this.cita = "",
    required this.id_prestador,
    required this.suscrip,
    super.key,
  });

  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _hourFormat = DateFormat.Hm();

  final String serviceType;
  final String serviceProviderName;
  final DateTime date;
  final Color status;
  final String description;
  final String serviceId;
  final String especialidadSelect;
  final String appointmentID;
  final String prestadorName;
  final String id_appointment;
  final String id_prestador;
  final String cita;
  final fecha;
  final Function(String) onAppointmentCancelled;
  final Function suscrip;

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

  void sendEmail(String id) async {
    List<dynamic> member =
        await getDocs('member', 'authInfo.uid', id.replaceAll('canceled', ''));

    final to = Uri.encodeComponent(member[0][0]['authInfo']['email']);
    final subject = Uri.encodeComponent('Medired Cita Cancelada');
    String emailHTML = """
                                <!DOCTYPE html>
                                <html lang="es">
                                <head>
                                  <meta charset="UTF-8">
                                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                  <title>Bienvenido a Medired</title>
                                  <style>
                                    body {
                                      font-family: Arial, sans-serif;
                                      background-color: #f4f4f4;
                                      margin: 0;
                                      padding: 0;
                                    }
                                    .container {
                                      max-width: 600px;
                                      margin: 20px auto;
                                      background-color: #ffffff;
                                      padding: 20px;
                                      border-radius: 10px;
                                      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                                    }
                                    h1 {
                                      color: #00a859;
                                    }
                                    p {
                                      color: #333333;
                                      line-height: 1.6;
                                    }
                                    .button {
                                      display: inline-block;
                                      background-color: #00a859;
                                      color: #ffffff;
                                      padding: 10px 20px;
                                      text-align: center;
                                      text-decoration: none;
                                      border-radius: 5px;
                                      margin-top: 20px;
                                      font-weight: bold;
                                    }
                                    .button:hover {
                                      background-color: #007d44;
                                    }
                                    .footer {
                                      text-align: center;
                                      margin-top: 20px;
                                      color: #777777;
                                      font-size: 12px;
                                    }
                                    .footer a {
                                      color: #00a859;
                                      text-decoration: none;
                                    }
                                  </style>
                                </head>
                                <body>

                                <div class="container">
                                  <h1>Medired Cita cancelada</h1>
                                  <p>Estimado/a ${member[0][0]["personalInfo"]["firstName"] + ' ' + member[0][0]["personalInfo"]["lastName"]},</p>
                                  <p>Espero que este mensaje le encuentre bien. Lamentamos informarle que hemos recibido la notificación de la cancelación de su cita programada en Medired.</p>
                                  
                                  <p>Entendemos que pueden surgir imprevistos y que a veces es necesario reprogramar. Si desea, estaremos encantados de ayudarle a fijar una nueva fecha y hora que se ajusten a su conveniencia.</p>

                                  <a href="https://medired-f442d.web.app/#/login" style="color:white" class="button">Acceder a mi cuenta</a>

                                  <p>¡Gracias por confiar en nosotros!</p>

                                  <p>Saludos cordiales,<br>
                                  El equipo de Medired</p>

                                </div>

                                </body>
                                </html>

                              """;
    final text = Uri.encodeComponent(emailHTML);

    final url = Uri.parse(
        'https://us-central1-medired-f442d.cloudfunctions.net/email?to=$to&subject=$subject&text=$text');

    final response = await http.get(url);

    if (response.statusCode == 200) {
    } else {}
  }

  void sendEmailEdit(String id, id_empresa, type, cita) async {
    List<dynamic> mycita =
        await getDocs('appointment', 'id', id.replaceAll('canceled', ''));

    List<dynamic> member = await getDocs('member', 'authInfo.uid',
        mycita[0][0]["appointmentInfo"]["patient"]["uid"]);
    List<dynamic> empresa = await getDocs('member', 'authInfo.uid', id_empresa);

    final to = Uri.encodeComponent(type == 1
        ? member[0][0]['authInfo']['email']
        : empresa[0][0]['authInfo']['email']);
    final subject = Uri.encodeComponent('Medired Cita Modificada');
    Timestamp date = mycita[0][0]["appointmentInfo"]["date"];
    DateTime dateTime = date.toDate();
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm a').format(dateTime);

    String emailHTML = """
                                <!DOCTYPE html>
                                <html lang="es">
                                <head>
                                  <meta charset="UTF-8">
                                  <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                  <title>Bienvenido a Medired</title>
                                  <style>
                                    body {
                                      font-family: Arial, sans-serif;
                                      background-color: #f4f4f4;
                                      margin: 0;
                                      padding: 0;
                                    }
                                    .container {
                                      max-width: 600px;
                                      margin: 20px auto;
                                      background-color: #ffffff;
                                      padding: 20px;
                                      border-radius: 10px;
                                      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                                    }
                                    h1 {
                                      color: #00a859;
                                    }
                                    p {
                                      color: #333333;
                                      line-height: 1.6;
                                    }
                                    .button {
                                      display: inline-block;
                                      background-color: #00a859;
                                      color: #ffffff;
                                      padding: 10px 20px;
                                      text-align: center;
                                      text-decoration: none;
                                      border-radius: 5px;
                                      margin-top: 20px;
                                      font-weight: bold;
                                    }
                                    .button:hover {
                                      background-color: #007d44;
                                    }
                                    .footer {
                                      text-align: center;
                                      margin-top: 20px;
                                      color: #777777;
                                      font-size: 12px;
                                    }
                                    .footer a {
                                      color: #00a859;
                                      text-decoration: none;
                                    }
                                  </style>
                                </head>
                                <body>

                                <div class="container">
                                  <h1>Medired Cita Editada</h1>
                                  <p>Estimado/a ${type == 1 ? member[0][0]["personalInfo"]["firstName"] + ' ' + member[0][0]["personalInfo"]["lastName"] : empresa[0][0]['companyInfo']['name']},</p>
                                  <p>Espero que este mensaje le encuentre bien. ${type == 1 ? "Su cita de " + cita + ", se ha modificado en Medired" : "Su cita de " + cita + ", para el paciente ${member[0][0]["personalInfo"]["firstName"] + ' ' + member[0][0]["personalInfo"]["lastName"]} se ha modificado en Medired"}.</p>
                                  <p><center><h2>Detalles</h2></center></p>
                                  <p>Prestador: ${mycita[0][0]["appointmentInfo"]["serviceProvider"]["firstName"]}</p>
                                  <p>Paciente: ${mycita[0][0]["appointmentInfo"]["patient"]["firstName"] + " " + mycita[0][0]["appointmentInfo"]["patient"]["lastName"]}</p>
                                  <p>Servicio: ${mycita[0][0]["medicalTest"]["id"]}</p>
                                  <p>Especialidad: ${mycita[0][0]["medicalTest"]["name"]}</p>
                                  <p>Hora: ${formattedDate}</p>
                                  <p>Observación: ${mycita[0][0]["appointmentInfo"]["description"].toString()}</p>
                                  <a href="https://medired-f442d.web.app/#/login" style="color:white" class="button">Acceder a mi cuenta</a>

                                  <p>¡Gracias por confiar en nosotros!</p>

                                  <p>Saludos cordiales,<br>
                                  El equipo de Medired</p>

                                </div>

                                </body>
                                </html>

                              """;
    final text = Uri.encodeComponent(emailHTML);

    final url = Uri.parse(
        'https://us-central1-medired-f442d.cloudfunctions.net/email?to=$to&subject=$subject&text=$text');

    final response = await http.get(url);

    if (response.statusCode == 200) {
    } else {}
  }

  Future<void> _cancelAppointment(BuildContext context) async {
    final url = Uri.parse(
        'https://us-central1-medired-f442d.cloudfunctions.net/deleteAppointmentandUpdateSubscription?appointmentId=$appointmentID');

    try {
      final response = await http.get(
        url,
        headers: {
          'x-api-key': 'dUx2_v_y8i3Veq3d2eMtEpUlFfHueJJvH3ojqCIOABA',
        },
      );

      if (response.statusCode == 200) {
        onAppointmentCancelled(appointmentID);
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cita cancelada con éxito')),
        );
        List<dynamic> appointment =
            await getDocs('appointment', 'id', appointmentID);
        sendEmail(appointment[0][0]['appointmentInfo']['patient']['uid']);
      } else {
        throw Exception('Failed to cancel appointment');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cancelar la cita: $e')),
      );
    }
  }

  void _showDescriptionDialog(
    BuildContext context,
  ) {
    final now = DateTime.now();
    final difference = date.difference(now).inMinutes;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Descripción de la cita'),
          content: Text(description),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Editar',
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                showAdaptiveSheet(
                  context: context,
                  body: MultiBlocProvider(
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
                          id_prestador: id_prestador,
                          cita: cita,
                          edit: sendEmailEdit,
                          servicioSelected: serviceId,
                          especialidadSelected: especialidadSelect,
                          fecha: fecha,
                          comentario: description,
                          prestadorSelected: prestadorName,
                          type: 'actualizar',
                          cancel: _cancelAppointment,
                          contextCancel: context,
                          id_appointment: id_appointment,
                        )),
                  ),
                  bottomSheetHeight: 0.8,
                );
              },
            ),
           // if (difference > 60)
              TextButton(
                onPressed: () => _cancelAppointment(context),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                child: const Text('Cancelar cita'),
              ),
          ],
        );
      },
    );
  }

  editar() async {}
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: SizedBox(
          width: 70,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(_dateFormat.format(date)),
              Text(
                  '${_hourFormat.format(date)}-${_hourFormat.format(date.add(const Duration(minutes: 30)))}'),
            ],
          ),
        ),
        title: Text(serviceProviderName),
        subtitle: Text(serviceType),
        trailing: Align(
          widthFactor: 1,
          heightFactor: 1,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: status,
            ),
            width: 24,
            height: 24,
          ),
        ),
        onTap: () => _showDescriptionDialog(context),
      ),
    );
  }
}
