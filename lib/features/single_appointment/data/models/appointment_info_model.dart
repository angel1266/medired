import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:medired/core/utils/json_serializable/time_stamp_converter.dart';
import 'package:medired/core/value_objects/appointment_status.dart';
import 'package:medired/core/value_objects/service_type.dart';
import 'package:medired/features/single_appointment/data/models/appointed_patient_model.dart';
import 'package:medired/features/single_appointment/data/models/appointed_service_provider_model.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment_info.dart';

part 'appointment_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointmentInfoModel extends AppointmentInfo {
  @JsonKey(name: 'serviceProvider')
  final AppointedServiceProviderModel appointedServiceProviderModel;

  @JsonKey(name: 'patient')
  final AppointedPatientModel appointedPatientModel;

  @TimestampConverter()
  @override
  DateTime get date => super.date;

  set date(DateTime value) {
    super.copyWith(date: value);
  }

  const AppointmentInfoModel(
      {required this.appointedPatientModel,
      required this.appointedServiceProviderModel,
      required super.date,
      required super.description,
      required super.status,
      required super.serviceType})
      : super(
          patient: appointedPatientModel,
          serviceProvider: appointedServiceProviderModel,
        );

  factory AppointmentInfoModel.fromEntity(AppointmentInfo appointmentInfo) =>
      AppointmentInfoModel(
          appointedPatientModel:
              AppointedPatientModel.fromEntity(appointmentInfo.patient),
          appointedServiceProviderModel:
              AppointedServiceProviderModel.fromEntity(
                  appointmentInfo.serviceProvider),
          date: appointmentInfo.date,
          description: appointmentInfo.description,
          status: appointmentInfo.status,
          serviceType: appointmentInfo.serviceType);

  factory AppointmentInfoModel.fromJson(Map<String, dynamic> json) =>
      _$AppointmentInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentInfoModelToJson(this);
}
