import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/appointments/data/models/medical_test_model.dart';
import 'package:medired/features/single_appointment/data/models/appointment_info_model.dart';
import 'package:medired/features/single_appointment/domain/mixins/insurance_covered.dart';
import 'package:medired/features/single_appointment/domain/entities/test_appointment.dart';

part 'test_appointment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class TestAppointmentModel extends TestAppointment implements InsuranceCovered {
  @JsonKey(name: 'medicalTest')
  final MedicalTestModel medicalTestModel;
  @JsonKey(name: 'appointmentInfo')
  final AppointmentInfoModel appointmentInfoModel;
  const TestAppointmentModel({
    required super.id,
    required this.medicalTestModel,
    required this.appointmentInfoModel,
  }) : super(
          medicalTest: medicalTestModel,
          appointmentInfo: appointmentInfoModel,
        );

  factory TestAppointmentModel.fromEntity(
    TestAppointment entity,
  ) {
    return TestAppointmentModel(
      medicalTestModel: MedicalTestModel.fromEntity(entity.medicalTest),
      appointmentInfoModel:
          AppointmentInfoModel.fromEntity(entity.appointmentInfo),
      id: entity.id,
    );
  }

  factory TestAppointmentModel.fromJson(Map<String, dynamic> json) =>
      _$TestAppointmentModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TestAppointmentModelToJson(this);
}
