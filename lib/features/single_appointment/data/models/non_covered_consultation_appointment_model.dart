import 'package:json_annotation/json_annotation.dart';
import 'package:medired/core/value_objects/medical_specialization.dart';
import 'package:medired/features/single_appointment/data/models/appointment_info_model.dart';
import 'package:medired/features/single_appointment/domain/entities/non_covered_consultation_appointment.dart';

part 'non_covered_consultation_appointment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class NonCoveredConsultationAppointmentModel
    extends NonCoveredConsultationAppointment {
  @JsonKey(name: 'appointmentInfo')
  final AppointmentInfoModel appointmentInfoModel;

  const NonCoveredConsultationAppointmentModel({
    required super.medicalSpecialization,
    required super.id,
    required this.appointmentInfoModel,
    required super.amount,
  }) : super(
          appointmentInfo: appointmentInfoModel,
        );

  factory NonCoveredConsultationAppointmentModel.fromEntity(
    NonCoveredConsultationAppointment entity,
  ) {
    return NonCoveredConsultationAppointmentModel(
      medicalSpecialization: entity.medicalSpecialization,
      appointmentInfoModel:
          AppointmentInfoModel.fromEntity(entity.appointmentInfo),
      amount: entity.amount,
      id: entity.id,
    );
  }

  factory NonCoveredConsultationAppointmentModel.fromJson(
          Map<String, dynamic> json) =>
      _$NonCoveredConsultationAppointmentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$NonCoveredConsultationAppointmentModelToJson(this);
}
