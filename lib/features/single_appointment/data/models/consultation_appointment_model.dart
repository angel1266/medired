import 'package:json_annotation/json_annotation.dart';
import 'package:medired/core/value_objects/medical_specialization.dart';
import 'package:medired/features/single_appointment/data/models/appointment_info_model.dart';
import 'package:medired/features/single_appointment/domain/entities/consultation_appointment.dart';

part 'consultation_appointment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ConsultationAppointmentModel extends ConsultationAppointment {
  @JsonKey(name: 'appointmentInfo')
  final AppointmentInfoModel appointmentInfoModel;

  const ConsultationAppointmentModel({
    required super.id,
    required super.medicalSpecialization,
    required this.appointmentInfoModel,
  }) : super(
          appointmentInfo: appointmentInfoModel,
        );

  factory ConsultationAppointmentModel.fromEntity(
          ConsultationAppointment entity) =>
      ConsultationAppointmentModel(
        id: entity.id,
        medicalSpecialization: entity.medicalSpecialization,
        appointmentInfoModel:
            AppointmentInfoModel.fromEntity(entity.appointmentInfo),
      );

  factory ConsultationAppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$ConsultationAppointmentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ConsultationAppointmentModelToJson(this);
}
