import 'package:json_annotation/json_annotation.dart';
import 'package:medired/features/authentication/authentication_export.dart';
import 'package:medired/features/single_appointment/domain/entities/appointed_patient.dart';
part 'appointed_patient_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AppointedPatientModel extends AppointedPatient {
  const AppointedPatientModel({
    required super.uid,
    required super.firstName,
    required super.lastName,
  });

  factory AppointedPatientModel.fromEntity(AppointedPatient appointedPatient) {
    return AppointedPatientModel(
      uid: appointedPatient.uid,
      firstName: appointedPatient.firstName,
      lastName: appointedPatient.lastName,
    );
  }

  factory AppointedPatientModel.fromPatient(Patient patient) {
    return AppointedPatientModel(
      uid: patient.authInfo.uid!,
      firstName: patient.personalInfo.firstName,
      lastName: patient.personalInfo.lastName,
    );
  }

  factory AppointedPatientModel.fromJson(Map<String, dynamic> json) =>
      _$AppointedPatientModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppointedPatientModelToJson(this);
}
