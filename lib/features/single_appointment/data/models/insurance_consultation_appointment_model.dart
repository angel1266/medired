import 'package:json_annotation/json_annotation.dart';
import 'package:medired/core/value_objects/medical_specialization.dart';
import 'package:medired/features/single_appointment/data/models/appointment_info_model.dart';
import 'package:medired/features/single_appointment/domain/entities/insurance_consultation_appointment.dart';

part 'insurance_consultation_appointment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class InsuranceConsultationAppointmentModel
    extends InsuranceConsultationAppointment {
  @JsonKey(name: 'appointmentInfo')
  final AppointmentInfoModel appointmentInfoModel;
  const InsuranceConsultationAppointmentModel({
    required super.medicalSpecialization,
    required this.appointmentInfoModel,
    required super.id,
  }) : super(
          appointmentInfo: appointmentInfoModel,
        );

  factory InsuranceConsultationAppointmentModel.fromEntity(
    InsuranceConsultationAppointment entity,
  ) {
    return InsuranceConsultationAppointmentModel(
      medicalSpecialization: entity.medicalSpecialization,
      appointmentInfoModel:
          AppointmentInfoModel.fromEntity(entity.appointmentInfo),
      id: entity.id,
    );
  }

  factory InsuranceConsultationAppointmentModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$InsuranceConsultationAppointmentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() =>
      _$InsuranceConsultationAppointmentModelToJson(this);
}
