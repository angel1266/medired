part of 'medical_tests_bloc.dart';

sealed class MedicalTestsState extends Equatable {
  const MedicalTestsState();

  @override
  List<Object> get props => [];
}

final class UnloadedMedicalTests extends MedicalTestsState {}

final class LoadingMedicalTests extends MedicalTestsState {}

final class SuccessMedicalTests extends MedicalTestsState {
  const SuccessMedicalTests();
}

final class SuccessGetMedicalTests extends SuccessMedicalTests {
  final List<MedicalTest> medicalTests;
  const SuccessGetMedicalTests({required this.medicalTests});

  @override
  List<Object> get props => [medicalTests];
}

final class ErrorMedicalTests extends MedicalTestsState {
  final String error;
  const ErrorMedicalTests(this.error);

  String get genericError => 'Error medical tests';

  @override
  List<Object> get props => [error];
}

final class ErrorGetMedicalTests extends ErrorMedicalTests {
  const ErrorGetMedicalTests(super.error);

  @override
  String get genericError => 'Error getting medical tests';
}
