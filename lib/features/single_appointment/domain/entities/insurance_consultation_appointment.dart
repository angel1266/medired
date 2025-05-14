import 'package:medired/features/single_appointment/data/models/insurance_consultation_appointment_model.dart';
import 'package:medired/features/single_appointment/domain/entities/consultation_appointment.dart';
import 'package:medired/features/single_appointment/domain/mixins/insurance_covered.dart';

class InsuranceConsultationAppointment extends ConsultationAppointment
    implements InsuranceCovered {
  const InsuranceConsultationAppointment({
    required super.medicalSpecialization,
    required super.id,
    required super.appointmentInfo,
  });

  @override
  toJson() => InsuranceConsultationAppointmentModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) =>
      InsuranceConsultationAppointmentModel.fromJson(json);
}
