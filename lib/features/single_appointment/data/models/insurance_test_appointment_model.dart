import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/appointments/data/models/medical_test_model.dart';
import 'package:medired/features/single_appointment/data/models/appointment_info_model.dart';
import 'package:medired/features/single_appointment/domain/entities/insurance_test_appointment.dart';

part 'insurance_test_appointment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class InsuranceTestAppointmentModel extends InsuranceTestAppointment {
  @JsonKey(name: 'medicalTest')
  final MedicalTestModel medicalTestModel;
  @JsonKey(name: 'appointmentInfo')
  final AppointmentInfoModel appointmentInfoModel;

  const InsuranceTestAppointmentModel(
      {required this.medicalTestModel,
      required this.appointmentInfoModel,
      required super.id})
      : super(
          medicalTest: medicalTestModel,
          appointmentInfo: appointmentInfoModel,
        );

  factory InsuranceTestAppointmentModel.fromEntity(
          InsuranceTestAppointment entity) =>
      InsuranceTestAppointmentModel(
        medicalTestModel: MedicalTestModel.fromEntity(entity.medicalTest),
        appointmentInfoModel:
            AppointmentInfoModel.fromEntity(entity.appointmentInfo),
        id: entity.id,
      );

  factory InsuranceTestAppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$InsuranceTestAppointmentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$InsuranceTestAppointmentModelToJson(this);
}
