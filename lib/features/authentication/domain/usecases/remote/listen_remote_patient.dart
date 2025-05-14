import 'package:medired/core/core_export.dart';
import 'package:medired/features/authentication/authentication_export.dart';

class ListenRemotePatientUseCase {
  final PatientRepository _patientRepo;

  ListenRemotePatientUseCase(this._patientRepo);

  Stream<DataState<Patient>> call({required String uid}) {
    return _patientRepo.listenRemotePatient(uid);
  }
}
