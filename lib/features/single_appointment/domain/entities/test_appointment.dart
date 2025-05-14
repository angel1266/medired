import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/single_appointment/data/models/test_appointment_model.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment.dart';

class TestAppointment extends Appointment {
  final MedicalTest medicalTest;

  const TestAppointment({
    required this.medicalTest,
    required super.appointmentInfo,
    required super.id,
  });

  @override
  toJson() => TestAppointmentModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => TestAppointmentModel.fromJson(json);
}
