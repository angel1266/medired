import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medired/core/bloc/message/message_bloc.dart';
import 'package:medired/core/extensions/converter.dart';
import 'package:medired/core/value_objects/appointment_status.dart';
import 'package:medired/core/value_objects/medical_specialization.dart';
import 'package:medired/core/value_objects/service_type.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/points/presentation/bloc/points_bloc.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment_info.dart';
import 'package:medired/features/single_appointment/presentation/bloc/single_appointment_bloc.dart';
import 'package:medired/ui/organisms/points_form.dart';
import 'package:medired/ui/template/points_template.dart';

class CreatePointsPage extends StatefulWidget {
  const CreatePointsPage({super.key, required this.suscrip});
  final Function suscrip;

  @override
  State<CreatePointsPage> createState() => _CreatePointsPageState();
}

class _CreatePointsPageState extends State<CreatePointsPage> {
  List<MedicalSpecialization> specializations = [];
  List<MedicalTest> tests = [];
  final TextEditingController commentController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  Patient? patient;
  ServiceProvider? serviceProvider;
  dynamic serviceType;
  dynamic medicalSpecialization;
  MedicalTest? medicalTest;

  @override
  void initState() {
    super.initState();
    var state = context.read<AuthBloc>().state;
    if (state is AuthenticatedState<ServiceProvider>) {
      specializations = state.user.medicalSpecializations;
      tests = state.user.medicalTests;
      serviceProvider = state.user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PointsBloc, PointsState>(
      listener: _listenPoints,
      builder: (context, state) {
        if (state is LoadingPoints) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SuccessFormPoints) {
          return PointsTemplate(
            body: PointsForm(
              suscrip: widget.suscrip,
              controller: commentController,
              amountController: amountController,
              patients: state.patients,
              selectedPatient: patient?.fullName ?? '',
              selectedServiceType: serviceType,
              selectedSpecialization: medicalSpecialization,
              specializations: state.specializationOptions(specializations),
              tests: state.testOptions(tests),
              onChangedServiceType: (newValue) {
                setState(() {
                  serviceType = newValue;
                });
                context
                    .read<PointsBloc>()
                    .add(SelectServiceType(newValue, state.patients));
              },
              onChangedSpecialization: (newValue) {
                context
                    .read<PointsBloc>()
                    .add(SelectSpecialization(newValue, state.patients));
                setState(() {
                  medicalSpecialization = newValue;
                });
              },
              onChangedTest: (newValue) {
                context
                    .read<PointsBloc>()
                    .add(SelectTest(newValue!, state.patients));
                setState(() {
                  medicalTest = newValue;
                });
              },
              selectedTest: state.selectedTest,
              onSelected: (item) {
                context
                    .read<PointsBloc>()
                    .add(SelectPatient(item.data, state.patients));
                setState(() {
                  patient = item.data;
                  print(patient!.fullName);
                });
              },
              onPressed: () => _savePoints(),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _savePoints() {
    print('entramos....');
    print(medicalSpecialization);

    /* if (serviceType == ServiceType.medicalConsultation) {*/
    context.read<SingleAppointmentBloc>().add(AddConsultationAppointment(
          medicalSpecialization: medicalSpecialization!,
          appointmentInfo: AppointmentInfo(
            serviceProvider: serviceProvider!.toAppointedServiceProvider(),
            serviceType: serviceType!,
            patient: patient!.toAppointedPatient(),
            date: DateTime.now(),
            description: commentController.text,
            status: AppointmentStatus.authorized,
          ),
        ));
    /*  } else {
      context.read<SingleAppointmentBloc>().add(AddTestAppointment(
            medicalTest: medicalTest!,
            appointmentInfo: AppointmentInfo(
              serviceProvider: serviceProvider!.toAppointedServiceProvider(),
              serviceType: serviceType!,
              patient: patient!.toAppointedPatient(),
              date: DateTime.now(),
              description: commentController.text,
              status: AppointmentStatus.authorized,
            ),
          ));
    }*/

    context.read<PointsBloc>().add(SavePoints(
          uid: patient!.authInfo.uid!,
          amount: int.parse(amountController.text) ~/ 100,
        ));
  }

  void _listenPoints(BuildContext context, PointsState state) {
    if (state is ErrorGetActiveSubscriptions) {
      context.read<MessageBloc>().add(DisplayMessage(state.error));
    } else if (state is SuccessSavePoints) {
      context.read<MessageBloc>().add(const DisplayMessage('Puntos guardados'));
      Navigator.of(context).pop();
    }
  }
}
