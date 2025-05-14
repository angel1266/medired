import 'package:medired/core/value_objects/medical_specialization.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/single_appointment/data/models/non_covered_consultation_appointment_model.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment_info.dart';
import 'package:medired/features/single_appointment/domain/entities/consultation_appointment.dart';
import 'package:medired/features/single_appointment/domain/mixins/non_insurance_covered.dart';

class NonCoveredConsultationAppointment extends ConsultationAppointment
    with NonInsuranceCovered {
  const NonCoveredConsultationAppointment({
    required this.amount,
    required super.medicalSpecialization,
    required super.appointmentInfo,
    required super.id,
  });

  @override
  final String amount;

  @override
  set amount(String value) => amount = value;

  @override
  NonCoveredConsultationAppointment copyWith({
    String? amount,
    MedicalSpecialization? medicalSpecialization,
    AppointmentInfo? appointmentInfo,
    String? id,
    int? medSpe,
    MedicalTest? medTestName,
  }) =>
      NonCoveredConsultationAppointment(
        amount: amount ?? this.amount,
        medicalSpecialization:
            medicalSpecialization ?? this.medicalSpecialization,
        appointmentInfo: appointmentInfo ?? this.appointmentInfo,
        id: id ?? this.id,
      );

  @override
  toJson() => NonCoveredConsultationAppointmentModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) =>
      NonCoveredConsultationAppointmentModel.fromJson(json);
}
