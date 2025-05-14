import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/appointments/data/models/medical_test_model.dart';
import 'package:medired/features/single_appointment/data/models/appointment_info_model.dart';
import 'package:medired/features/single_appointment/domain/entities/non_covered_test_appointment.dart';

part 'non_covered_test_appointment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NonCoveredTestAppointmentModel extends NonCoveredTestAppointment {
  @JsonKey(name: 'medicalTest')
  final MedicalTestModel medicalTestModel;
  @JsonKey(name: 'appointmentInfo')
  final AppointmentInfoModel appointmentInfoModel;

  const NonCoveredTestAppointmentModel({
    required super.amount,
    required super.id,
    required this.medicalTestModel,
    required this.appointmentInfoModel,
  }) : super(
          medicalTest: medicalTestModel,
          appointmentInfo: appointmentInfoModel,
        );

  factory NonCoveredTestAppointmentModel.fromEntity(
    NonCoveredTestAppointment entity,
  ) {
    return NonCoveredTestAppointmentModel(
      medicalTestModel: MedicalTestModel.fromEntity(entity.medicalTest),
      appointmentInfoModel:
          AppointmentInfoModel.fromEntity(entity.appointmentInfo),
      amount: entity.amount,
      id: entity.id,
    );
  }

  factory NonCoveredTestAppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$NonCoveredTestAppointmentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$NonCoveredTestAppointmentModelToJson(this);
}
