import 'package:medired/core/utils/json_serializable/serializable.dart';
import 'package:medired/core/value_objects/medical_specialization.dart';
import 'package:medired/features/single_appointment/data/models/consultation_appointment_model.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment.dart';

class ConsultationAppointment extends Appointment implements Serializable {
  final MedicalSpecialization medicalSpecialization;

  const ConsultationAppointment({
    required this.medicalSpecialization,
    required super.id,
    required super.appointmentInfo,
  });

  @override
  Map<String, dynamic> toJson() =>
      ConsultationAppointmentModel.fromEntity(this).toJson();

  @override
  Serializable fromJson(Map<String, dynamic> json) =>
      ConsultationAppointmentModel.fromJson(json);
}
