import 'package:flutter/material.dart';
import 'package:medired/ui/organisms/appointment_form.dart';
import 'package:medired/ui/template/create_appointment_template.dart';

class CreateAppointmentPage extends StatefulWidget {
  const CreateAppointmentPage({super.key});

  @override
  State<CreateAppointmentPage> createState() => _CreateAppointmentPageState();
}

class _CreateAppointmentPageState extends State<CreateAppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return CreateAppointmentTemplate(
      left: SingleChildScrollView(
          child: AppointmentForm(
            cita: "",
            id_prestador: "",
        edit: () {},
        contextCancel: context,
        cancel: () {},
        id_appointment: '',
      )),
      right: const SizedBox.shrink(),
      leftFlex: 2,
      rightFlex: 8,
    );
  }
}
