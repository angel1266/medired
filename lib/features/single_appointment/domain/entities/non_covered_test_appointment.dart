import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/single_appointment/data/models/non_covered_test_appointment_model.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment_info.dart';
import 'package:medired/features/single_appointment/domain/mixins/non_insurance_covered.dart';
import 'package:medired/features/single_appointment/domain/entities/test_appointment.dart';

class NonCoveredTestAppointment extends TestAppointment
    with NonInsuranceCovered {
  const NonCoveredTestAppointment({
    required this.amount,
    required super.medicalTest,
    required super.appointmentInfo,
    required super.id,
  });

  @override
  final String amount;

  @override
  set amount(String value) => amount = value;

  @override
  NonCoveredTestAppointment copyWith({
    AppointmentInfo? appointmentInfo,
    String? id,
    MedicalTest? medicalTest,
    String? amount,
    int? medSpe,
    MedicalTest? medTestName,
  }) =>
      NonCoveredTestAppointment(
        amount: amount ?? this.amount,
        medicalTest: medicalTest ?? this.medicalTest,
        appointmentInfo: appointmentInfo ?? this.appointmentInfo,
        id: id ?? this.id,
      );

  @override
  List<Object> get props => [amount, medicalTest, appointmentInfo, id];

  @override
  toJson() => NonCoveredTestAppointmentModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) =>
      NonCoveredTestAppointmentModel.fromJson(json);
}
