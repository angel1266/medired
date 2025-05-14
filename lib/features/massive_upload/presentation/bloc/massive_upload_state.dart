part of 'massive_upload_bloc.dart';

sealed class MassiveUploadState extends Equatable {
  const MassiveUploadState();

  @override
  List<Object> get props => [];
}

final class LoadingMassiveUploadState extends MassiveUploadState {}

final class LoadedPatientListState extends MassiveUploadState {
  final List<Patient> patients;

  const LoadedPatientListState({required this.patients});

  @override
  List<Object> get props => [patients];
}

final class ErrorMassiveUploadState extends MassiveUploadState {
  final String message;

  const ErrorMassiveUploadState(this.message);

  @override
  List<Object> get props => [message];
}

final class SuccessMassiveUploadState extends MassiveUploadState {
  final String message;

  const SuccessMassiveUploadState(this.message);

  @override
  List<Object> get props => [message];
}
