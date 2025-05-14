import 'package:medired/core/core_export.dart';
import 'package:medired/core/utils/json_serializable/serializable.dart';
import 'package:medired/features/appointments/data/models/medical_test_model.dart';
import 'package:medired/features/appointments/domain/entities/medical_test.dart';
import 'package:medired/features/single_appointment/data/models/appointment_model.dart';
import 'package:medired/features/single_appointment/domain/entities/appointment_info.dart';

class Appointment extends Equatable implements Serializable {
  final String id;
  final AppointmentInfo appointmentInfo;
  final int? medSpe;
  final MedicalTestModel? medTestName;

  const Appointment({
    required this.id,
    required this.appointmentInfo,
    this.medSpe,
    this.medTestName,
  });

  factory Appointment.toEntity(AppointmentModel appointmentModel) {
    return Appointment(
      id: appointmentModel.id,
      appointmentInfo: appointmentModel.appointmentInfo,
      medSpe: appointmentModel.medSpe,
      medTestName: appointmentModel.medTestName,
    );
  }

  Appointment copyWith({
    String? id,
    AppointmentInfo? appointmentInfo,
    int? medSpe,
    MedicalTestModel? medTestName,
  }) =>
      Appointment(
        id: id ?? this.id,
        appointmentInfo: appointmentInfo ?? this.appointmentInfo,
        medSpe: medSpe ?? this.medSpe,
        medTestName: medTestName ?? this.medTestName,
      );

  @override
  List<Object?> get props => [id, appointmentInfo, medSpe, medTestName];

  @override
  toJson() => AppointmentModel.fromEntity(this).toJson();

  @override
  fromJson(Map<String, dynamic> json) => AppointmentModel.fromJson(json);
}
