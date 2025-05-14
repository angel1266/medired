import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/appointments/data/models/medical_test_model.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/single_appointment/data/models/appointment_info_model.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment.dart';

part 'appointment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointmentModel extends Appointment {
  @JsonKey(name: 'appointmentInfo')
  final AppointmentInfoModel appointmentInfoModel;

  @override
  @JsonKey(name: 'medicalSpecialization', includeIfNull: false)
  final int? medSpe;

  @override
  @JsonKey(name: 'medicalTest', includeIfNull: false)
  final MedicalTestModel? medTestName;

  const AppointmentModel({
    required super.id,
    required this.appointmentInfoModel,
    this.medSpe,
    this.medTestName,
  }) : super(
            appointmentInfo: appointmentInfoModel,
            medSpe: medSpe,
            medTestName: medTestName);

  factory AppointmentModel.fromEntity(Appointment appointment) =>
      AppointmentModel(
          id: appointment.id,
          appointmentInfoModel:
              AppointmentInfoModel.fromEntity(appointment.appointmentInfo),
          medSpe: appointment.medSpe,
          medTestName: appointment.medTestName);

  factory AppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppointmentModelToJson(this);
}
