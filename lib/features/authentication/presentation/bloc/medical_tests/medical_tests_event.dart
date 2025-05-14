part of 'medical_tests_bloc.dart';

sealed class MedicalTestsEvent extends Equatable {
  const MedicalTestsEvent();

  @override
  List<Object> get props => [];
}

final class GetMedicalTests extends MedicalTestsEvent {}
