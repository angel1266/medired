import 'package:medired/features/single_appointment/data/models/insurance_test_appointment_model.dart';
import 'package:medired/features/single_appointment/domain/entities/test_appointment.dart';
import 'package:medired/features/single_appointment/domain/mixins/insurance_covered.dart';

class InsuranceTestAppointment extends TestAppointment with InsuranceCovered {
  const InsuranceTestAppointment({
    required super.medicalTest,
    required super.appointmentInfo,
    required super.id,
  });

  @override
  toJson() => InsuranceTestAppointmentModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) =>
      InsuranceTestAppointmentModel.fromJson(json);
}
