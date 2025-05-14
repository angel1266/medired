part of 'points_bloc.dart';

sealed class PointsState extends Equatable {
  const PointsState();

  @override
  List<Object?> get props => [];
}

final class PointsInitial extends PointsState {}

/*
--- 🌟⏳ Loading ⏳🌟 ---
*/

final class LoadingPoints extends PointsState {}

final class LoadingGetActiveSubscriptions extends LoadingPoints {}

final class LoadingSavePoints extends LoadingPoints {}

/*
--- 🌟✅ Loaded ✅🌟 ---
*/

final class SuccessPoints extends PointsState {
  const SuccessPoints();
}

final class SuccessFormPoints extends SuccessPoints {
  final List<Patient> patients;

  const SuccessFormPoints({required this.patients});

  String get selectedPatient => '';
  int get selectedServiceType => 0;
  int get selectedSpecialization => 0;
  MedicalTest? get selectedTest => null;

  Map<MedicalSpecialization, String> specializationOptions(
          List<MedicalSpecialization> specializations) =>
      {
        for (var e in specializations)
          e: medicalSpecializationToString[e] ?? '',
      };

  Map<MedicalTest, String> testOptions(List<MedicalTest> tests) => {
        for (var e in tests) e: e.name,
      };

  @override
  List<Object?> get props => [patients];
}

final class SuccessGetActiveSubscriptions extends SuccessFormPoints {
  const SuccessGetActiveSubscriptions({required super.patients});

  @override
  List<Object> get props => [patients];
}

final class SuccessSelectedPatient extends SuccessFormPoints {
  final Patient patient;

  const SuccessSelectedPatient(
      {required super.patients, required this.patient});

  @override
  String get selectedPatient => patient.fullName;

  @override
  List<Object> get props => [patients, patient];
}

final class SuccessSelectedServiceType extends SuccessFormPoints {
  final dynamic serviceType;

  const SuccessSelectedServiceType(
      {required super.patients, required this.serviceType});

  @override
  int get selectedServiceType => serviceType.index;

  @override
  List<Object> get props => [patients, serviceType];
}

final class SuccessSelectedSpecialization extends SuccessFormPoints {
  final dynamic specialization;

  const SuccessSelectedSpecialization(
      {required super.patients, required this.specialization});

  @override
  int get selectedSpecialization => specialization.index;

  @override
  List<Object> get props => [patients, specialization];
}

final class SuccessSelectedTest extends SuccessFormPoints {
  final MedicalTest test;

  const SuccessSelectedTest({required super.patients, required this.test});

  @override
  int get selectedServiceType => 1;
  @override
  MedicalTest get selectedTest => test;

  @override
  List<Object> get props => [patients, test];
}

final class SuccessSavePoints extends SuccessPoints {
  const SuccessSavePoints();
}

/*
--- 🌟❌ Error ❌🌟 ---
*/

final class ErrorPoints extends PointsState {
  final String error;

  const ErrorPoints(this.error);

  String get genericError => 'Error payment';

  @override
  List<Object> get props => [error];
}

final class ErrorGetActiveSubscriptions extends ErrorPoints {
  @override
  String get genericError => 'Error getting active subscriptions';

  const ErrorGetActiveSubscriptions(super.error);
}

final class ErrorSavePoints extends ErrorPoints {
  @override
  String get genericError => 'Error saving points';

  const ErrorSavePoints(super.error);
}
