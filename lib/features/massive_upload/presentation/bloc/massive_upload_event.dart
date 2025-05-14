part of 'massive_upload_bloc.dart';

sealed class MassiveUploadEvent extends Equatable {
  const MassiveUploadEvent();

  @override
  List<Object> get props => [];
}

class UploadUsers extends MassiveUploadEvent {
  final List<Patient> patientList;
  final String arsUID;

  const UploadUsers({
    required this.patientList,
    required this.arsUID,
  });
}

class SignUpPatient extends MassiveUploadEvent {
  final Patient patient;

  const SignUpPatient({required this.patient});

  @override
  List<Object> get props => [patient];
}

class ReadFile extends MassiveUploadEvent {
  final Uint8List bytes;
  final String arsUID;

  const ReadFile({
    required this.bytes,
    required this.arsUID,
  });
}

class SavePatient extends MassiveUploadEvent {
  final auth.User user;
  final Patient patient;
  final String password;

  const SavePatient({
    required this.user,
    required this.patient,
    required this.password,
  });
}

class CancelUpload extends MassiveUploadEvent {
  const CancelUpload();
}

class UploadUIDs extends MassiveUploadEvent {
  final List<String> uids;

  const UploadUIDs({required this.uids});
}
