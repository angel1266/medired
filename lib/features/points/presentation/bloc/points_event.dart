part of 'points_bloc.dart';

sealed class PointsEvent extends Equatable {
  const PointsEvent();

  @override
  List<Object> get props => [];
}

final class GetActiveSubscriptions extends PointsEvent {
  @override
  List<Object> get props => [];
}

final class SelectPatient extends PointsEvent {
  final Patient patient;
  final List<Patient> patients;

  const SelectPatient(this.patient, this.patients);
}

final class SelectTest extends PointsEvent {
  final MedicalTest test;
  final List<Patient> patients;

  const SelectTest(this.test, this.patients);
}

final class SelectSpecialization extends PointsEvent {
  final dynamic specialization;
  final List<Patient> patients;

  const SelectSpecialization(this.specialization, this.patients);
}

final class SelectServiceType extends PointsEvent {
  final dynamic serviceType;
  final List<Patient> patients;

  const SelectServiceType(this.serviceType, this.patients);
}

final class SavePoints extends PointsEvent {
  final String uid;
  final int amount;
  const SavePoints({required this.uid, required this.amount});
}
